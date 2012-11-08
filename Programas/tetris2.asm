PILHA SEGMENT STACK				
	DW 512 DUP (0)					
PILHA ENDS						
							
DADOS SEGMENT						
							
X	DB 40			;coluna		
Y	DB 0			;linha			
SPACE	DB 80 DUP(32)

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


	CALL APAGA


denovo10:
	mov bl,48
	call desenha
	call espera
	mov bl,0
	cmp y,24
	jz acaba
	call apaga
	inc y
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
	MOV BL,35	;COR DO QUADRADO VERDE
	MOV AL,' '
	MOV CX,1

	MOV AH,9H
	INT 10H

	RET	

DESENHA ENDP				

APAGA	PROC
	MOV CX,25	;25 LINHAS EU QUERO APAGAR
DENOVO2:
	LEA BP,SPACE
	MOV BH,0
	MOV BL,0FH
	PUSH CX
	MOV DL,x	;COLUMN NUMBER
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

	MOV DX,1000
AGAIN0:	mov cx,65535
again:	inc BX
	loop again
	dec dx
	jnz again0
	ret

ESPERA ENDP


PROGRAM ENDS					

END INIT