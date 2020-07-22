;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERSÃO: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRIÇÃO DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINIÇÕES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINAÇÃO DE MEMÓRIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINIÇÃO DE COMANDOS DE USUÁRIO PARA ALTERAÇÃO DA PÁGINA DE MEMÓRIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEMÓRIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAMÓRIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARIÁVEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DOS NOMES E ENDEREÇOS DE TODAS AS VARIÁVEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE
					;USUÁRIO
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES
		
		;NOVAS VARIÁVEIS
		TIME_ATUAL	;DEFINE UMA VARIÁVEL AUXILIAR
		
	ENDC			;FIM DO BLOCO DE MEMÓRIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SAÍDAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS PINOS QUE SERÃO UTILIZADOS COMO SAÍDA
; RECOMENDAMOS TAMBÉM COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDEREÇO INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    INÍCIO DA INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDEREÇO DE DESVIO DAS INTERRUPÇÕES. A PRIMEIRA TAREFA É SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERAÇÃO FUTURA

	ORG	0x04		;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÁ ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES
TESTE
	BTFSS	GPIO, GP0		;CASO GP0 ESTEJA EM 0, A SAIDA GP4 NÃO DEVE SER INVERTIDA
	GOTO	SAI_INT			;VAI DIRETO PARA A SAÍDA DA INTERRUPÇÃO
	GOTO	ALTO
	
ALTO 
	
	 BTFSC   GPIO, GP4		;PULA SE GP4 = 0
	 GOTO    BAIXO			;CASO GP4 ESTEJA "SETADO" O FLUXO SEGUE PARA O "DESATIVA"
	 BSF	 GPIO, GP4		;GP4 = 1
	 BCF	 INTCON,T0IF		;T0IF = 0
	 MOVFW   TIME_ATUAL		;MOVE O VALOR ATUAL ARMAZENADO PARA O WORK
	 MOVWF   TMR0			;INSERE O VALOR NO TMR0
	 GOTO    SAI_INT		;SAI P/ A ROTINA DE SAÍDA DA INTERRUPÇÃO
    
BAIXO
	 
	 BCF     GPIO, GP4		;GP4 = 0
	 BCF	 INTCON,T0IF		;T0IF = 0
	 MOVFW   TIME_ATUAL		;MOVE O VALOR ATUAL ARMAZENADO PARA O WORK
	 MOVWF   TMR0			;INSERE O VALOR NO TMR0
	 GOTO    SAI_INT		;SAI P/ A ROTINA DE SAÍDA DA INTERRUPÇÃO
	 
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SAÍDA DA INTERRUPÇÃO                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUPÇÃO

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRIÇÃO DE FUNCIONAMENTO
; E UM NOME COERENTE ÀS SUAS FUNÇÕES.

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'00000111'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS). CONFIGURA GP0, GP1 E GP2 COM ENTRADAS E GP4 COMO SAÍDA
	MOVWF	TRISIO		;COMO SAÍDAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO DIGITAL I/O
	MOVLW	B'00000100'	;DEFINE O PRESCALER RATE DE 1:32
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'10100000'	;HABILITA GIE(INTERRUPÇÃO GLOBAL) E T0IE(INTERRRUPÇÃO DO TMR0)
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	CALL	0X03FF		;CALIBRA O CLOCK INTERNO DO PIC
	MOVWF	OSCCAL
	BANK0			;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*		      VERIFICAÇÃO DAS ENTRADAS			   *
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
	
DEF_OUTLOW			;DEFINE A SAIDA GP4 COMO 0 E VOLTA PARA O INICIO DA VERIFICAÇÃO DAS ENTRADAS
	
	;
	BCF	GPIO, GP4
        GOTO    TESTE_GP0
    
DEF_TIMER262			;DEFINE O TIME_ATUAL COMO 197 E VOLTA PARA O INICIO DA VERIFICAÇÃO DAS ENTRADAS
				;((32*256)-((1/262)/2)) / 32 = 197
	MOVLW   .197
	MOVWF   TIME_ATUAL
	GOTO    TESTE_GP0

DEF_TIMER349			;DEFINE O TIME_ATUAL COMO 212 E VOLTA PARA O INICIO DA VERIFICAÇÃO DAS ENTRADAS
				;((32*256)-((1/349)/2)) / 32 = 212
	MOVLW   .212
	MOVWF   TIME_ATUAL
	GOTO    TESTE_GP0
    
DEF_TIMER440			;DEFINE O TIME_ATUAL COMO 221 E VOLTA PARA O INICIO DA VERIFICAÇÃO DAS ENTRADAS
				;((32*256)-((1/440)/2)) / 32 = 221
	MOVLW   .221
	MOVWF   TIME_ATUAL
	GOTO    TESTE_GP0
    
DEF_TIMER523			;DEFINE O TIME_ATUAL COMO 227 E VOLTA PARA O INICIO DA VERIFICAÇÃO DAS ENTRADAS
				;((32*256)-((1/523)/2)) / 32 = 227
	MOVLW   .227
	MOVWF   TIME_ATUAL	
	GOTO    TESTE_GP0
  
FIM
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END