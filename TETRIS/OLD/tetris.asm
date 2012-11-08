; YATe (Yet Another Tetris)
; version 0.8
; 
; Luis Felipe Garlet Millani

; the tetrads:
;  00	  01	  02	  03	  04	  05	  06
;||||||	  ||||	||||	||||	||||||	||||||	||||||||
;  ||	||||	  ||||	||||	    ||	||
.model small
.stack
.data
	SQUARESIZE		EQU 10
	VIDEOX			EQU 320
	VIDEOY			EQU 200
	PLAYLEFT		EQU 10
	PLAYRIGHT		EQU 110
	PLAYMID			EQU 60
	TETRADSTOTAL	EQU 7	; total number of tetrads
	
	; keys
	UP		EQU 48h
	DOWN	EQU 50h
	LEFT	EQU 4bh
	RIGHT	EQU 4dh 
	
	rseed		DW 2 DUP(?) ; random seed
	delay0		DW 0h;0fh		; starting delay (big number == slow,boring game) ; position MUST be just before timer
	delay1		DW 010h;015h;4240h
	timer		DW (?) ; high order word of tick count ; must be placed exactly after delay1 or else... exactly!
				DW (?) ; low order word of tick count
	
	tetrad		DB 8 DUP(?)	;0-3:the falling block´s column (left,middle left,middle right,right)
							;4-7:how many blocks in that column
	tetradinfo	DW 2 (?) ; position (center x and center y)
				DB (?)	; color
	tetradmodel	DB 2,2,2,0,1,2,1,0 ; T
				DB 3,2,2,0,1,2,1,0 ; S
				DB 2,2,3,0,1,2,1,0 ; Z
				DB 2,2,0,0,2,2,0,0 ; O
				DB 2,2,2,0,1,1,2,0 ; J
				DB 2,2,2,0,2,1,1,0 ; L
				DB 2,2,2,2,1,1,1,1 ; I
	thematrix	DB 16 DUP(?)
	rotatedmatrix	DB 16 DUP(?)
	chkpixelPos	DB 1 (?)
	SPACES		DB 80 DUP(32)
	BOXTOP		DB 80 DUP('+')
	BOXMID		DB '+', 78 DUP(32),'+'
.code
	mov ax,@data
	mov ds,ax
	mov ax,0A000h
	mov es,ax
	
	mov ax,13h 	; mode = 13h 
	int 10h 	; call bios service
	
	; set keyboard repeat rate
	mov al,5h
	xor bh,bh
	mov bl,0ffh
	int 16h
	
	; randomize seed
	xor ah,ah
	int 1ah ; Read System Clock Counter
	xchg ch,cl
	add cx,dx
	mov [rseed],cx
	
	; draw borders
	;left
	mov al,7	;color
	xor bx,bx ; x
	xor cx,cx	;y
	mov si,10	; width
	mov di,VIDEOY	;height
	call drawrect
	;left wall
	mov al,8	;color
	mov bx,10 ; x
	xor cx,cx	;y
	mov si,10	; width
	mov di,VIDEOY	;height
	call drawrect
	; right wall
	mov ax,8	;color
	mov bx,120	;x
	xor cx,cx	;y
	mov si,10	; width
	mov di,VIDEOY	;height
	call drawrect
	; bottom
	mov ax,8	;color
	mov bx,20	;x
	mov cx,186	;y
	mov si,100	; width
	mov di,14	;height
	call drawrect
	; top
	mov ax,8	;color
	mov bx,20	;x
	xor cx,cx	;y
	mov si,100	; width
	mov di,10	;height
	call drawrect
	; right panel
	mov ax,7	;color
	mov bx,130	;x
	xor cx,cx	;y
	mov si,VIDEOX-120	; width
	mov di,VIDEOY	;height
	call drawrect
	
	
	gaming:
	call fall
	jmp gaming ; infinite loop

; this could be easily optimized
makematrix proc
	mov si,offset tetrad
	
	; fill matrix with 0s
	mov di,offset thematrix
	;push ax
	xor ax,ax
	mov cx,8
	chkpixel_loop0:
		mov [di],ax
		inc di
		inc di
	loop chkpixel_loop0
	;pop ax
	
	; let's put some 1s there too
	xor bh,bh
	mov bl,[si] ; row0
	and bx,bx
	je chkpixel_fillrow1
	; fillrow0:
		mov di,offset thematrix-1 ; -1 because we add 1+
		add di,bx
		xor bx,bx
		inc bx
		xor cx,cx
		mov cl,[si+4] ; blocks in that row
		chkpixel_fillrow0_loop0:
			mov [di],bx ; the one
			inc di
		loop chkpixel_fillrow0_loop0
	chkpixel_fillrow1:
	xor bh,bh
	inc si ; row1
	mov bl,[si] ; row1
	and bx,bx
	je chkpixel_fillrow2
	; fillrow1:
		mov di,offset thematrix-1+4 ; -1 because we add 1+; +4 because it's the row1
		add di,bx
		xor bx,bx
		inc bx
		xor cx,cx
		mov cl,[si+4] ; blocks in that row
		chkpixel_fillrow1_loop0:
			mov [di],bx ; The One enters the matrix
			inc di
		loop chkpixel_fillrow1_loop0
	chkpixel_fillrow2:
	xor bh,bh
	inc si ; row2
	mov bl,[si] ; row2
	and bx,bx
	je chkpixel_fillrow3
	; fillrow2:
		mov di,offset thematrix-1+8 ; -1 because we add 1+; +8 because it's the row2
		add di,bx
		xor bx,bx
		inc bx
		xor cx,cx
		mov cl,[si+4] ; blocks in that row
		chkpixel_fillrow2_loop0:
			mov [di],bx ; The One enters the matrix
			inc di
		loop chkpixel_fillrow2_loop0
	chkpixel_fillrow3:
	xor bh,bh
	inc si ; row3
	mov bl,[si] ; row3
	and bx,bx
	je chkpixel_matrixready
	; fillrow3:
		mov di,offset thematrix-1+12 ; -1 because we add 1+; +12 because it's the row3
		add di,bx
		xor bx,bx
		inc bx
		xor cx,cx
		mov cl,[si+4] ; blocks in that row
		chkpixel_fillrow3_loop0:
			mov [di],bx ; The One enters the matrix
			inc di
		loop chkpixel_fillrow3_loop0
	chkpixel_matrixready:
	; matrix ready, time to do something actually useful with it
	ret
makematrix endp

; this was poorly named, it actually checks for collisions
; output
; bx:00000000 00000DLR, where
;    D=1 if there's something below (or 0 otherwise)
;    R=1 if there's something in the right (or 0 otherwise)
;    L=1 if there's something in the left (or 0 otherwise)
chkpixel proc
	call makematrix
	
	mov si,offset tetrad
	mov ah,[si+8] ; center x
	mov al,[si+8+1] ; center y
	inc al
	inc al
	add al,24 ; top (y)
	add ah,30 ; right (x)
	
	; remember that ah=x and al=y
	xor dx,dx ; results
	mov si,offset thematrix-1+12 ; because we add 1 more than we should and we want to start from the last column
	mov cx,4 ; matrix column
	chkpixel_checkingmatrix: ; column
		push cx
		push ax
		mov bx,offset chkpixelPos
		mov [bx],cl
		mov cx,4
		chkpixel_checkingmatrix_rows:
			mov bx,cx
			mov ah,[si+bx] ; ah=1 if there's something on current cell
			and ah,ah
			je chkpixel_checkingmatrix_rows_freecell
				; ok, we got something on this cell, let's take a look around it
				
				
				; right
				pop ax
				push ax ; ah=x al=y
				mov bl,ah
				xor bh,bh ; bx=x
				xor ah,ah ; ax=y
				call chkpos
				
				;;;;;;;;;;;;;;;;;;;
				jmp chkpixel_checkingmatrixohnoes_out ; please look away =P
				chkpixel_checkingmatrix_rowsohnoes:
				jmp chkpixel_checkingmatrix_rows
				chkpixel_checkingmatrixohnoes:
				jmp chkpixel_checkingmatrix
				chkpixel_checkingmatrixohnoes_out:
				;;;;;;;;;;;;;;;;;;;
				
				and al,al
				je chkpixel_checkingmatrix_rows_left
					; there's something on the right! is it part of the tetrad?
					mov bx,offset chkpixelPos
					mov ah,[bx] ; current column
					cmp ah,4
					je chkpixel_checkingmatrix_rows_right_foundit
					mov bx,cx
					mov ah,[si+bx+4]
					cmp ah,1
					je chkpixel_checkingmatrix_rows_left ; it's part of the tetrad
					chkpixel_checkingmatrix_rows_right_foundit:
					or dx,001b ; right
				chkpixel_checkingmatrix_rows_left:
				; left
				pop ax
				push ax ; ah=x al=y
				sub ah,20 ; a little more to the left
				mov bl,ah
				xor bh,bh ; bx=x
				xor ah,ah ; ax=y
				call chkpos
				and al,al
				je chkpixel_checkingmatrix_rows_below
					; there's something on the left! is it part of the tetrad?
					mov bx,offset chkpixelPos
					mov ah,[bx] ; current column
					cmp ah,1
					je chkpixel_checkingmatrix_rows_left_foundit
					mov bx,cx
					mov ah,[si+bx-4]
					cmp ah,1
					je chkpixel_checkingmatrix_rows_below ; it's part of the tetrad
					chkpixel_checkingmatrix_rows_left_foundit:
					or dx,010b ; left
				chkpixel_checkingmatrix_rows_below:
				; below
				pop ax
				push ax ; ah=x al=y
				sub ah,10 ; center
				add al,8
				mov bl,ah
				xor bh,bh ; bx=x
				xor ah,ah ; ax=y
				call chkpos
				and al,al
				je chkpixel_checkingmatrix_rows_freecell
					; there's something below! is it part of the tetrad?
					cmp cx,4 ; current row
					je chkpixel_checkingmatrix_rows_below_foundit
					mov bx,cx
					mov ah,[si+bx+1]
					cmp ah,1
					je chkpixel_checkingmatrix_rows_freecell ; it's part of the tetrad
					chkpixel_checkingmatrix_rows_below_foundit:
					or dx,100b ; below
			chkpixel_checkingmatrix_rows_freecell:
			pop ax
			sub al,8 ; get ready for row
			push ax
		loop chkpixel_checkingmatrix_rowsohnoes
		pop ax
		add al,32 ; we subtracted this amount in the loop above
		sub ah,10
		sub si,4 ; row=row-1
		pop cx
	loop chkpixel_checkingmatrixohnoes
	ret
chkpixel endp

; checks a pixel's color
; input
; ax: y
; bx: x
; output
; al: pixel's color
; changes
; ax
chkpos proc
	push bx
    push es
	xchg ah, al
    add bx, ax
    shr ax, 2
    add bx, ax
    mov ax, 0a000h
    mov es, ax
    mov ax, cx
    mov al,es:[bx]
	
	pop es
	pop bx
	ret
chkpos endp

; changes a pixel's color
; input
; ax: y
; bx: x
; dl: color
chgpix proc
	push bx
    push es
	xchg ah, al
    add bx, ax
    shr ax, 2
    add bx, ax
    mov ax, 0a000h
    mov es, ax
    mov ax, cx
	mov es:[bx],dl
	pop es
	pop bx
	ret
chgpix endp

; if you want to optmize something, start here
chkgameover proc
	mov si,offset tetradinfo + 1 ; y
	mov ah,[si] ; y
	and ah,ah
	je gameover_man
	ret
	gameover_man:
	;G
	mov al,150 ; color
	mov bx,17*1 ; x
	mov cx,14*1 ; y
	mov si,17*3 ; width
	mov di,14*1 ; height
	call drawrect
	mov bx,17*1 ; x
	mov cx,14*2 ; y
	mov si,17*1 ; width
	mov di,14*3 ; height
	call drawrect
	mov bx,17*1 ; x
	mov cx,14*4 ; y
	mov si,17*3 ; width
	mov di,14*1 ; height
	call drawrect
	mov bx,17*3 ; x
	mov cx,14*3 ; y
	mov si,17*1 ; width
	mov di,14*1 ; height
	call drawrect
	;A
	mov bx,17*5 ; x
	mov cx,14*1 ; y
	mov si,17*3 ; width
	mov di,14*1 ; height
	call drawrect
	mov bx,17*5 ; x
	mov cx,14*2 ; y
	mov si,17*1 ; width
	mov di,14*3 ; height
	call drawrect
	mov bx,17*6 ; x
	mov cx,14*3 ; y
	mov si,17*1 ; width
	mov di,14*1 ; height
	call drawrect
	mov bx,17*7 ; x
	mov cx,14*2 ; y
	mov si,17*1 ; width
	mov di,14*3 ; height
	call drawrect
	;M
	mov bx,17*9 ; x
	mov cx,14*2 ; y
	mov si,17*1 ; width
	mov di,14*3 ; height
	call drawrect
	mov bx,17*10 ; x
	mov cx,14*1 ; y
	mov si,17*1 ; width
	mov di,14*1 ; height
	call drawrect
	mov bx,17*11 ; x
	mov cx,14*1 ; y
	mov si,17*1 ; width
	mov di,14*2 ; height
	call drawrect
	mov bx,17*12 ; x
	mov cx,14*1 ; y
	mov si,17*1 ; width
	mov di,14*1 ; height
	call drawrect
	mov bx,17*13 ; x
	mov cx,14*2 ; y
	mov si,17*1 ; width
	mov di,14*3 ; height
	call drawrect
	;E
	mov bx,17*15 ; x
	mov cx,14*1 ; y
	mov si,17*3 ; width
	mov di,14*1 ; height
	call drawrect
	mov bx,17*15 ; x
	mov cx,14*2 ; y
	mov si,17*1 ; width
	mov di,14*3 ; height
	call drawrect
	mov bx,17*16 ; x
	mov cx,14*4 ; y
	mov si,17*2 ; width
	mov di,14*1 ; height
	call drawrect
	mov bx,17*16 ; x
	mov cx,14*5/2 ; y
	mov si,17*1 ; width
	mov di,14*1 ; height
	call drawrect
	;O
	mov bx,17*2 ; x
	mov cx,14*6 ; y
	mov si,17*3 ; width
	mov di,14*1 ; height
	call drawrect
	mov bx,17*2 ; x
	mov cx,14*7 ; y
	mov si,17*1 ; width
	mov di,14*3 ; height
	call drawrect
	mov bx,17*2 ; x
	mov cx,14*9 ; y
	mov si,17*3 ; width
	mov di,14*1 ; height
	call drawrect
	mov bx,17*4 ; x
	mov cx,14*6 ; y
	mov si,17*1 ; width
	mov di,14*3 ; height
	call drawrect
	;V
	mov bx,17*6 ; x
	mov cx,14*6 ; y
	mov si,17*1 ; width
	mov di,14*2 ; height
	call drawrect
	mov bx,17*13/2 ; x
	mov cx,14*8 ; y
	mov si,17*1 ; width
	mov di,14*1 ; height
	call drawrect
	mov bx,17*7 ; x
	mov cx,14*9 ; y
	mov si,17*1 ; width
	mov di,14*1 ; height
	call drawrect
	mov bx,17*15/2 ; x
	mov cx,14*8 ; y
	mov si,17*1 ; width
	mov di,14*1 ; height
	call drawrect
	mov bx,17*8 ; x
	mov cx,14*6 ; y
	mov si,17*1 ; width
	mov di,14*2 ; height
	call drawrect
	;E
	mov bx,17*10 ; x
	mov cx,14*6 ; y
	mov si,17*3 ; width
	mov di,14*1 ; height
	call drawrect
	mov bx,17*10 ; x
	mov cx,14*7 ; y
	mov si,17*1 ; width
	mov di,14*3 ; height
	call drawrect
	mov bx,17*11 ; x
	mov cx,14*9 ; y
	mov si,17*2 ; width
	mov di,14*1 ; height
	call drawrect
	mov bx,17*11 ; x
	mov cx,14*15/2 ; y
	mov si,17*1 ; width
	mov di,14*1 ; height
	call drawrect
	;R
	mov bx,17*14 ; x
	mov cx,14*6 ; y
	mov si,17*2 ; width
	mov di,14*1 ; height
	call drawrect
	mov bx,17*14 ; x
	mov cx,14*7 ; y
	mov si,17*1 ; width
	mov di,14*3 ; height
	call drawrect
	mov bx,17*16 ; x
	mov cx,14*7 ; y
	mov si,17*1 ; width
	mov di,14*1 ; height
	call drawrect
	mov bx,17*15 ; x
	mov cx,14*8 ; y
	mov si,17*1 ; width
	mov di,14*1 ; height
	call drawrect
	mov bx,17*16 ; x
	mov cx,14*9 ; y
	mov si,17*1 ; width
	mov di,14*1 ; height
	call drawrect
	
	mov dx,020h
	call sleep
	
	xor ax,ax 	; function 00h - get a key
	int 16h 	; call BIOS service
	
	mov ax,3 	; mode = 3
	int 10h 	; call BIOS service

	mov ax,4C00h	; return 0
	int 21h
chkgameover endp


; actually this just flashes the current line, removes it and shifts down the lines above the given line
; input
; cx:y
kill proc
	push bx
	push es
	push di
	push si
	push cx
	
	; flash wanted line
	mov al,100 ; color
	mov bx,20 ; x
	;cx is correct already
	mov si,100 ; width
	mov di,8 ; height
	call drawrect
	
	push dx
	mov dx,1h
	call sleep
	pop dx
	
	pop cx
	push cx
	add cx,7
	kill_loop0:
		push cx
		mov cx,119
		kill_loop1:
			pop ax ; y
			push ax
			sub ax,8
			mov bx,cx
			call chkpos
			mov dl,al
			pop ax
			push ax
			call chgpix
		loop kill_loop1
		pop cx
		dec cx
		cmp cx,20
	jg kill_loop0
	
	pop cx
	pop si
	pop di
	pop es
	pop bx
	ret
kill endp

;for last_line to first line
;   checkline(currentline)
;      if complete
;         flash(currentline)
;          kill(currentline)
;          for currentline+1 to first line
;              movelinedown(currentline)
chklines proc
	push ax
	push bx
	push cx
	push dx
	push es
	push di
	
	mov cx,178 ; the last row's y + 1
	chklines_loop0:
		xor dx,dx
		inc dx ; dx = 1b
		
		push cx ; row
		mov cx,10 ; columns
		chklines_loop1:
			push cx
			mov ax,10
			inc cl
			mul cl ; ax = current x, goes from 110 to 20
			mov bx,ax ; x
			pop cx
			pop ax ; y
			push ax
			call chkpos
			and al,al
			jne chklines_ok
				xor dx,dx
			chklines_ok:
				and dx,1b ;;;;;;;;;;;; efficiency? what's that?
		loop chklines_loop1
		pop cx
		and dx,dx
		je chklines_notfull
		call kill
		add cx,8 ; let's check this row again
		
		; faster
		push bx
		mov bx,offset delay1
		mov dx,[bx]
		and dx,dx
		je chklines_nospeedchg
			dec dx
			mov [bx],dx
		chklines_nospeedchg:
		pop bx
		
		chklines_notfull:
		;pop ax ; throw away
		;inc cx ; infinite loop = bad (we're subtracting somewhere else)
		sub cx,8 ; so that cx will be = 0 before the loop ends
		cmp cx,12
		
		
	jge chklines_loop0
	
	pop di
	pop es
	pop dx
	pop cx
	pop bx
	pop ax
	ret
chklines endp

; while not (hitsomething)
;   draw(tetrad)
;   chkmove(speed)
;   user input
;   dec y
fall proc
	call rand ; dx=pseudo-random number
	push dx
	
	; copy selected tetrad into variable tetrad
	mov ax,8
	mul dx
	mov si,ax
	add si, offset tetradmodel
	mov di, offset tetrad
	xor bx,bx
	mov cx,8
	fall_loop0:
		mov ah,[si+bx]
		mov [di+bx],ah
		inc bx
	loop fall_loop0
	
	
	mov bx,offset tetradinfo ; could be easily optimized a little
	xor ax,ax
	mov al,PLAYMID
	mov di,ax
	mov [bx],ax ; stores x and y
	inc bx ; point to y
	inc bx ; point to color
	xor si,si
	pop ax ; color
	inc ax ; we do not want a black tetrad
	mov [bx],al
	
	call drawtetrad
	; tetrad drawn
	
	
	fall_hitcheck:
	mov si,offset tetradinfo
	mov bx,[si] ; bh=center y, bl=center x
	push bx
	mov si,offset tetrad
	; fall_hitcheck_row0
		mov ah,[si] ; ah = row0
		mov al,[si+4] ; al = blocks in row0
		inc si
		and ah,ah
		;je fall_hitcheck_row1
		sub bl,10 ; x = x - 10
		push bx
		mov bl,10
		mul bl ; al blocks of bx pixels each
		pop bx
		add al,bh ; al = position below the last block of the current row
		call chkpixel
		and dx,100b ; something below?
		pop bx;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		je fall_nohit
		call chklines
		call chkgameover
		ret
	fall_nohit:
		call playtime
		
		; going down
		mov si,offset tetradinfo 
		xor ax,ax
		mov al,[si]
		mov di,ax
		inc si
		mov al,[si]
		mov si,ax
		xor al,al ; black
		call drawtetrad
		mov si,offset tetradinfo 
		;xor ax,ax ; ax=0 already
		mov al,[si]
		mov di,ax ; x
		inc si
		xor bx,bx
		mov bl,[si]
		add bl,8
		mov [si],bl
		inc si
		mov al,[si]
		mov si,bx
		call drawtetrad
		
	jmp fall_hitcheck
fall endp


; THIS REALLY SHOULD BE A MACRO
; output
; al: scancode of pressed key
; changes
; ax,dx
getkeyh proc
	in al,60h
	xchg dx,ax
	xor  ax,ax ; assume no key
	test dl,10000000b
	jnz getkeyh_if0
		mov  al,dl
	getkeyh_if0:
	
	; xor ax,ax
	; inc ax
	; int 016h
	
	;clear buffer
	; push ax
	; xor ax,ax
	; int 16h
	; pop ax
	
	ret
getkeyh endp


; (supposed to) clear the buffer
 clbuf proc
	 push ax
	 xor ax,ax
	 int 16h
	 pop ax
	 ret
 clbuf endp

; rotates a matrix
rotatematrix proc
	; i dare you to make this slower
	mov si,offset thematrix
	mov di,offset rotatedmatrix
	mov al,[si+0] ; start of column0
	mov [di+8],al
	mov al,[si+4]
	mov [di+9],al
	mov al,[si+8]
	mov [di+10],al
	mov al,[si+12]
	mov [di+11],al ; end of column0
	
	mov al,[si+1] ; start of column1
	mov [di+4],al
	mov al,[si+5]
	mov [di+5],al
	mov al,[si+9]
	mov [di+6],al
	mov al,[si+13]
	mov [di+7],al ; end of column1
	
	mov al,[si+2] ; start of column2
	mov [di+0],al
	mov al,[si+6]
	mov [di+1],al
	mov al,[si+10]
	mov [di+2],al
	mov al,[si+14]
	mov [di+3],al ; end of column2
	
	mov al,[si+3] ; start of column3
	mov [di+12],al
	mov al,[si+7]
	mov [di+13],al
	mov al,[si+11]
	mov [di+14],al
	mov al,[si+15]
	mov [di+15],al ; end of column3
	ret
rotatematrix endp

; rotates a tetrad
rotate proc
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	
	call makematrix
	
	call rotatematrix
	
	; let's hide the tetrad (not really necessary, but as it makes my life easier so be it)
	mov si,offset tetradinfo
	
	mov ax,[si] ; ah=center y, al=center x
	xor bh,bh
	mov bl,ah
	sub bx,8 ; bottom (y)
	add ax,20 ; right (x)
	xor ah,ah
	push ax ; right (x)
	push bx ; bottom (y)
	
	xor ax,ax
	mov al,[si]
	mov di,ax
	inc si
	mov al,[si]
	mov si,ax
	xor al,al ; black
	call drawtetrad
	; invisible tetrad
	
	
	; now we'll check if there'll be no collisions if we rotate it
	mov si,offset rotatedmatrix -1 ; minus 1 because of the (following) loop
	mov cx,12 ; columns*rows
	xor ah,ah ; this will be 1 (after the loop) if we have at least one collision
	rotate_collision_loop0:
		push cx
		mov al,4 ; inner loop counter
		rotate_collision_loop1:
			xor bh,bh
			mov bl,al
			add bx,cx
			mov bl,[si+bx]
			and bx,bx
			je rotate_collision_freecell
				pop cx ; outer loop counter
				pop dx ; y
				pop bx ; x
				push bx
				push dx
				push cx
				push ax ; ah=out, al=loop counter 
				add dx,40
				mov ax,dx
				call chkpos
				and al,al ; for the next jump
				pop ax ; ah=out, al=loop counter 
				je rotate_collision_freecell
				or ah,1b ; collision detected
			rotate_collision_freecell:
			pop cx ; outer loop counter
			pop dx ; y
			sub dx,8 ; decrease y
			push dx
			push cx
			dec al
		jg rotate_collision_loop1
		pop cx ; loop counter
		pop dx ; y
		pop bx ; x
		add dx,32
		sub bx,10
		push bx
		push dx
		
		sub cx,4
	jge rotate_collision_loop0
	pop bx ; throw y away
	pop bx ; throw x away
	
	and ah,ah
	je rotateit
	; draw tetrad back
	mov si,offset tetradinfo
	xor ah,ah
	mov al,[si] ; ah=center y, al=center x
	mov di,ax
	inc si
	mov ah,[si]
	inc si
	mov al,[si] ; color
	push ax
	xor al,al
	xchg al,ah
	mov si,ax
	pop ax
	xor ah,ah
	call drawtetrad
	; visible tetrad
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
	
	rotateit:
	mov si,offset rotatedmatrix+12
	mov di,offset tetrad+3
	mov cx,4 ; columns
	rotate_justdoit_loop0:
		push cx
		
		mov bx,3
		xor cx,cx ; ch=first row with a block, cl=number of blocks on column
		rotate_justdoit_loop1:
			mov al,[si+bx]
			and al,al
			je rotate_justdoit_freecell
				mov ch,bl
				inc ch ; if the first block on the first row, ch should be 1 and not zero
				inc cl ; one more block
			rotate_justdoit_freecell:
			dec bx ; loop
		jnl rotate_justdoit_loop1
		mov [di],ch
		mov [di+4],cl
		
		sub si,4
		dec di
		pop cx
	loop rotate_justdoit_loop0
	
	; draw rotated tetrad
	mov si,offset tetradinfo
	mov ax,[si] ; al=x ah=y
	mov bl,ah ; y
	xor bh,bh
	xor ah,ah
	mov di,ax ;x
	inc si
	inc si
	mov al,[si] ; color
	mov si,bx ;y
	call drawtetrad
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
rotate endp

; input
; dx: ticks to wait
; changes
; dx
sleep proc
	push ax
	push cx
	push si
	push di
	
	push dx
	xor ah,ah
	int 1ah ; Read System Clock Counter
	pop ax
	add dx,ax
	jnc sleep_nooverf
	inc cx
	sleep_nooverf:
	mov si,cx
	mov di,dx
	sleep_loop0:
		xor ah,ah
		int 1ah ; Read System Clock Counter
		cmp si,cx
		jl sleep_out
		jg sleep_loop0
		cmp di,dx
		jg sleep_loop0
	sleep_out:
	pop di
	pop si
	pop cx
	pop ax
	ret
sleep endp

; down arrow
fallingdown proc
	push dx
	push si
	push ax
	push di
	push bx
	fallingdown_ini:
	call chkpixel
	and dx,100b
	jne fallingdown_out
	;going down
	mov si,offset tetradinfo
	xor ax,ax
	mov al,[si]
	mov di,ax
	inc si
	mov al,[si]
	mov si,ax
	xor al,al ; black
	call drawtetrad
	mov si,offset tetradinfo 
	;xor ax,ax ; ax=0 already
	mov al,[si]
	mov di,ax ; x
	inc si
	xor bx,bx
	mov bl,[si]
	add bl,8
	mov [si],bl
	inc si
	mov al,[si]
	mov si,bx
	call drawtetrad
	jmp fallingdown_ini
	fallingdown_out:
	mov si,offset tetradinfo
	xor ax,ax
	mov al,[si]
	mov di,ax
	inc si
	mov al,[si]
	mov si,ax
	xor al,al ; black
	call drawtetrad
	mov si,offset tetradinfo 
	xor ah,ah
	mov al,[si]
	mov di,ax ; x
	inc si
	xor bx,bx
	mov bl,[si]
	sub bl,8
	mov [si],bl
	inc si
	mov al,[si]
	mov si,bx
	call drawtetrad
	pop bx
	pop di
	pop ax
	pop si
	pop dx
	ret
fallingdown endp

; get starting time
; loop until starting time - current time >= delay
;    while holds(left)
;      move_left
;    while holds(right)
;      move_right
;   if pressed(up)
;      rotate
;   if pressed(down)
;      fallingdown
playtime proc
	xor ah,ah
	int 1ah ; Read System Clock Counter
	; ticks in cx,dx
	mov bx,offset delay0
	add cx,[bx]
	inc bx
	inc bx ; bx points to delay1
	add dx,[bx]	; lembrar que pode dar OVERFLOW e entao tenho de incrementar cx!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
	jno playtime_noover
	inc cx
	playtime_noover:
	inc bx
	inc bx ; bx points to timer(high)
	mov [bx],cx ; high
	inc bx
	inc bx ; bx points to timer(low)
	mov [bx],dx ; low
	playtime_loop0:
		call getkeyh ; get keypress
		cmp al,UP
		je playtime_up
		cmp al,DOWN
		je playtime_down
		cmp al,LEFT
		je playtime_left
		cmp al,RIGHT
		je playtime_right
		
		
		playtime_nokey:
			; let´s wait a while
			push dx
			mov dx,2h
			call sleep
			pop dx
			
			; is the waiting time over?
			xor ah,ah
			int 1ah ; Read System Clock Counter
			mov bx,offset timer
			mov ax,[bx] ; high
			inc bx
			inc bx
			mov bx,[bx] ; low
			cmp ax,cx
			jg playtime_loop0
			jl playtime_out
			; high is equal
			cmp bx,dx
			jg playtime_loop0
			
		playtime_out:
		;call clbuf
		ret
		
		; keys
		playtime_up:
			call rotate
			mov dx,02h
			call sleep
			jmp playtime_nokey
		playtime_down:
			call fallingdown
			mov dx,04h
			call sleep
			ret ;jmp playtime_nokey
		playtime_left:	; easy to optimize
			call chkpixel
			and dx,010b
			jne playtime_nokey
			mov bx,offset tetradinfo
			xor ax,ax
			mov al,[bx] ; x
			mov di,ax
			inc bx
			mov al,[bx] ; y
			mov si,ax
			xor al,al ; black
			call drawtetrad
			mov bx,offset tetradinfo
			; xor ax,ax no need for this as ax=0
			mov al,[bx] ; x
			sub al,10
			mov di,ax
			mov [bx],al ; new x
			inc bx
			mov al,[bx] ; y
			mov si,ax
			inc bx
			mov al,[bx]
			call drawtetrad
			jmp playtime_nokey
		playtime_right:
			call chkpixel
			and dx,001b
			jne playtime_nokey
			mov bx,offset tetradinfo
			xor ax,ax
			mov al,[bx]
			mov di,ax
			inc bx
			mov al,[bx]
			mov si,ax
			xor al,al ; black
			call drawtetrad
			mov bx,offset tetradinfo
			; xor ax,ax no need for this as ax=0
			mov al,[bx]
			add al,10
			mov di,ax
			mov [bx],al ; new x
			inc bx
			mov al,[bx]
			mov si,ax
			inc bx
			mov al,[bx]
			call drawtetrad
			jmp playtime_nokey
playtime endp

; input
; al: color
; di: center x
; si: center y
; no change in registers
drawtetrad proc
	push ax
	push bx
	push cx
	push dx
	push si
	push di
	push es
	
	mov bx,3 ; a tetrad has (a maximum of) 4 rows; loop
	xor ah,ah
	drawtetrad_loop0:
		mov ah,offset tetrad[bx] ; blocks in that column
		and ah,ah
		je drawtetrad_nothing
			; we have something to draw
			push bx ; counter
			push si ; center y
			push di ; center x
			
			push ax ; al=color
			
			mov di,8
			xor ah,ah
			mov al,offset tetrad+4[bx] ; blocks
			mul di
			mov di,ax ; height
			
			xor ah,ah
			mov al,offset tetrad[bx]
			mov cx,8
			mul cl
			mov cx,ax
			add cx,si ; center y
			sub cx,16-10 ; y, -10 because I screwed in the rest of the code
			
			
			pop ax ; al=color
			pop si ; center x
			push si ; center x
			push ax ; al=color
			mov ax,10
			mul bl
			mov bx,si
			add bx,ax
			sub bx,10 ; x
			
			
			pop ax ; al=color
			mov si,10 ; width
			
			call drawrect
			pop di
			pop si
			pop bx
		drawtetrad_nothing:
		dec bx
	jnl drawtetrad_loop0
	
	pop es
	pop di
	pop si
	pop dx
	pop cx
	pop bx
	pop ax
	ret
drawtetrad endp

; magic formula: ((r=9 +9*r)%251+250)%n
;                           ((r=9*(r+1))%251+250)%n
; r = seed, n=max number + 1
; output
; dx: pseudo-random number [0..TETRADS-1]
; doesn't affects any register
rand proc
	push ax
	push bx
	push cx
	mov bx,offset rseed
	mov ax,[bx] ; ax=r
	inc ax ; r=r+1
	mov cx,9
	mul cl ; r=9*(r+1)
	mov [bx],ax ; store new seed
	mov cx,251
	xor dx,dx
	div cx ; first mod
	dec cx ; cx=250
	add dx,cx ; remainder+250
	mov ax,dx
	mov bx,TETRADSTOTAL ; bx=mod
	xor dx,dx
	div bx ; last mod
	pop cx
	pop bx
	pop ax
	ret
rand endp

; draws a rectangle
; stolen from from http://www.lanka.info/dulith/projects/prog6.c (fastpixel),
; (this one draws a bunch of pixels instead of a single one, though)
; 0a000h:320*y+x
; input
; al: color
; bx: x
; cx: y
; si: width
; di: height
; changes
; bx,cx,es,di
drawrect proc
    xchg ch, cl
    add bx, cx
    shr cx, 2
    add bx, cx
    mov cx, 0a000h
    mov es, cx
	drawrect_loop0:
		mov cx,si
		push bx
		drawrect_loop1:
			mov es:[bx],al
			inc bx
		loop drawrect_loop1
		mov cx,di
		dec di
		pop bx
		add bx,VIDEOX
	loop drawrect_loop0
	ret
drawrect endp
end