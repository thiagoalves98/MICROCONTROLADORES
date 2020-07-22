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
	;ALTERA PARA O BANCO 1
	BANK1			
	MOVLW	B'00010000'	;CONFIGURA GP0 COMO SAÍDA E GP4 COMO ENTRA ANALOGICA
	MOVWF	TRISIO		;
	MOVLW	B'00011000'	;CONFIGURA COM A MAIOR VELOCIDADE POSSIVEL PARA CONVERSÃO AD (FOSC/8) E SELECIONA GP1 COMO ENTRADA ANALÓGICA
	MOVWF	ANSEL 		;
	MOVLW	B'00000010'	;DEFINE UM PRESCALER RATE DE 1:8
	MOVWF	OPTION_REG	;
	MOVLW	B'00000000'	;DESABILITA AS INTERRUPÇÕES
	MOVWF	INTCON		;
	;CALL	0X3FF
	;MOVWF	OSCALL
	;RETORNA PARA O BANCO
	BANK0			
	MOVLW	B'00000111'	;DESATIVA O COMPARADOR ANALÓGICO
	MOVWF	CMCON
	MOVLW	B'00001101'	;SELECIONA O AN3 COMO CANAL ANALOGICO
	MOVWF	ADCON0

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	BCF	GPIO,GP0	;GP0 = 0
	
SINALIZA_CONV
	BSF	ADCON0,GO	;SINALIZA O INICIO DA CONVERSÃO (GO = 1)
	
CONVERTENDO
	BTFSC	ADCON0,GO	;VERIFICA O VALOR DE GO E PERMANECE EM LOOP ENQUANTO GO NÃO FOR 0
	GOTO	CONVERTENDO
	
	;VERIFICA SE O VALOR LIDO CORRESPONDE A UM PWM = 0%
	;CASO ADRESH SEJA MENOR OU IGUAL A 5 (98mV), O PWM DEVE SER CONSIDERADO 0%
	MOVLW	.6		;W = 6 (CORRESPONDE A 117mV)
	SUBWF	ADRESH,W	;W = ADRESH - 6
	BTFSS	STATUS,C	;PULA CASO C = 1
	GOTO	PWM_0		;PWM = 0%
	
	;VERIFICA SE O VALOR LIDO CORRESPONDE A UM PWM = 100%
	;CASO ADRESH SEJA MAIOR QUE 230 (4,50V), O PWM DEVE SER CONSIDERADO 100%
	MOVLW	.231		;W = 231 (CORRESPONDE A 4,52V) 
	SUBWF	ADRESH,W	;W = ADRESH - 231
	BTFSC	STATUS,C	;PULA CASO C = 0
	GOTO	PWM_100		;PWM = 100%
	
	;SETA O TEMPO QUE A ONDA DEVE PERMANECER EM ALTO (GP0 = 1)
	MOVFW	ADRESH		;W = ADRESH
	SUBLW	.255		;W = 255 - W
	MOVWF	TMR0		;TMR0 = W
	BSF	GPIO,GP0	;GP0 = 1
	
LOOP_1
	BTFSS	INTCON,T0IF	;VERIFICA O VALOR DE T0IF E PERMANECE EM LOOP ENQUANTO T0IF NÃO FOR 1
	GOTO	LOOP_1
	BCF	INTCON,T0IF	;T0IF = 0
	
        ;SETA O TEMPO QUE A ONDA DEVE PERMANECER EM BAIXO (GP0 = 0)
	MOVFW	ADRESH		;W = ADRESH
	MOVWF	TMR0		;TMR0 = W
	BCF	GPIO,GP0	;GP0 = 0
	
LOOP_2
	BTFSS	INTCON,T0IF	;VERIFICA O VALOR DE T0IF E PERMANECE EM LOOP ENQUANTO T0IF NÃO FOR 1
	GOTO	LOOP_2
	
	BCF	INTCON,T0IF	;T0IF = 0
	GOTO	SINALIZA_CONV	;VOLTA PARA OBTER UM NOVO VALOR DE ADRESH

PWM_0
	MOVLW	.11		;APROXIMA O TEMPO DO CICLO PARA 1998us GERANDO UMA FREQUENCIA DE 500,50HZ
	MOVWF	TMR0		;TMR0 = 11
	BCF	GPIO,GP0	;GP0 = 0
	GOTO	LOOP_3
	
PWM_100
	MOVLW	.11		;APROXIMA O TEMPO DO CICLO PARA 2018us GERANDO UMA FREQUENCIA DE 495,50HZ
	MOVWF	TMR0		;TMR0 = 11
	BSF	GPIO,GP0	;GP0 = 1
	GOTO	LOOP_3

LOOP_3
	BTFSS	INTCON,T0IF	;VERIFICA O VALOR DE T0IF E PERMANECE EM LOOP ENQUANTO T0IF NÃO FOR 1
	GOTO	LOOP_3
	
	BCF	INTCON,T0IF	;T0IF = 0
	GOTO	SINALIZA_CONV	;VOLTA PARA OBTER UM NOVO VALOR DE ADRESH
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;COD ALTERADO DIA 28/03 ÀS 01;00

    END
