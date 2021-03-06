;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2014                            *
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
#INCLUDE <P12F675.INC>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

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
		DADO		;ARMAZENA O DADO PARA A EEPROM

		;NOVAS VARI�VEIS
		TAMANHO		;ARMAZENA O TAMANHO DO "ARRAY"
		X		;CONTADOR DO LA�O DE REPETI��O EXTERNO
		Y		;CONTADOR DO LA�O DE REPETI��O INTERNO
		VN		;ARMAZENA O DADO QUE ESTA NA EEPROM USANDO O VALOR ATUAL DO CONTADOR COMO INDICE
		VN1		;ARMAZENA O DADO QUE ESTA NA EEPROM USANDO O PROXIMO VALOR DO CONTADOR COMO INDICE
		AUX		;ARMAZENA O VALOR TEMPORARIAMENTE NO SWAP
		CONT		;ARMAZENA UM VALOR USADO COMO PARAMETRO
		
	ENDC			;FIM DO BLOCO DE MEM�RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA
; INICIALIZA��O DA EEPROM, DE ACORDO COM A DESCRI��O NO ARQUIVO "Def_Rega_Formigas.inc"

;A PARTIR DO ENDERE�O ZERO DA EEPROM, DADOS EM ORDEM ALEAT�RIA
	ORG 0x2100
	DE	0X89,0X1E,0X39,0X9F,0XC2,0X0C,0XAB,0X33,0X63,0XD3,0X95,0X7B,0X38,0XD6,0X1E,0X48
	DE	0XDB,0XD8,0X86,0XFD,0XA5,0XFC,0X0C,0XBE,0X68,0X9B,0XD9,0X10,0XD8,0XEC,0X90,0X91
	DE	0XAA,0XBB,0XCC,0XDD,0XEE,0XF1,0XC9,0X77

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

	ORG	0x00		;ENDERE�O INICIAL DE PROCESSAMENTO
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
LE_EEPROM
;LER DADO DA EEPROM, CUJO ENDERE�O � INDICADO EM W
;DADO LIDO RETORNA EM W
	ANDLW	.127		;LIMITA ENDERE�O MAX. 127
	BANK1			;ACESSO VIA BANK 1
	MOVWF	EEADR		;INDICA O END. DE LEITURA
	BSF	EECON1,RD	;INICIA O PROCESSO DE LEITURA
	MOVF	EEDATA,W	;COLOCA DADO LIDO EM W
	BANK0			;POSICIONA PARA BANK 0
	RETURN

GRAVA_EEPROM
	;ESCREVE DADO (DADO) NA EEPROM, CUJO ENDERE�O � INDICADO EM W
	ANDLW	.127		;LIMITA ENDERE�O MAX. 127
	BANK1			;ACESSO VIA BANK 1
	MOVWF	EEADR
	MOVF	DADO,W
	MOVWF	EEDATA
	BSF	EECON1,WREN	;HABILITA ESCRITA
	BCF	INTCON,GIE	;DESLIGA INTERRUP��ES
	MOVLW	B'01010101'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	MOVLW	B'10101010'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	BSF	EECON1,WR	;INICIA A ESCRITA
	
AGUARDA
	BTFSC	EECON1,WR	;TERMINOU?
	GOTO	AGUARDA
	BSF	INTCON,GIE	;HABILITA INTERRUP��ES
	BANK0			;POSICIONA PARA BANK 0
	RETURN

SUBROTINA1
	;CORPO DA ROTINA
	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'00000000'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00100100'	;DEFINE GP5 COMO SA�DA
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
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
	BSF	GPIO, GP5	    ;ATIVA O GP5 PARA INDICAR O INICIO DO ALGORITMO
	MOVLW	.40		    ;W = 40
	MOVWF	TAMANHO		    ;TAMANHO = W;
	
INICIA_X
	MOVLW	.0		    ;W = 0	    
	MOVWF	X		    ;X = W
	
LACO_EXTERNO			    ;for(X = 0; X < TAMANHO - 1; X++)
	;X < TAMANHO-1
	DECF	TAMANHO,0	    ;W = TAMANHO - 1
	SUBWF	X,W		    ;W = X - W
	BTFSC	STATUS,Z	    ;SE X - (TAMANHO-1) != 0, Z = 0
	GOTO	FIM		    ;SE Z = 1, SAI DO LA�O EXTERNO
	GOTO	INICIA_Y	    ;SE Z = 0, ENTRA NO LA�O INTERNO    
	FLUXO_1
	INCF	X,1		    ;X = X+1
	GOTO	LACO_EXTERNO	    ;VAI PARA A PROXIMA ITERA��O
	
INICIA_Y			    ;for(Y = 0; Y < TAMANHO-X-1; Y++)
	;Y = 0
	MOVLW	.0		    ;W = 0		    
	MOVWF	Y		    ;W = Y
	;CONTA = TAMANHO-1-X
	DECF	TAMANHO,0	    ;W = TAMANHO - 1
	MOVWF	CONT		    ;CONT = W
	MOVFW	X		    ;W = X
	SUBWF	CONT,1		    ;CONT = CONT - W
	
LACO_INTERNO
	;Y < TAMANHO-X-1
	MOVFW	CONT		    ;W = CONT
	SUBWF	Y,W		    ;W = Y - W
	BTFSC	STATUS,Z	    ;SE Y - (TAMANHO-X-1) != 0, Z = 0
	GOTO	FLUXO_1		    ;SE Z = 1, SAI DO LA�O INTERNO
	
	;SE EEPROM[Y] > EEPROM[Y+1], TROCA
	MOVFW	Y		    ;W = Y
	CALL	LE_EEPROM	    ;LE O VALOR DA EEPROM NA POSI��O Y
	MOVWF	VN		    ;GUARDA O DADO QUE ESTA NA POSI��O Y DA EEPROM EM VN
	
	INCF	Y,0		    ;W = Y+1
	CALL	LE_EEPROM	    ;LE O VALOR DA EEPROM NA POSI��O Y+1
	MOVWF	VN1		    ;GUARDA O DADO QUE ESTA NA POSI��O Y DA EEPROM EM VN1


	SUBWF	VN,W		    ;W = VN - W, OU SEJA, W = VN - VN1
	BTFSC	STATUS,C	    ;SE VN - VN1 > 0, C = 1
	GOTO	TROCA		    ;VAI PARA O "SWAP"
	
	;VOLTA PARA CONTINUAR O LA�O INTERNO
	FLUXO_2			    
	
	;Y++
	INCF	Y,1		    ;Y = Y+1	
	GOTO	LACO_INTERNO	    ;VAI PARA A PROXIMA ITERA��O	    

TROCA
	;GUARDA O VALOR DE VN
	MOVFW	VN		    ;W = VN
	MOVWF	AUX		    ;AUX = W
	;GRAVA VN1 NA POSICAO DE VN
	MOVFW	VN1		    ;W = VN1
	MOVWF	DADO		    ;DADO = W
	MOVFW	Y		    ;W = Y
	CALL	GRAVA_EEPROM
	CLRF	DADO
	;GRAVA VN NA POSICAO DE VN1
	MOVFW	AUX		    ;W = AUX
	MOVWF	DADO		    ;DADO = W
	INCF	Y, 0		    ;W = Y+1
	CALL	GRAVA_EEPROM
	CLRF	DADO
	GOTO	FLUXO_2		    ;VOLTA PARA O FLUXO PRINCIPAL DO LA�O INTERNO
		
FIM
	BCF	GPIO, GP5	    ;DESATIVA O GP5 PARA INDICAR Q O ALGORITMO TERMINOU
	GOTO FIM		    ;LOOP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
