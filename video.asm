         assume cs:codigo,ds:dados,es:dados,ss:pilha

CR       EQU    0DH ; constante - codigo ASCII do caractere "carriage return"
LF       EQU    0AH ; constante - codigo ASCII do caractere "line feed"

; definicao do segmento de dados do programa
dados    segment
msg1	 db     'Voce ira'' ver varias mensagens.',CR,LF
         db     'Depois de cada uma, pressione qualquer tecla',CR,LF
         db     'para prosseguir.',CR,LF,CR,LF
         db     'Em primeiro lugar, a tela sera'' limpa,',CR,LF
         db     'mas observe o que ocorre com o cursor...','$'
msg2     db     'Agora o cursor vai para o canto superior esquerdo','$'
msg3     db     'A seguir, alguns testes..... (depois de limpar a tela)','$'
msg4     db     'A seguir, 16 testes de cores..... ','$' 
cor1     db     'Preto','$'		; preto = 0
cor2     db     'Azul','$'		; azul = 2
cor3     db     'Verde','$'		; verde = 3
cor4     db     'Ciano','$'
cor5     db     'Vermelho','$'
cor6     db     'Magenta','$'
cor7     db     'Marrom','$'
cor8     db     'Cinza claro','$'
cor9     db     'Cinza escuro','$'
cor10    db     'Azul claro','$'
cor11    db     'Verde claro','$'
cor12    db     'Ciano claro','$'
cor13    db     'Vermelho claro','$'
cor14    db     'Magenta claro','$'
cor15    db     'Amarelo','$'		; amarelo = 14
cor16    db     'Branco','$'		; branco = 15
ecor     dw     cor1
         dw     cor2
         dw     cor3
         dw     cor4
         dw     cor5
	 dw     cor6
         dw     cor7
         dw     cor8
         dw     cor9
         dw     cor10
         dw     cor11
         dw     cor12
         dw     cor13
         dw     cor14
         dw     cor15
         dw     cor16
mfundo   db     'Cor do fundo: ','$'
mletra   db     ', cor das letras: ','$'
letra    db     0
         db     0
fundo    db     0
         db     0
corfundo dw     0
corletra dw     0
dados    ends

; definicao do segmento de pilha do programa
pilha    segment stack ; permite inicializacao automatica de SS:SP
         dw     128 dup(?)
pilha    ends
         
; definicao do segmento de codigo do programa
codigo   segment
inicio:  ; CS e IP sao inicializados com este endereco
         mov    ax,dados ; inicializa DS
         mov    ds,ax    ; com endereco do segmento DADOS
         mov    es,ax    ; idem em ES
; fim da carga inicial dos registradores de segmento

; a partir daqui, as instrucoes especificas para cada programa
         lea     dx,msg1
         call    write
         call    espera_tecla
; limpa a tela
         mov    dh,24		; linha 24
	 mov	dl,79		; coluna 79
         mov    ch,0		; linha zero  
         mov    cl,0		; coluna zero
         mov    bh,07h          ; atributo de preenchimento (fundo preto e letras cinzas)
         mov    al,0		; numero de linhas (zero = toda a janela)
         mov    ah,6            ; scroll window up
         int    10h             ; chamada BIOS (video)
         lea    dx,msg2
         call    write
         call    espera_tecla   
; e posiciona cursor no canto superior direito
         mov    dh,0		; linha zero  
         mov    dl,0		; coluna zero
         mov    bh,0		; numero da pagina (zero = primeira)
         mov    ah,2            ; set cursor position
         int    10h             ; chamada BIOS (video)
         lea    dx,msg3
         call    write
         call    espera_tecla
; limpa a tela e vai para 0,0
         mov    dh,24		; linha 24
	 mov	dl,79		; coluna 79
         mov    ch,0		; linha zero  
         mov    cl,0		; coluna zero
         mov    bh,07h          ; atributo de preenchimento (letras cinzas)
         mov    al,0		; numero de linhas (zero = toda a janela)
         mov    ah,6            ; scroll window up
         int    10h             ; chamada BIOS (video)  
; e posiciona cursor no canto superior direito
         mov    dh,0		; linha zero  
         mov    dl,0		; coluna zero
         mov    bh,0		; numero da pagina (zero = primeira)
         mov    ah,2            ; set cursor position
         int    10h             ; chamada BIOS (video)
         call espera_tecla

; escreve caracter          
         mov    cx,4		; numero de vezes a escrever caracter  
         mov    bl,0fH		; atributo (fundo preto e caracteres brancos)
         mov    bh,0		; numero da pagina (zero = primeira)
         mov 	al, '0'
         mov    ah,9            ; set cursor position
         int    10h             ; chamada BIOS (video)
; posiciona cursor na linha 1, coluna 1
         mov    dh,1		; linha 1  
         mov    dl,1		; coluna 1
         mov    bh,0		; numero da pagina (zero = primeira)
         mov    ah,2            ; set cursor position
         int    10h             ; chamada BIOS (video)
; escreve caracter          
         mov    cx,4		; numero de vezes a escrever caracter  
         mov    bl,07H		; atributo (fundo preto e caracteres cinzas)
         mov    bh,0		; numero da pagina (zero = primeira)
         mov 	al,'1'
         mov    ah,9            ; set cursor position
         int    10h             ; chamada BIOS (video)
; posiciona cursor na linha 2, coluna 2
         mov    dh,2		; linha 2  
         mov    dl,2		; coluna 2
         mov    bh,0		; numero da pagina (zero = primeira)
         mov    ah,2            ; set cursor position
         int    10h             ; chamada BIOS (video)
; escreve caracter          
         mov    cx,4		; numero de vezes a escrever caracter  
         mov    bl,0F0H		; atributo (fundo branco e caracteres pretos)
         mov    bh,0		; numero da pagina (zero = primeira)
         mov 	al,'2'
         mov    ah,9            ; set cursor position
         int    10h             ; chamada BIOS (video)
; posiciona cursor na linha 3, coluna 10
         mov    dh,3		; linha 2  
         mov    dl,10		; coluna 2
         mov    bh,0		; numero da pagina (zero = primeira)
         mov    ah,2            ; set cursor position
         int    10h             ; chamada BIOS (video)
; escreve caracter          
         mov    cx,4		; numero de vezes a escrever caracter  
         mov    bl,19H		; atributo (fundo azul e caracteres azul claro)
         mov    bh,0		; numero da pagina (zero = primeira)
         mov 	al,'3'
         mov    ah,9            ; set cursor position
         int    10h             ; chamada BIOS (video)
; posiciona cursor na linha 4, coluna 20
         mov    dh,4		; linha 2  
         mov    dl,20		; coluna 2
         mov    bh,0		; numero da pagina (zero = primeira)
         mov    ah,2            ; set cursor position
         int    10h             ; chamada BIOS (video)
; escreve caracter          
         mov    cx,8		; numero de vezes a escrever caracter  
         mov    bl,2EH		; atributo (fundo verde e caracteres amarelo claro)
         mov    bh,0		; numero da pagina (zero = primeira)
         mov 	al,'4'
         mov    ah,9            ; set cursor position
         int    10h             ; chamada BIOS (video)
         lea    dx,msg4        ; endereco da mensagem em DX
         call   write
         call   espera_tecla

;
;  Repete 16 vezes (para cada cor de fundo)
;
	 mov    fundo,0
         mov    ax, ecor
         mov    corfundo, ax

laco_fundo:
; limpa a tela e vai para 0,0
         mov    dh,24		; linha 24
	 mov	dl,79		; coluna 79
         mov    ch,0		; linha zero  
         mov    cl,0		; coluna zero
         mov    bh,07h          ; atributo de preenchimento (letras cinzas)
         mov    al,0		; numero de linhas (zero = toda a janela)
         mov    ah,6            ; scroll window up
         int    10h             ; chamada BIOS (video)  
         mov    dh,0		; linha zero  
         mov    dl,0		; coluna zero
         mov    bh,0		; numero da pagina (zero = primeira)
         mov    ah,2            ; set cursor position
         int    10h             ; chamada BIOS (video)

         mov    letra,0
         mov    ax, ecor
         mov    corletra, ax
laco_letra:           
         mov    dh,letra	; linha definida por letra  
         mov    dl,0		; coluna 0
         mov    bh,0		; numero da pagina (zero = primeira)
         mov    ah,2            ; set cursor position
         int    10h             ; chamada BIOS (video)         
         mov    cx,80		; numero de vezes a escrever caracter
         mov    bl,fundo
         shl    bl,4
         or     bl,letra        ; bl = atributo (fundo*16 + letra)  
         mov    bh,0		; numero da pagina (zero = primeira)
         mov 	al,' '
         mov    ah,9
         int    10h            
         lea    dx, mfundo
         call   write
         mov    dx, corfundo
         call   write
         lea    dx, mletra
         call   write
         mov    dx, corletra
         call   write
 
         add    letra,1
         lea    si, ecor
         add    si, word ptr letra
         add    si, word ptr letra
         mov    ax,[si]
         mov    corletra, ax
         cmp    letra,15
         jle    laco_letra
  
         call    espera_tecla

         add    fundo,1
         lea    si, ecor
         add    si, word ptr fundo
         add    si, word ptr fundo
         mov    ax,[si]
         mov    corfundo, ax
         cmp    fundo,15
         jg     fim
         jmp    laco_fundo

fim:         
; retorno ao DOS com codigo de retorno 0 no AL (fim normal)
         mov    ax,4c00h           ; funcao retornar ao DOS no AH
         int    21h                ; chamada do DOS



write   proc
        ; assume que dx aponta para a mensagem
         mov    ah,9               ; funcao exibir mensagem no AH
         int    21h                ; chamada do DOS
         ret
write   endp

espera_tecla proc
         mov    ah,0               ; funcao esperar tecla no AH
         int    16h                ; chamada do DOS
         ret
espera_tecla endp
  



codigo   ends

; a diretiva a seguir indica o fim do codigo fonte (ultima linha do arquivo)
         end    inicio   ; para o programa iniciar em "inicio" quando for executado

