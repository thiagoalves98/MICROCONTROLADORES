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
		PACOTE
		ENDERECO
		CONTADOR
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

	ORG	0x04			;ENDEREÇO INICIAL DA INTERRUPÇÃO
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUPÇÃO                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SERÁ ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUPÇÕES

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
	MOVLW	B'00000011'	;GP5 É DEFINIDA COMO SAIDA. INICIALMENTE GP0 E GP1 SÃO DEFINIDAS COMO ENTRADA
	MOVWF	TRISIO		;
	MOVLW	B'00000000'	;DEFINE PORTAS COMO DIGITAL I/O
	MOVWF	ANSEL 		;
	MOVLW	B'00000111'	;DEFINE UM PRESCALER DE 256
	MOVWF	OPTION_REG	;
	MOVLW	B'00000000'	;NÃO HABILITA NENHUMA INTERRUPÇÃO
	MOVWF	INTCON		;
	BANK0			;RETORNA PARA O BANCO
	MOVLW	B'00000111'	;DESABILIA O COMPARADOR ANALÓGICO
	MOVWF	CMCON		;

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	BCF	GPIO,GP5	;GARANTE QUE O LED VAI INICIAR APAGADO
	MOVLW   .0
	MOVWF	CONTADOR	;CONTADOR = 0
	MOVWF	PACOTE		;PACOTE   = 0
	MOVWF	ENDERECO	;ENDERECO = 0
	
VERIFICA_STARTSEQ
	BTFSS	GPIO,GP0	;VERIFICA E PULA CASO GP0 = 1
	GOTO	VERIFICA_STARTSEQ
	BTFSS	GPIO,GP1	;VERIFICA E PULA CASO GP1 = 1
	GOTO	VERIFICA_STARTSEQ
	BTFSC	GPIO,GP1	;VERIFICA E PULA CASO GP1 = 0
	GOTO	VERIFICA_STARTSEQ
	
	
VERIFICA_SCL
	BTFSS	GPIO,GP0	;VERIFICA E PULA CASO GP0 = 1
	GOTO	VERIFICA_SCL

	BTFSS	GPIO,GP1
	GOTO	BAIXO
	GOTO	ALTO
ALTO	
	BSF	STATUS,C	;C = 1
	RLF	PACOTE,1	;PACOTE = {PACOTE,1}
	INCF	CONTADOR,1	;CONTADOR = CONTADOR +1
	GOTO	VERIFICA_CONTADOR	
	
BAIXO	
	BCF	STATUS,C	;C = 0
	RLF	PACOTE,1	;PACOTE = {PACOTE,0}
	INCF	CONTADOR,1	;CONTADOR = CONTADOR +1
	GOTO	VERIFICA_CONTADOR
	
VERIFICA_CONTADOR
	MOVLW	.8		;W = 8
	SUBWF	CONTADOR,0	;W = CONTADOR - W
	BTFSS	STATUS,Z	;SE Z=1, CONTADOR == 8
	GOTO	VERIFICA_SCL	
	
	MOVFW	PACOTE		;W = PACOTE
	MOVWF	ENDERECO	;ENDERECO = W
	BCF	STATUS,C	;C = 0
	RRF	ENDERECO,1	;ENDERECO = {0, ENDERECO}
	
	MOVLW	.83		;W = 83
	SUBWF	ENDERECO,0	;W = ENDERECO - W
	BTFSC	STATUS,Z	;SE Z=0, ENDERECO != 81, PULA A SINALIZACAO
	GOTO	SINALIZA_END
	
	CLRF	CONTADOR	;CONTADOR = 0
	GOTO	VERIFICA_SCL	;VOLTA PARA O INICIO
	
SINALIZA_END
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'00000000'	;GP0 E GP1 SÃO DEFINIDAS COMO SAIDAS
	MOVWF	TRISIO		;
	BANK0			;VOLTA PARA O BANCO 0
	BSF	GPIO,GP5	;GP5 = 1
	BCF	GPIO,GP0	;GP0 = 0
	BCF	GPIO,GP1	;GP1 = 0
	MOVLW	.60		;W=60
	MOVWF	TMR0		;TMR0 = 60 (PARA UM PRE DE 256, TEMOS 49,9ms)
	
LOOP
	BTFSS	INTCON,T0IF	;VERIFICA O ESTOURO DO TIMER
	GOTO	LOOP
	
ROTINA_SAIDA
	BCF	INTCON,T0IF	;T0IF = 0
	
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'00000011'	;GP0 E GP1 SÃO DEFINIDAS COMO ENTRADA
	MOVWF	TRISIO		;
	BANK0			;VOLTA PARA O BANCO 0

	GOTO	MAIN		;VOLTA PARA O MAIN ONDE ZERA O GP5 E TODAS AS VARIAVEIS.

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
