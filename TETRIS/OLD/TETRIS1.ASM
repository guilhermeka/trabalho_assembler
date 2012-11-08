PILHA SEGMENT STACK				
	DW 512 DUP(0)					
PILHA ENDS						
							
DADOS SEGMENT						
							
X	DB 40			;coluna		
Y	DB 2			;linha			
SPACE	DB 32 			;80 DUP(32)
SPACE2  DB 80 DUP(32)

MAP DB 200 DUP(32) 

tabobj0	db 0,0

tabobj1 db 0,0
	db 1,0
	db 0,-1
	db 0,-2

tabobj2 db 0,0
	db 2,0
	db 0,-1
	db 1,-1
	db 2,-1
	db 0,-2
	db 2,-2
		 

quad	dw 1
	dw tabobj0

ele     dw 4
	dw tabobj1

aga	dw 7
	dw tabobj2

DADOS ENDS

			

PROGRAM SEGMENT
	ASSUME CS:PROGRAM, DS:DADOS, ES:DADOS, SS:PILHA
INIT:	; lembrar de inicializar os segmentos
	MOV AX,DADOS
	MOV DS,AX
	MOV ES,AX
	MOV AX,PILHA
	MOV SS,AX
	MOV SP,1024


;CORRETO ABAIXO

	CALL APAGA
	;set keyboard to not repeat keys pressed
	mov ah,3
	mov al,5
	mov bh,3
	mov bl,1fh
	int 16h




DENOVO10:
	MOV BL,48
	LEA BP,aga     ;???? digitação tava errada (call,bp,objectus)
	CALL DESENHA
	CALL ESPERA
	MOV BL,0
	LEA BP,aga
	CALL DESENHA
	INC Y

NEXTKEY:
	MOV AH,1
	INT 16H
	JZ ACTUALLYNOKEY
	MOV AH,0
	INT 16H

	CMP AL,'a'
	JNE TSTBE
	DEC X
	JMP NOKEY

TSTBE:
	CMP AL,'s'
	JNE TSTSPACE
	INC X
	JMP NOKEY
TSTSPACE:
	CMP AL,' '
	JNE NOKEY
	CALL FALL
	MOV BL,48
	LEA BP,aga
	CALL DESENHA
	jmp fim

NOKEY:	
	JMP NEXTKEY

ACTUALLYNOKEY:
	CMP Y,24
	JNE DENOVO10

fim:	call espera2

	MOV AH,4CH
	INT 21H

	
;;PROGRAMA TERMINA AQUI




desenha proc
	mov di,DS:[bp]
	mov bp,DS:[bp+2]
	;pusha
	;set cursor position
onechar:
	dec di
	push bp
	push di
	add di,di
	mov bh,0
	mov dh,y
	add dh,DS:[bp+di+1]
	mov dl,x
	add dl,DS:[bp+di]
	mov ah,2h
	int 10h
	;put a colored char
	mov bh,0
	;mov bl,48 ;cor do quadrado verde
	mov al,' '
	mov cx,1
	mov ah,9h
	int 10h
	pop di
	pop bp
	cmp di,0
	jnz onechar
	ret


DESENHA ENDP

FALL PROC
	MOV CX,24   ;;CX REPRESENTA THE HEIGHT IN WICH THE THING IS
	SUB CL,Y
	LEA DI,MAP                 ;;MAP +20 * X+Y
	MOV AL,24
	IMUL X
	MOV BL,Y
	MOV BH,0
	ADD AX,BX
	ADD DI,AX
		
	CLD
	MOV AL,'X'
	REPNE
	SCASB	
	MOV Y,24
	SUB Y,CL

	RET
FALL ENDP




;;APAGA TODA TELA

APAGA	PROC
	MOV CX,25	;25 LINHAS EU QUERO APAGAR
DENOVO2:
	LEA BP,SPACE2
	MOV BH,0
	MOV BL,0FH	
	PUSH CX
	MOV DL,X	;COLUMN NUMBER
	MOV DH,CL	;ROW NUMBER
	DEC DH
	MOV CX,80	; COMPRIMENTO DA LINHA
	MOV AH,13H	
	MOV AL,1	;MODO DE IMPRIMIR CARACTERES E NAO ATRIBUTOS
	INT 10H
	POP CX
	LOOP DENOVO2
	RET

APAGA ENDP



ESPERA PROC

	MOV DX,2000
AGAIN0:	mov cx,65535
again:	inc BX
	loop again
	dec dx
	jnz again0
	ret

ESPERA ENDP


ESPERA2 PROC

	MOV DX,9999
AGAIN01:
	mov cx,65535
again1:	inc BX
	loop again1
	dec dx
	jnz again01
	ret

ESPERA2 ENDP


PROGRAM ENDS

END