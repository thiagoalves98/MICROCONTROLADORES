;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERS�O: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRI��O DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI�VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DOS NOMES E ENDERE�OS DE TODAS AS VARI�VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE�O INICIAL DA MEM�RIA DE
					;USU�RIO
		W_TEMP		;REGISTRADORES TEMPOR�RIOS PARA USO
		STATUS_TEMP	;JUNTO �S INTERRUP��ES
		
		;NOVAS VARI�VEIS
		TIME_ATUAL	;DEFINE UMA VARI�VEL AUXILIAR
		
	ENDC			;FIM DO BLOCO DE MEM�RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA�DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO SA�DA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE�O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN�CIO DA INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE�O DE DESVIO DAS INTERRUP��ES. A PRIMEIRA TAREFA � SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA��O FUTURA

	ORG	0x04		;ENDERE�O INICIAL DA INTERRUP��O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER� ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES
TESTE
	BTFSS	GPIO, GP0		;CASO GP0 ESTEJA EM 0, A SAIDA GP4 N�O DEVE SER INVERTIDA
	GOTO	SAI_INT			;VAI DIRETO PARA A SA�DA DA INTERRUP��O
	GOTO	ALTO
	
ALTO 
	
	 BTFSC   GPIO, GP4		;PULA SE GP4 = 0
	 GOTO    BAIXO			;CASO GP4 ESTEJA "SETADO" O FLUXO SEGUE PARA O "DESATIVA"
	 BSF	 GPIO, GP4		;GP4 = 1
	 BCF	 INTCON,T0IF		;T0IF = 0
	 MOVFW   TIME_ATUAL		;MOVE O VALOR ATUAL ARMAZENADO PARA O WORK
	 MOVWF   TMR0			;INSERE O VALOR NO TMR0
	 GOTO    SAI_INT		;SAI P/ A ROTINA DE SA�DA DA INTERRUP��O
    
BAIXO
	 
	 BCF     GPIO, GP4		;GP4 = 0
	 BCF	 INTCON,T0IF		;T0IF = 0
	 MOVFW   TIME_ATUAL		;MOVE O VALOR ATUAL ARMAZENADO PARA O WORK
	 MOVWF   TMR0			;INSERE O VALOR NO TMR0
	 GOTO    SAI_INT		;SAI P/ A ROTINA DE SA�DA DA INTERRUP��O
	 
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA�DA DA INTERRUP��O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP��O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI��O DE FUNCIONAMENTO
; E UM NOME COERENTE �S SUAS FUN��ES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'00000111'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS). CONFIGURA GP0, GP1 E GP2 COM ENTRADAS E GP4 COMO SA�DA
	MOVWF	TRISIO		;COMO SA�DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO DIGITAL I/O
	MOVLW	B'00000100'	;DEFINE O PRESCALER RATE DE 1:32
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'10100000'	;HABILITA GIE(INTERRUP��O GLOBAL) E T0IE(INTERRRUP��O DO TMR0)
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	CALL	0X03FF		;CALIBRA O CLOCK INTERNO DO PIC
	MOVWF	OSCCAL
	BANK0			;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*		      VERIFICA��O DAS ENTRADAS			   *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

TESTE_GP0		    	;VERIFICA O GP0 E SEGUE SEGUNDO O FLUXOGRAMA
	
	BTFSC   GPIO, GP0
        GOTO    TESTE_GP1	
	GOTO	DEF_OUTLOW
	
    
TESTE_GP1			;VERIFICA O GP1 E SEGUE SEGUNDO O FLUXOGRAMA
	
	BTFSC   GPIO, GP1
	GOTO    TESTE2_GP2
	GOTO    TESTE1_GP2
    
TESTE1_GP2			;VERIFICA O GP2 E DEFINE O TIME_ATUAL SEGUNDO O FLUXOGRAMA
    
	BTFSC   GPIO, GP2
	GOTO    DEF_TIMER349
	GOTO    DEF_TIMER262
     
TESTE2_GP2			;VERIFICA O GP2 E DEFINE O TIMER_ATUAL SEGUNDO O FLUXOGRAMA
    
	BTFSC   GPIO, GP2
	GOTO    DEF_TIMER523
	GOTO    DEF_TIMER440
	
DEF_OUTLOW			;DEFINE A SAIDA GP4 COMO 0 E VOLTA PARA O INICIO DA VERIFICA��O DAS ENTRADAS
	
	;
	BCF	GPIO, GP4
        GOTO    TESTE_GP0
    
DEF_TIMER262			;DEFINE O TIME_ATUAL COMO 197 E VOLTA PARA O INICIO DA VERIFICA��O DAS ENTRADAS
				;((32*256)-((1/262)/2)) / 32 = 197
	MOVLW   .197
	MOVWF   TIME_ATUAL
	GOTO    TESTE_GP0

DEF_TIMER349			;DEFINE O TIME_ATUAL COMO 212 E VOLTA PARA O INICIO DA VERIFICA��O DAS ENTRADAS
				;((32*256)-((1/349)/2)) / 32 = 212
	MOVLW   .212
	MOVWF   TIME_ATUAL
	GOTO    TESTE_GP0
    
DEF_TIMER440			;DEFINE O TIME_ATUAL COMO 221 E VOLTA PARA O INICIO DA VERIFICA��O DAS ENTRADAS
				;((32*256)-((1/440)/2)) / 32 = 221
	MOVLW   .221
	MOVWF   TIME_ATUAL
	GOTO    TESTE_GP0
    
DEF_TIMER523			;DEFINE O TIME_ATUAL COMO 227 E VOLTA PARA O INICIO DA VERIFICA��O DAS ENTRADAS
				;((32*256)-((1/523)/2)) / 32 = 227
	MOVLW   .227
	MOVWF   TIME_ATUAL	
	GOTO    TESTE_GP0
  
FIM
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END