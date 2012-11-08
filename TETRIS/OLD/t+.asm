.286

PILHA SEGMENT STACK				
	DW 512 DUP(0)					
PILHA ENDS

DADOS SEGMENT

A	DB ?		;AUXILIAR
X	DB 19		;COLUNA
Y	DB 1		;LINHA
NP	DB 7		;NUMERO DA PEÇA
CR	DB 0		;CONTROLE DE ROTAÇÃO

ESPACO	DB 80 DUP(32)
QUAD	DB ' '
EPTO	DB 'PONTOS '
EPECA	DB 'PROXIMO'
VEL	DB 10
TVEL	DB ?
BOOL	DB ?

; - = - = - TABELAS DOS OBJETOS - = - = -

TABJ 	DB 0,0,1,0,0,1,0,2  ;TROCANDO X POR Y 0,0,1,0,2,0,2,-1

TABL 	DB 0,0,0,1,0,2,1,2

TABO 	DB 0,0,1,1,0,1,1,0

TABI 	DB 1,0,1,1,1,2,1,3

TABS 	DB 1,0,2,0,1,1,0,1

TABZ 	DB 0,0,1,0,1,1,2,1

TABT 	DB 1,0,0,1,1,1,2,1

;OBJETO CORRENTE

OC1 	DB 0,0,0,0
OC2	DB 0,0,0,0
OC3	DB 0,0,0,0
OC4	DB 0,0,0,0

;PROXIMO OBJ

PO1 	DB 0,0,0,0
PO2	DB 0,0,0,0
PO3	DB 0,0,0,0
PO4	DB 0,0,0,0


;MATRIZ DE COLISÃO

linha1    DB 1,0,0,0,0,0,0,0,0,0,0,1
linha2    DB 1,0,0,0,0,0,0,0,0,0,0,1 
linha3    DB 1,0,0,0,0,0,0,0,0,0,0,1 
linha4    DB 1,0,0,0,0,0,0,0,0,0,0,1 
linha5    DB 1,0,0,0,0,0,0,0,0,0,0,1 
linha6    DB 1,0,0,0,0,0,0,0,0,0,0,1 
linha7    DB 1,0,0,0,0,0,0,0,0,0,0,1 
linha8    DB 1,0,0,0,0,0,0,0,0,0,0,1 
linha9    DB 1,0,0,0,0,0,0,0,0,0,0,1 
linha10   DB 1,0,0,0,0,0,0,0,0,0,0,1 
linha11   DB 1,0,0,0,0,0,0,0,0,0,0,1 
linha12   DB 1,0,0,0,0,0,0,0,0,0,0,1 
linha13   DB 1,0,0,0,0,0,0,0,0,0,0,1 
linha14   DB 1,0,0,0,0,0,0,0,0,0,0,1 
linha15   DB 1,0,0,0,0,0,0,0,0,0,0,1 
linha16   DB 1,0,0,0,0,0,0,0,0,0,0,1 
linha17   DB 1,0,0,0,0,0,0,0,0,0,0,1
linha18   DB 1,0,0,0,0,0,0,0,0,0,0,1 
linha19   DB 1,0,0,0,0,0,0,0,0,0,0,1 
linha20   DB 1,0,0,0,0,0,0,0,0,0,0,1  
linha21   DB 1,0,0,0,0,0,0,0,0,0,0,1 
linha22   DB 1,0,0,0,0,0,0,0,0,0,0,1 
linha23   DB 1,1,1,1,1,1,1,1,1,1,1,1


DADOS ENDS

CODE 	SEGMENT
	ASSUME CS:CODE, DS:DADOS, ES:DADOS, SS:PILHA

START:	MOV AX,DADOS
	MOV DS,AX
	MOV ES,AX
	MOV AX,PILHA
	MOV SS,AX
	MOV SP,2000

	;ESCONDE O CURSOR
;      	MOV AH, 01H
;	MOV CH, 100000b	
;  	INT 10h
      	

	CALL CLS

	CALL DCAMPO
	
;	CALL TEMPO

	;CORES COM 0 NO PRIMEIRO NUMERO E F NO ULTIMO
	;1:AZUL ESCURO 2:VERDE ESCURO 3: AZUL/VERDE 4:MARROM 5: ROXO 6: COCO 7:CINZA CLARO 8: CINZA 9: AZUL
	;A:VERDE B:CIANO C:VERMELHO D:ROSA E:AMARELO F:BRANCO 

CAI:    MOV BL,0BFH	
	LEA BP,TABJ
	CALL DESENHA
	
	CALL TEMPO

	CMP Y,18
	JE FIM

	MOV BL,0FFH
	LEA BP,TABJ
	CALL DESENHA	

	INC Y
	
NEXTKEY:
	MOV AH,1
	INT 16H
	JZ ACTUALLYNOKEY
	MOV AH,0
	INT 16H
	
TSTA:	CMP AL,'A'
	JNE TSTS
	cmp X,10
	je nokey
	
	MOV BL,0FFH
	LEA BP,TABJ
	CALL DESENHA

	DEC X

	MOV BL,0BFH	
	LEA BP,TABJ
	CALL DESENHA	

	JMP NOKEY

TSTS:
	CMP AL,'S'
	JNE NOKEY
	cmp x,29
	JE NOKEY
	
	MOV BL,0FFH
	LEA BP,TABJ
	CALL DESENHA	

	INC X

	MOV BL,0BFH	
	LEA BP,TABJ
	CALL DESENHA


NOKEY:	
	JMP NEXTKEY

ACTUALLYNOKEY:
;	CMP Y,24
;	JNE CAI

	JMP CAI
		








;	ADD X,4
;	MOV BL,04FH
;	LEA BP,TABJ
;	CALL DESENHA
	
;	SUB X,4		
;	ADD Y,5
;	MOV BL,09FH
;	LEA BP,TABL
;	CALL DESENHA

;	ADD X,4		
;	MOV BL,0EFH
;	LEA BP,TABO
;	CALL DESENHA

;	SUB X,4		
;	ADD Y,5
;	MOV BL,0AFH
;	LEA BP,TABS
;	CALL DESENHA

;	ADD X,4
;	MOV BL,05FH	
;	LEA BP,TABT
;	CALL DESENHA

;	SUB X,4		
;	ADD Y,5
;	MOV BL,0CFH
;	LEA BP,TABZ
;	CALL DESENHA

FIM:	MOV AH,4CH	;INTERRUPÇÃO DE RETORNO AO DOS
 	INT 21H


; - = - = - = - PROCEDIMENTOS - = - = - = -

;|=| LIMPA TELA |=|

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


;-----DESENHA O CAMPO (CAIXA) DO JOGO-----

DCAMPO	PROC
	MOV CX,21	;21 LINHAS
DCAMPO1:
	LEA BP,QUAD
	MOV BH,0
	MOV BL,0
	PUSH CX
	MOV DL,9	;COLUNA
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
	MOV DL,30	;COLUNA
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
	MOV DL,9
	MOV DH,21
	MOV CX,22
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

	LEA BP,EPTO		;mensagem de pontuação		
	MOV BH,0
	MOV BL,0F4H
	MOV DL,40
	MOV DH,12
	MOV CX,7
	MOV AH,13H
	MOV AL,1
	INT 10H


	RET		

DCAMPO	ENDP	





;------------------------------------COLISAO------------------------------
;testa se houve colisão , dado o endereço da peça que se deseja examinar, mais a posição x, y, e devolve 0 ou 1 em AX, caso houver colisao...
;(espera - CX(endereço da peca) e pos x, y (que já existem disponíveis em memória...))
COLISAO PROC NEAR
      PUSH BX
      PUSH DX
      
      MOV BP,CX
      
      
      
               
      
      
;      CMP rotac,0
;      JE  TESTAC
;      CMP rotac,1
;      JE  AD10
;      CMP rotac,2
;      JE  AD20
            
           
                      ;empilhando o endereço da peça
              
;AD30: ADD BP,tamanho      
;AD20: ADD BP,tamanho
;AD10: ADD BP,tamanho      
      



   
TESTAC:   PUSH CX             ;empilhando endereço da peça
          MOV CX,4

TESTACL:           
          MOV DL,x
          ADD DL,DS:[BP]
          MOV DH,y
          ADD DH,DS:[BP+1]
        
          PUSH BP
          LEA BP,linha1
          
          MOV AH,0
          MOV AL,12		;MULTIPLICA Y POR 18 PARA ACHAR A LINHA Q DEVEMOS TESTAR
          MUL DH
                   
          ADD BP,AX		;ADICIONA AO BP O RESULTADO DA MULTIPLICAÇÃO, PARA LOCALIZAR A LINHA A SER TESTADA
          
          SUB DL,8		
          MOV DH,0
          
          ADD BP,DX
          PUSH CX
          MOV CL,1
          CMP CL,DS:[BP]
          POP CX
          JE  COLIL          
         
          POP BP

          ADD BP,2
          LOOP TESTACL

 
NCOLI:MOV AL,0      ;AL = 0 representa nenhuma colisao
      JMP FIMC 
COLIL:POP BP
      MOV AL,1      ;AL = 1 representa colisao
      
FIMC: POP CX
      POP DX
      POP BX
      RET


COLISAO ENDP









DESENHA PROC
	MOV 	DI,4
	
	PUSHA
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
	
	;DESENHA O QUAD
	MOV BH,0
	MOV AL,' '
	MOV CX,1	;TAMANHO DA STRING
	PUSH AX
	MOV AH,9h	
	INT 10H
	POP AX
	
DES1:	DEC DI
	JNE UMQUAD

	POPA
	RET


DESENHA ENDP



;	LEA BP,SPACE2
;	MOV BH,0
;	MOV BL,0fh       ;0FH	
;	PUSH CX
;	MOV DL,30	;COLUMN NUMBER
;	MOV DH,CL	;ROW NUMBER
;	DEC DH
;	MOV CX,21	;COMPRIMENTO DA LINHA
;	MOV AH,13H	
;	MOV AL,1	;MODO DE IMPRIMIR CARACTERES E NAO ATRIBUTOS
;	INT 10H
;	POP CX
;	LOOP DENOVO3










;===== TEMPO ====
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

CODE 	ENDS

END START







