PILHA SEGMENT STACK				
	DW 512 DUP (0)					
PILHA ENDS						
							
DADOS SEGMENT						
							
X	DB 40			;coluna		
Y	DB 0			;linha			
SPACE	DB 32 			;80 DUP(32)
SPACE2  DB 80 DUP(32)

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

	MOV CL,0
	CALL CLS
	;set keyboard to not repeat keys pressed
	mov ah,3
	mov al,5
	mov bh,3
	mov bl,1fh
	int 16h
			


denovo10:
	mov bl,48
	call desenha
	inc y
	call desenha
	inc x
	call desenha
	inc x
	call desenha
	dec x
	dec x
	
	
	call espera
	mov bl,0

	mov ah,1
	int 16h
	jz nokey
	mov ah,0
	int 16h
	cmp al,'a'
	jne tstbe
	dec x
	jmp nokey

tstbe: 	cmp al,'s'
	jne nokey
	inc x
nokey:	cmp y,20

	cmp y,24    
	jz acaba
	
	;dec y
	;call apaga
	;inc y
	;call apaga
	;inc x
	;call apaga
	;inc x
	;call apaga
	;dec x
	;dec x

	call cls
	

	jmp denovo10

	
acaba:	MOV AH,4CH
	INT 21H	


DESENHA PROC

	MOV BH,0
	MOV DH,Y
	MOV DL,X
	MOV AH,2H
	INT 10H
	
	MOV BH,0
	MOV BL,50	;COR DO QUADRADO VERDE
	MOV AL,' '
	MOV CX,1

	MOV AH,9H
	INT 10H

	RET	
;60
DESENHA ENDP				

APAGA	PROC
	MOV CX,24	;24 LINHAS EU QUERO APAGAR

;DENOVO2:
	LEA BP,SPACE
	MOV BH,0
	MOV BL,0FH
	PUSH CX
	MOV DL,x	;COLUMN NUMBER
	MOV DH,Y	;ROW NUMBER
	;DEC DH
	MOV CX,1	; COMPRIMENTO DA LINHA
	MOV AH,13H	
	MOV AL,1	;MODO DE IMPRIMIR CARACTERES E NAO ATRIBUTOS
	INT 10H
	POP CX
	;LOOP DENOVO2
	RET
            ;80

APAGA ENDP


CLS	PROC
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

CLS ENDP






ESPERA PROC

	MOV DX,2000
AGAIN0:	mov cx,65535
again:	inc BX
	loop again
	dec dx
	jnz again0
	ret

ESPERA ENDP


PROGRAM ENDS

END