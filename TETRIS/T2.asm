.286

;Nome: Guilherme Krüger Araujo
;Matricula: 150821

;ANOTAÇÕES
	;CORES COM 0 NO PRIMEIRO NUMERO E F NO ULTIMO
	;1:AZUL ESCURO 2:VERDE ESCURO 3: AZUL/VERDE 4:MARROM 5: ROXO 6: COCO 7:CINZA CLARO 8: CINZA 9: AZUL
	;A:VERDE B:CIANO C:VERMELHO D:ROSA E:AMARELO F:BRANCO 


PILHA SEGMENT STACK				
	DW 512 DUP(0)					
PILHA ENDS

DADOS SEGMENT

A	DB 0		;AUXILIAR ROTAÇÃO
X	DB 19		;COLUNA
Y	DB 4		;LINHA
W	DB ?		;AUX
Z	DB ?		;AUX
NP	DB 7		;NUMERO DA PEÇA
P	DB 7		;NUMERO DA NOVA PEÇA
P1	DB ?		;AUX
N	DB 0
PTOS	DB 0
COLI	DB 0		;CONTROLE DE COLISAO
TAM	DB 17		
UM	DB 1

ESPACO	DB 80 DUP(32)
QUAD	DB ' '
EPTO	DB 'COLISAO'
EPECA	DB 'PROXIMO'
VEL	DB 18
TVEL	DB ?														             ;				
																  				
RANDOM DB 7,1,5,2,1,3,4,6,3,4,5,7,1,5,2,1,3,4,6,3,4,5,7,1,5,2,1,3,4,6,3,4,5,7,1,5,2,1,3,4,6,3,4,5,7,1,5,2,1,3,4,6,3,4,5,7,1,5,2,1,3,4,6,3,4,5,7,1,5,2,1,3,4,6,3,4,7,1,5,2,1,3,4,6,3,4,7,1,5,2,1,3,4,6,3,4

;===============================
;====> TABELAS DOS OBJETOS <====
;===============================

TABJ 	DB 0,0,-1,0,0,-1,0,-2

TABL 	DB 0,0,1,0,0,-1,0,-2

TABO 	DB 0,0,1,0,0,-1,1,-1

TABI 	DB 0,0,0,-1,0,-2,0,-3

TABS 	DB -1,0,0,0,0,-1,1,-1

TABZ 	DB 2,0,1,0,0,-1,1,-1

TABT 	DB 0,0,1,0,2,0,1,-1



;MATRIZ DE COLISÃO
linha1    DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
linha2    DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
linha3    DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
linha4    DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
linha5    DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
linha6    DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
linha7    DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
linha8    DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
linha9    DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
linha10   DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
linha11   DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
linha12   DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
linha13   DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
linha14   DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
linha15   DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
linha16   DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1 
linha17   DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
linha18   DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1   
linha19   DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1
linha20   DB 1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1

;linha1   DB 1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1 

DADOS ENDS

CODE 	SEGMENT
	ASSUME CS:CODE, DS:DADOS, ES:DADOS, SS:PILHA



START:	MOV AX,DADOS
	MOV DS,AX
	MOV ES,AX
	MOV AX,PILHA
	MOV SS,AX
	MOV SP,1024

	;ESCONDE O CURSOR
      	MOV AH, 01H
	MOV CH, 100000b	
  	INT 10h
      	
	CALL CLS

	CALL DCAMPO
	
	CALL PECA



NOVP:	MOV Y,9		;ARRUMA COORDENADAS
	MOV X,42
	MOV AL,P	;COLOCA O PROXIMA PEÇA EM NP
	MOV NP,AL
	CALL CORES
	MOV BL,0FFH
	CALL DES	;APAGA A PROXIMA PEÇA NO CANTO DA DESCRIÇAO POIS AGORA ELA É A PEÇA ATUAL
	MOV AL,NP	;COLOCA A PEÇA ATUAL NO P1 AUX
	MOV P1,AL	
	
	CALL PECA	;CALCULA A NOVA PROXIMA PEÇA PEÇA
	MOV AL,NP
	MOV P,AL
	CALL PECA
	CALL CORES
	CALL DES	;DESENHA A PROXIMA PECA NO LUGAR DA DESCR

	MOV AL,P1	;COLOCA A PEÇA ATUAL EM NP
	MOV NP,AL

	MOV Y,4		;ARRUMA AS COORDENADAS
	MOV X,17

CAI:    MOV COLI,0
	INC Y
	CALL CORES
	CALL COLISAO
	DEC Y
	CMP COLI,0
	JE CONT
	CALL CORES
	CALL GRAVM
	JMP PROX
CONT:	CALL CORES
	CALL DES
	CALL TEMPO

	CALL CORES
	MOV BL,0FFH
	CALL DES
	INC Y
	
NEXTKEY:
	MOV COLI,0
	MOV AH,1
	INT 16H
	JZ CAI
	MOV AH,0
	INT 16H
	
TSTA:	CMP AL,'a'
	JNE TSTC	
	
	DEC X
	CALL CORES
	CALL COLISAO
	INC X
	CMP COLI,0
	JNE NEXTKEY
	CALL CORES
	MOV BL,0FFH
	CALL DES
	
	DEC X
	CALL CORES
	CALL DES	

TSTC:	CMP AL,'c'
	JNE TSTS	
	
	CMP A,0
	JNE CCONT
	MOV A,1
	JMP CCONT1
CCONT:	MOV A,0
	
	
CCONT1:	
	CALL CORES
	CALL COLISAO
	CMP COLI,0
	JNE NEXTKEY
	CALL CORES
	MOV BL,0FFH
	CALL DES
	
	JMP NOKEY
	

TSTS:
	CMP AL,'s'
	JNE TSTX
	
	INC X
	CALL CORES
	CALL COLISAO
	DEC X
	CMP COLI,0
	JNE NOKEY
	CALL CORES
	MOV BL,0FFH
	CALL DES	

	INC X

	CALL CORES
	CALL DES
	
	JMP NOKEY

TSTX:	
	CMP AL,' '
	JNE NOKEY
	
	CALL FALL
	JMP PROX

NOKEY:	JMP NEXTKEY

ACTUALLYNOKEY:
	
	
	JMP CAI
		

PROX:	CALL CORES
	CALL DES
	MOV COLI,0
	ADD PTOS,10
	;CALL ESCPT
	INC N
	CMP N,20
	JE FIM
	SUB VEL,2
	CMP VEL,2
	JNE VNORM
	MOV VEL,4
VNORM:	MOV A,0
	JMP NOVP


FIM:	MOV AH,4CH	;INTERRUPÇÃO DE RETORNO AO DOS
 	INT 21H


;***** FIM DO PROGRAMA PRINCIPAL *****






;******************************************
;************* PROCEDIMENTOS **************
;******************************************

;================================
;====> GRAVA PECA NA MATRIZ <====
;================================

GRAVM PROC
	
	PUSH BX
	PUSH DX
	PUSH AX
	PUSH CX
	
	MOV CX,4
GRAV:
	MOV BH,0
	MOV DH,Y	;dh (linha) recebe y
	ADD DH,DS:[BP+1]		
	MOV DL,X	;dl (coluna) recebe x
	ADD DL,DS:[BP]
	SUB DL,11
	ADD BP,2

	;;CONTINUAR AQUI
	PUSH BP
	LEA BP,linha1
	MOV AX,0
	MOV AL,DH
	SUB AL,2	
	MUL TAM
	ADD AL,DL
	ADD BP,AX
	PUSH CX
	MOV CL,1
	MOV DS:[BP],CL

	POP CX
	POP BP
	LOOP GRAV

	POP CX
	POP AX
	POP DX
	POP BX
	RET	

GRAVM ENDP



;=====================================================================
;====> ESCREVE A PONTUAÇÃO (CONVERTE VALOR NUMERICO PARA STRING) <====
;=====================================================================
ESCPT PROC

	LEA BP,PTOS		;mensagem de pontuação		
	MOV BH,0
	MOV BL,0F4H
	MOV DL,49
	MOV DH,12
	MOV CX,10
	MOV AH,13H
	MOV AL,1
	INT 10H
	
ESCPT ENDP

;=========================
;====> FAZ PEÇA CAIR <====
;=========================
;*** fazer direito ***

FALL PROC
	CALL CORES
	MOV BL,0FFH
	CALL DES

	MOV Y,20
	
	CALL CORES
	CALL DES
	
	RET
FALL ENDP

;===============================================================
;====> DECIDE QUAL MANEIRA DE DESENHAR (TRANSPOSTA OU NÃO) <====
;===============================================================
;arrumar transposta para maneira correta
DES PROC

	CMP A,0
	JNE DET
	CALL DESENHA
	JMP DEF
DET:	CALL DESENHAT
DEF:	RET

DES ENDP

;======================
;====> LIMPA TELA <====
;======================
CLS 	PROC

	MOV CX,25	;25 LINHAS EU QUERO APAGAR
CLS1:
	LEA BP,ESPACO
	MOV BH,0	
	MOV BL,0f0H	;ATRIBUTO DE CORES
	PUSH CX
	MOV DL,0	;COLUMN NUMBER
	MOV DH,CL	;ROW NUMBER
	DEC DH
	MOV CX,80	; COMPRIMENTO DA LINHA
	MOV AH,13H	
	MOV AL,1	;MODO DE IMPRIMIR CARACTERES E NAO ATRIBUTOS
	INT 10H
	POP CX
	LOOP CLS1
	RET

CLS 	ENDP 

;===========================================
;====> DESENHA O CAMPO (CAIXA) DO JOGO <====
;===========================================
DCAMPO	PROC
	MOV CX,21	;21 LINHAS
DCAMPO1:
	LEA BP,QUAD
	MOV BH,0
	MOV BL,0
	PUSH CX
	MOV DL,11	;COLUNA
	ADD CL,1
	MOV DH,CL	;LINHA
	DEC DH
	MOV CX,1	;COMPRIMENTO DA LINHA
	MOV AH,13H
	MOV AL,1
	INT 10H
	POP CX
	LOOP DCAMPO1

	MOV CX,21
DCAMPO2:
	LEA BP,QUAD
	MOV BH,0
	MOV BL,0
	PUSH CX
	MOV DL,27	;COLUNA
	ADD CL,1
	MOV DH,CL	;LINHA
	DEC DH
	MOV CX,1	;COMPRIMENTO DA LINHA
	MOV AH,13H
	MOV AL,1
	INT 10H
	POP CX
	LOOP DCAMPO2

	LEA BP,ESPACO
	MOV BH,0
	MOV BL,0
	MOV DL,12
	MOV DH,21
	MOV CX,15
	MOV AH,13H
	MOV AL,1
	INT 10H

	LEA BP,EPECA		;mensagem da proxima peça
	MOV BH,0
	MOV BL,0F3H
	MOV DL,40
	MOV DH,4
	MOV CX,7
	MOV AH,13H
	MOV AL,1
	INT 10H


	RET		

DCAMPO	ENDP	

;======================================================================================================
;====> PROCEDIMENTO QUE FAZ O TESTE DE COLISAO (VARIAVEL COLI IDENTIFICA SE HOUVE OU NÃO COLISÃO) <====
;======================================================================================================
COLISAO PROC
	PUSH BX
	PUSH DX
	PUSH AX
	PUSH CX
	
	MOV CX,4
UMQUADD:
	MOV DX,0
	MOV BX,0
	MOV DH,Y	;dh (linha) recebe y
	ADD DH,DS:[BP+1]		
	MOV BL,X	;dl (coluna) recebe x
	ADD BL,DS:[BP]
	SUB BL,11	
	ADD BP,2


	;;CONTINUAR AQUI
	PUSH BP
	LEA BP,linha1
	MOV AX,0
	MOV AL,DH
	SUB AL,2	
	MUL TAM
	ADD AX,BX
	ADD BP,AX
	PUSH CX
	MOV CL,1
	CMP CL,DS:[BP]
	JNE DES1D
	MOV COLI,1
	CALL CORES
	LEA BP,EPTO		;mensagem de COLISAO		
	MOV BH,0
	;MOV BL,0F4H
	MOV DL,40
	MOV DH,12
	MOV CX,7
	MOV AH,13H
	MOV AL,1
	INT 10H	
		
DES1D:	POP CX
	POP BP
	LOOP UMQUADD

	
	
	POP CX
	POP AX
	POP DX
	POP BX
	RET


COLISAO ENDP

;=====================================
;====> FUNÇÃO QUE DESENHA A PEÇA <====
;=====================================
DESENHA PROC
	PUSH BX
	PUSH DX
	PUSH AX
	PUSH CX
	
	MOV CX,4
UMQUAD:
	;SET CURSOR POSITION
	MOV BH,0
	MOV DH,Y	;dh (linha) recebe y
	ADD DH,DS:[BP+1]		
	MOV DL,X	;dl (coluna) recebe x
	ADD DL,DS:[BP]
	ADD BP,2
	
	MOV AH,2h	
	INT 10H
	
	;DESENHA
	MOV BH,0
	MOV AL,' '
	PUSH CX
	MOV CX,1	;TAMANHO DA STRING
	PUSH AX
	MOV AH,9h	
	INT 10H
	POP AX
	POP CX
	
DES1:	LOOP UMQUAD

	POP CX
	POP AX
	POP DX
	POP BX
	RET


DESENHA ENDP

;===========================
;====> DESENHA INVERSO <====
;===========================
DESENHAT PROC
	PUSH BX
	PUSH DX
	PUSH AX
	PUSH CX
	
	MOV CX,4
UMQUAD2:
	;SET CURSOR POSITION
	MOV BH,0
	MOV DH,Y	;dh (linha) recebe y
	ADD DH,DS:[BP]		
	MOV DL,X	;dl (coluna) recebe x
	ADD DL,DS:[BP+1]
	ADD BP,2
	
	MOV AH,2h	
	INT 10H
	
	;DESENHA
	MOV BH,0
	MOV AL,' '
	PUSH CX
	MOV CX,1	;TAMANHO DA STRING
	PUSH AX
	MOV AH,9h	
	INT 10H
	POP AX
	POP CX
	
DES2:	DEC CX
	CMP CX,0
	JNE UMQUAD2

	POP CX
	POP AX
	POP DX
	POP BX
	RET


DESENHAT ENDP

;=============================================
;=====> TEMPO (DELAY medido em hundrets) <====
;=============================================
TEMPO 	PROC
	
	PUSHA
	MOV AH,VEL
	MOV TVEL,AH
TEMP0:	MOV AH,2CH
    	INT 21H
	MOV BH,DL
TEMP1:	MOV AH,2CH
    	INT 21H
	CMP DL,BH
	JE TEMP1
	DEC TVEL
	LOOPNZ TEMP0
	POPA
	
	RET	

TEMPO ENDP

;===============================================================================================
;====> FUNCAO Q RETORNA UM NUMERO DE 1 A 7 EM CL, USANDO UMA MATRIZ DE NUMEROS E O RELOGIO <====
;===============================================================================================
RANDOMI PROC

      	PUSH DX
      	PUSH CX
    
    	MOV AH,02H            
    	INT 1AH           

    	POP CX
     
      	MOV DL,DH
      	MOV DH,0           	;ZERA DH, E DL VAI CONTER OS SEGUNDOS OBTIDOS PELA INTERRUPÇÃO 21H
            
      	LEA BP,random
      	ADD BP,DX
   
      	MOV CL,DS:[BP]
	POP DX

	RET

RANDOMI ENDP

;======================================================================
;====>GERA UM NUMERO RANDOMICO DE 1 A 7 E ARMAZENA NA VARIAVEL NP <====
;======================================================================
PECA PROC
	
	CALL RANDOMI
	MOV NP,CL
	RET

PECA ENDP


;=====================================================================
;====> CARREGA A DESCRIÇÃO DA PEÇA NOS REGISTRADORES NECESSARIOS <====
;=====================================================================
CORES PROC

	CMP NP,1
	JNE TN2
	MOV BL,0BFH	
	LEA BP,TABI
	JMP RETO

TN2:	CMP NP,2
	JNE TN3
	MOV BL,04FH
	LEA BP,TABJ
	JMP RETO

TN3:	CMP NP,3
	JNE TN4
	MOV BL,09FH
	LEA BP,TABL
	JMP RETO

TN4:	CMP NP,4
	JNE TN5
	MOV BL,0EFH
	LEA BP,TABO
	JMP RETO

TN5:	CMP NP,5
	JNE TN6
	MOV BL,0AFH
	LEA BP,TABS
	JMP RETO

TN6:	CMP NP,6
	JNE TN7
	MOV BL,05FH	
	LEA BP,TABT
	JMP RETO

TN7:	CMP NP,7
	MOV BL,0CFH
	LEA BP,TABZ	

RETO: 	RET

CORES 	ENDP






CODE 	ENDS

END START







