PILHA	SEGMENT
	DW 1024 dup(?)
PILHA	ENDS

DADOS	SEGMENT
MENS	DB 'Ola mundo!',0,'Esse foi meu primeiro programa em Assembler...','$'
DADOS 	ENDS

NOVO SEGMENT
	MENS2 DB 'Oi ','$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$'
NOVO ENDS


COD	SEGMENT
	ASSUME CS: COD, SS:PILHA, DS:DADOS, ES:NOVO

INI:	MOV AX,DADOS
	MOV DS,AX
	mov ax,novo
	mov es,ax
	mOV AX,PILHA
	MOV SS,AX


	LEA DI,MENS2
	LEA SI,MENS
	MOV CX,16
	REP
	CLD
	MOVSB

	
	MOV AX,ES
	MOV DS,AX
	MOV CX,5

	LEA DX,MENS2
	MOV AH,9
	INT 21H
	MOV AH,4CH	;PEDE AO DOS PARA TERMINAR
	INT 21H	

COD	ENDS

END	INI