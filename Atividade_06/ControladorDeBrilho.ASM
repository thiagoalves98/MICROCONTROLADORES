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

	ORG	0x04			;ENDERE�O INICIAL DA INTERRUP��O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER� ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES

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
	;ALTERA PARA O BANCO 1
	BANK1			
	MOVLW	B'00010000'	;CONFIGURA GP0 COMO SA�DA E GP4 COMO ENTRA ANALOGICA
	MOVWF	TRISIO		;
	MOVLW	B'00011000'	;CONFIGURA COM A MAIOR VELOCIDADE POSSIVEL PARA CONVERS�O AD (FOSC/8) E SELECIONA GP1 COMO ENTRADA ANAL�GICA
	MOVWF	ANSEL 		;
	MOVLW	B'00000010'	;DEFINE UM PRESCALER RATE DE 1:8
	MOVWF	OPTION_REG	;
	MOVLW	B'00000000'	;DESABILITA AS INTERRUP��ES
	MOVWF	INTCON		;
	;CALL	0X3FF
	;MOVWF	OSCALL
	;RETORNA PARA O BANCO
	BANK0			
	MOVLW	B'00000111'	;DESATIVA O COMPARADOR ANAL�GICO
	MOVWF	CMCON
	MOVLW	B'00001101'	;SELECIONA O AN3 COMO CANAL ANALOGICO
	MOVWF	ADCON0

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	BCF	GPIO,GP0	;GP0 = 0
	
SINALIZA_CONV
	BSF	ADCON0,GO	;SINALIZA O INICIO DA CONVERS�O (GO = 1)
	
CONVERTENDO
	BTFSC	ADCON0,GO	;VERIFICA O VALOR DE GO E PERMANECE EM LOOP ENQUANTO GO N�O FOR 0
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
	BTFSS	INTCON,T0IF	;VERIFICA O VALOR DE T0IF E PERMANECE EM LOOP ENQUANTO T0IF N�O FOR 1
	GOTO	LOOP_1
	BCF	INTCON,T0IF	;T0IF = 0
	
        ;SETA O TEMPO QUE A ONDA DEVE PERMANECER EM BAIXO (GP0 = 0)
	MOVFW	ADRESH		;W = ADRESH
	MOVWF	TMR0		;TMR0 = W
	BCF	GPIO,GP0	;GP0 = 0
	
LOOP_2
	BTFSS	INTCON,T0IF	;VERIFICA O VALOR DE T0IF E PERMANECE EM LOOP ENQUANTO T0IF N�O FOR 1
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
	BTFSS	INTCON,T0IF	;VERIFICA O VALOR DE T0IF E PERMANECE EM LOOP ENQUANTO T0IF N�O FOR 1
	GOTO	LOOP_3
	
	BCF	INTCON,T0IF	;T0IF = 0
	GOTO	SINALIZA_CONV	;VOLTA PARA OBTER UM NOVO VALOR DE ADRESH
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;COD ALTERADO DIA 28/03 �S 01;00

    END
