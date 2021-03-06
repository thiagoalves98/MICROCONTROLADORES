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
		X1
		Y1
		Z1
		AUX
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
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	;**INICIANDO AS VARIAVEIS**
	
	MOVLW	.3	    ;MOVE 5 PARA WORK
	MOVWF	X1	    ;MOVE WORK PARA X1
	MOVLW	.5	    ;MOVE 2 PARA WORK
	MOVWF	Y1	    ;MOVE WORK PARA Y1
	MOVLW	.5	    ;MOVE 9 PARA WORK
	MOVWF	Z1	    ;MOVE WORK PARA Z1
	
	;**ESTE BLOCO VERIFICA A CONDI��O DE EXISTENCIA DO TRI�NGULO -> |(Y1-Z1)| < X1 < Y1+Z1
	
	GOTO	MODULO	    ;VAI PARA A LABEL MODULO. NELA, O MODULO DA SUBTRA��O � SALVO EM AUX -> AUX = |(Y1-Z1)|
	FLUXO_1
	GOTO	COMPARA_C1  ;VAI PARA A LABEL COMPARA. COMPARA O VALOR DE X1 E AUX. CASO AUX SEJA MAIOR QUE X1 A CONDI��O DE EXIST�NCIA � VIOLADA.
	FLUXO_2
	MOVFW	Y1	    ;MOVE Y1 PARA O WORK
	ADDWF	Z1,W	    ;FAZ Z1 + W, OU SEJA, Z1 + Y1
	MOVWF	AUX	    ;MOVE WORK PARA AUX
	GOTO	COMPARA_C2  ;VAI PARA A LABEL COMPARA. COMPARA O VALOR DE X1 COM O NOVO VALOR DE AUX. CASO X1 SEJA MAIOR QUE AUX A CONDI��O DE EXIST�NCIA � VIOLADA.
	FLUXO_3
	
	;**INICIA A COMPARA��O DOS LADOS PARA SABER QUAL � O TIPO DO TRI�NGULO
	
	GOTO	IDENTIFICA  ;VAI PARA A LABEL IDENTIFICA
	
	
MODULO
	MOVFW	Z1	    ;MOVE Z1 PARA O WORK
	SUBWF	Y1,W	    ;FAZ Y1 - WORK, OU SEJA, Y1 - Z1
	BTFSS	STATUS,C    ;PULA A LINHA DE BAIXO CASO C = 1 (PULA CASO O RESULTADO Y1-Z1 > 0, OU SEJA, Y1 MAIOR QUE Z1)
	GOTO	NEGATIVO    ;ESTA LINHA � EXECULTADA CASO C = 0	(EXECULTA CASO O RESULTADO Y1-Z1 < 0, OU SEJA, Z1 MAIOR QUE Y1)
	MOVWF	AUX	    ;MOVE WORK PARA AUX
	GOTO	FLUXO_1	    ;VOLTA PARA O FLUXO PRINCIPAL
	
NEGATIVO
	MOVFW	Y1	    ;MOVE  Y1 PARA WORK
	SUBWF	Z1,W	    ;FAZ Z1 - WORK, OU SEJA, Z1 - Y1
	MOVWF	AUX	    ;MOVE WORK PARA AUX
	GOTO	FLUXO_1	    ;VOLTA PARA O FLUXO PRINCIPAL
	
COMPARA_C1
	MOVFW	X1	    ;MOVE X1 PARA O WORK
	SUBWF	AUX,W	    ;FAZ AUX - W, OU SEJA, AUX - X1
	BTFSC	STATUS,C    ;PULA A LINHA DE BAIXO CASO C = 0 (PULA CASO O RESULTADO AUX-X1 < 0, OU SEJA, X1 MAIOR QUE AUX)
	GOTO	NTRIANGULO  ;ESTA LINHA � EXECULTADA CASO C = 1	(EXECULTA CASO O RESULTADO AUX-X1 > 0, OU SEJA, AUX MAIOR QUE X1)
	GOTO	FLUXO_2	    ;VOLTA PARA O FLUXO PRINCIPAL
	
COMPARA_C2
	MOVFW	X1	    ;MOVE X1 PARA O WORK
	SUBWF	AUX,W	    ;FAZ AUX - W, OU SEJA, AUX - X1
	BTFSS	STATUS,C    ;PULA A LINHA DE BAIXO CASO C = 1 (PULA CASO O RESULTADO AUX-X1 > 0, OU SEJA, AUX MAIOR QUE X1)
	GOTO	NTRIANGULO  ;ESTA LINHA � EXECULTADA CASO C = 0 (EXECULTA CASO O RESULTADO AUX-X1 < 0, OU SEJA, X1 MAIOR QUE AUX)
	GOTO	FLUXO_3	    ;VOLTA PARA O FLUXO PRINCIPAL

	
IDENTIFICA
	;**ESTE BLOCO FAZ A COMPARA��O DOS LADOS PARA IDENTIFICAR QUAL � O TIPO DO TRI�NGULO
	;**PARA ISSO � NECESS�RIO FAZER AS COMPARA��ES X1=Y1 E X1=Z1. COM ISSO, PODEMOS IDENTIFICAR QUAL � O TIPO DO TRI�NGULO
	
	MOVFW	Y1	    ;MOVE Y1 PARA O WORK
	SUBWF	X1,W	    ;FAZ X1-WORK, OU SEJA, X1-Y1
	BTFSS	STATUS,Z    ;PULA A LINHA DE BAIXO CASO Z = 1 (PULA CASO O RESULTADO DE X1-Y1 = 0, OU SEJA, X1 = Y1)
	GOTO	IDENTIFICA2 ;ESSA LINHA � EXECULTDA CASO Z = 0 (EXECULTA CASO O RESULTADE DE X1-Y1 !=0, OU SEJA, X1 != Y1). LOGO O TRI�NGULO PODE SER ESCALENO OU ISOSCELES MAS N�O EQUILATERO
	
	;**SE O FLUXO SEGUE POR AQUI, SIGNIFICA QUE X1 = Y1, LOGO O TRI�NGULO PODE SER ISOSCELES OU EQUILATERO
	
	MOVFW	Z1	    ;MOVE Z1 PARA O WORK
	SUBWF	X1,W	    ;FAZ X1-WORK, OU SEJA, X1-Z1
	BTFSS	STATUS,Z    ;PULA A LINHA DE BAIXO CASO Z = 1 (PULA CASO O RESULTADO DE X1-Z1 = 0, OU SEJA, X1 = Z1)
	GOTO	ISOSCELES   ;SE O PROGRAMA EXECUTAR ESSA LINHA, SIGNIFICA QUE X1 = Y1 E X1 =! Z1, E ISSO IMPLICA QUE Y1 != Z1. LOGO, ELE OBRIGATORIAMENTE � UM TRIANGULO ISOSCELES
	GOTO	EQUILATERO  ;SE O PROGRAMA EXECUTAR ESSA LINHA, SIGNIFICA QUE X1 = Y1 E X1 =  Z1, E ISSO IMPLICA QUE Y1 =  Z1. LOGO, ELE OBRIGATORIAMENTE � UM TRIANGULO EQUILATERO

IDENTIFICA2
	;**COMO O PROGRAMA ENTROU NESSE FLUXO, SABEMOS QUE X1!=Y1.
	
	MOVFW	Z1	    ;MOVE Z1 PARA O WORK
	SUBWF	X1,W	    ;FAZ X1-WORK, OU SEJA, X1-Z1
	BTFSS	STATUS,Z    ;PULA A LINHA DE BAIXO CASO Z = 1 (PULA CASO X1-Z1 = 0, OU SEJA, X1 = Z1)
	GOTO	IDENTIFICA3 ;ESTA LINHA � EXECULTADA CASO Z = 0. ISSO SIGNIFICA QUE X1=!Y1 E X1=!Z1. LOGO, � PRECISO VERIFICAR SE Y1 = Z1
	GOTO	ISOSCELES   ;ESTA LINHA � EXECULTADA CASO Z = 1. ISSO SIGNIFICA QUE X1=!Y1 E X1 =Z1 E ISSO IMPLICA QUE Y1=!Z1. LOGO, ELE OBRIGATORIAMENTE � UM TRIANGULO ISOSCELES

IDENTIFICA3
	;**COMO O PROGRAMA ENTROU NESSE FLUXO, SABEMOS QUE X1!=Y1 E X1=!Z1. 
	
	MOVFW	Y1	    ;MOVE Y1 PARA O WORK
	SUBWF	Z1,W	    ;FAZ Z1-WORK, OU SEJA, Z1-Y1
	BTFSS	STATUS,Z    ;PULA A LINHA DE BAIXO CASO Z = 1 (PULA CASO Z1-Y1 = 0, OOU SEJA, Z1 = Y1)
	GOTO	ESCALENO    ;ESTA LINHA � EXECULTADA CASO Z = 0. ISSO SIGNIFICA QUE X1=!Y1, X1=!Z1 E Y1=!Z1. LOGO, ELE � UM TRIANGULO ESCALENO
	GOTO	ISOSCELES   ;ESTA LINHA � EXECULTADA CASO Z = 1. ISSO SIGNIFICA QUE X1=!Y1, X1=!Z1 E Y1= Z1. LOGO, ELE � UM TRIANGULO ISOSCELES

	
ESCALENO
	MOVLW	.1	    ;MOVE 1 PARA WORK
	GOTO	FIM	    ;VAI PARA O FIM DO PROGRAMA

ISOSCELES
	MOVLW	.2	    ;MOVE 2 PARA WORK
	GOTO	FIM	    ;VAI PARA O FIM DO PROGRAMA
	
EQUILATERO
	MOVLW	.3	    ;MOVE 3 PARA WORK
	GOTO	FIM	    ;VAI PARA O FIM DO PROGRAMA
	
NTRIANGULO
	MOVLW	.4	    ;MOVE 4 PARA O WORK
	GOTO	FIM	    ;VAI PARA O FIM DO PROGRAMA
	
FIM
	GOTO FIM


;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
