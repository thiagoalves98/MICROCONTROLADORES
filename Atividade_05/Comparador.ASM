;******************RESISTORES USADOS: 5.6K E 2K*********************
;*************Vout = [5600 / (5600+2200)]* 5 = 3,589v***************

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
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'00000010'	;CONFIGURA GP1 COMO ENTRADA
	MOVWF	TRISIO		;COMO SA�DAS
	MOVLW	B'00010010'	;SELECIONA A PORTA GP1 COMO ENTRADA ANALOGICA
	MOVWF	ANSEL 		;DEFINE PORTAS COMO DIGITAL I/O
	MOVLW	B'00000100'	;
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'	;
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	MOVLW   B'10100000'	;ATIVA O Vref, INICIA COM O LOW RANGE E Vref = 0
	MOVWF	VRCON		;
	BANK0			;RETORNA PARA O BANCO
	MOVLW	B'01010100'	;SA�DA INVERTIDA. SE V+ < V-, Cout = 1
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN

	;CORPO DA ROTINA PRINCIPAL
	CLRF GPIO
	
INTERVALO_1
	
	BANK1
	MOVLW   B'10100010'	;LOW RANGE. Vref = 0,416 (0010)
	MOVWF	VRCON		;MOVE PARA VRCON
	BANK0
	BTFSS	CMCON,COUT	;VERIFICA Cout E PULA CASO ELE SEJA 1
	GOTO	OUT_0		;ESCREVE 0 NA SA�DA
	GOTO	INTERVALO_2	;VERIFICA O PR�XIMO INTERVALO

INTERVALO_2
	
	BANK1
	MOVLW   B'10100011'	;LOW RANGE. Vref = 0,625 (0011)
	MOVWF	VRCON		;MOVE PARA VRCON
	BANK0
	BTFSS	CMCON,COUT	;VERIFICA Cout E PULA CASO ELE SEJA 1
	GOTO	OUT_1		;ESCREVE 1 NA SA�DA
	GOTO	INTERVALO_3	;VERIFICA O PR�XIMO INTERVALO
	
INTERVALO_3
	
	BANK1
	MOVLW   B'10100101'	;LOW RANGE. Vref = 1,041 (0101)
	MOVWF	VRCON		;MOVE PARA VRCON
	BANK0
	BTFSS	CMCON,COUT	;VERIFICA Cout E PULA CASO ELE SEJA 1
	GOTO	OUT_2		;ESCREVE 2 NA SA�DA
	GOTO	INTERVALO_4	;VERIFICA O PR�XIMO INTERVALO
	
INTERVALO_4
	
	BANK1
	MOVLW   B'10100111'	;LOW RANGE. Vref = 1,458 (0111)
	MOVWF	VRCON		;MOVE PARA VRCON
	BANK0
	BTFSS	CMCON,COUT	;VERIFICA Cout E PULA CASO ELE SEJA 1
	GOTO	OUT_3		;ESCREVE 3 NA SA�DA
	GOTO	INTERVALO_5	;VERIFICA O PR�XIMO INTERVALO
	
INTERVALO_5
	
	BANK1
	MOVLW   B'10101001'	;LOW RANGE. Vref = 1,875 (1001)
	MOVWF	VRCON		;MOVE PARA VRCON
	BANK0
	BTFSS	CMCON,COUT	;VERIFICA Cout E PULA CASO ELE SEJA 1
	GOTO	OUT_4		;ESCREVE 4 NA SA�DA
	GOTO	INTERVALO_6	;VERIFICA O PR�XIMO INTERVALO
	
INTERVALO_6
	BANK1
	MOVLW   B'10000110'	;HIGH RANGE. Vref = 2,187 (0110)
	MOVWF	VRCON		;MOVE PARA VRCON
	BANK0
	BTFSS	CMCON,COUT	;VERIFICA Cout E PULA CASO ELE SEJA 1
	GOTO	OUT_5		;ESCREVE 5 NA SA�DA
	GOTO	INTERVALO_7	;VERIFICA O PR�XIMO INTERVALO
	
INTERVALO_7
	
	BANK1
	MOVLW   B'10001000'	;HIGH RANGE. Vref = 2,500 (1000)
	MOVWF	VRCON		;MOVE PARA VRCON
	BANK0
	BTFSS	CMCON,COUT	;VERIFICA Cout E PULA CASO ELE SEJA 1
	GOTO	OUT_6		;ESCREVE 6 NA SA�DA
	GOTO	INTERVALO_8	;VERIFICA O PR�XIMO INTERVALO
	
INTERVALO_8
	
	BANK1
	MOVLW   B'10101110'	;LOW RANGE. Vref = 2,916 (1110)
	MOVWF	VRCON		;MOVE PARA VRCON
	BANK0
	BTFSS	CMCON,COUT	;VERIFICA Cout E PULA CASO ELE SEJA 1
	GOTO	OUT_7		;ESCREVE 7 NA SA�DA
	GOTO	INTERVALO_9	;VERIFICA O PR�XIMO INTERVALO
	
INTERVALO_9
	
	BANK1
	MOVLW   B'10101111'	;LOW RANGE. Vref = 3,125 (1111)
	MOVWF	VRCON		;MOVE PARA VRCON
	BANK0
	BTFSS	CMCON,COUT	;VERIFICA Cout E PULA CASO ELE SEJA 1
	GOTO	OUT_8		;ESCREVE 8 NA SA�DA
	GOTO	OUT_9		;ESCREVE 9 NA SA�DA
	
	;INTERVALO_10
	;MUDAR PARA A ESCALA HIGH
	;BANK1
	;MOVLW   B'10101111'	;LOW RANGE. Vref = 3,593 (1111)
	;MOVWF	VRCON		;MOVE PARA VRCON
	;BANK0
	;BTFSS	CMCON,COUT	;VERIFICA Cout E PULA CASO ELE SEJA 1
	;GOTO	OUT_9		;ESCREVE 9 NA SA�DA
	;GOTO	OUT_10		;ESCREVE 10 NA SA�DA
	
OUT_0
	MOVLW	B'00000000'	;ESCREVE 0000 NA SAIDA
	MOVWF	GPIO
	GOTO	INTERVALO_1
OUT_1
	MOVLW	B'00000001'	;ESCREVE 0001 NA SAIDA
	MOVWF	GPIO
	GOTO	INTERVALO_1
OUT_2
	MOVLW	B'00000100'	;ESCREVE 0010 NA SAIDA
	MOVWF	GPIO
	GOTO	INTERVALO_1
OUT_3
	MOVLW	B'00000101'	;ESCREVE 0011  NA SAIDA
	MOVWF	GPIO
	GOTO	INTERVALO_1
OUT_4
	MOVLW	B'00010000'	;ESCREVE 0100 NA SAIDA
	MOVWF	GPIO
	GOTO	INTERVALO_1
OUT_5
	MOVLW	B'00010001'	;ESCREVE 0101 NA SAIDA
	MOVWF	GPIO
	GOTO	INTERVALO_1
OUT_6
	MOVLW	B'00010100'	;ESCREVE 0110 NA SAIDA
	MOVWF	GPIO
	GOTO	INTERVALO_1
OUT_7
	MOVLW	B'00010101'	;ESCREVE 0111 NA SAIDA
	MOVWF	GPIO
	GOTO	INTERVALO_1
OUT_8
	MOVLW	B'00100000'	;ESCREVE 1000 NA SAIDA
	MOVWF	GPIO
	GOTO	INTERVALO_1
OUT_9
	MOVLW	B'00100001'	;ESCREVE 1001 NA SAIDA
	MOVWF	GPIO
	GOTO	INTERVALO_1

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
