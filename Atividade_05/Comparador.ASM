;******************RESISTORES USADOS: 5.6K E 2K*********************
;*************Vout = [5600 / (5600+2200)]* 5 = 3,589v***************

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
	BANK1			;ALTERA PARA O BANCO 1
	MOVLW	B'00000010'	;CONFIGURA GP1 COMO ENTRADA
	MOVWF	TRISIO		;COMO SAÍDAS
	MOVLW	B'00010010'	;SELECIONA A PORTA GP1 COMO ENTRADA ANALOGICA
	MOVWF	ANSEL 		;DEFINE PORTAS COMO DIGITAL I/O
	MOVLW	B'00000100'	;
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'	;
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
	MOVLW   B'10100000'	;ATIVA O Vref, INICIA COM O LOW RANGE E Vref = 0
	MOVWF	VRCON		;
	BANK0			;RETORNA PARA O BANCO
	MOVLW	B'01010100'	;SAÍDA INVERTIDA. SE V+ < V-, Cout = 1
	MOVWF	CMCON		;DEFINE O MODO DE OPERAÇÃO DO COMPARADOR ANALÓGICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZAÇÃO DAS VARIÁVEIS                 *
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
	GOTO	OUT_0		;ESCREVE 0 NA SAÍDA
	GOTO	INTERVALO_2	;VERIFICA O PRÓXIMO INTERVALO

INTERVALO_2
	
	BANK1
	MOVLW   B'10100011'	;LOW RANGE. Vref = 0,625 (0011)
	MOVWF	VRCON		;MOVE PARA VRCON
	BANK0
	BTFSS	CMCON,COUT	;VERIFICA Cout E PULA CASO ELE SEJA 1
	GOTO	OUT_1		;ESCREVE 1 NA SAÍDA
	GOTO	INTERVALO_3	;VERIFICA O PRÓXIMO INTERVALO
	
INTERVALO_3
	
	BANK1
	MOVLW   B'10100101'	;LOW RANGE. Vref = 1,041 (0101)
	MOVWF	VRCON		;MOVE PARA VRCON
	BANK0
	BTFSS	CMCON,COUT	;VERIFICA Cout E PULA CASO ELE SEJA 1
	GOTO	OUT_2		;ESCREVE 2 NA SAÍDA
	GOTO	INTERVALO_4	;VERIFICA O PRÓXIMO INTERVALO
	
INTERVALO_4
	
	BANK1
	MOVLW   B'10100111'	;LOW RANGE. Vref = 1,458 (0111)
	MOVWF	VRCON		;MOVE PARA VRCON
	BANK0
	BTFSS	CMCON,COUT	;VERIFICA Cout E PULA CASO ELE SEJA 1
	GOTO	OUT_3		;ESCREVE 3 NA SAÍDA
	GOTO	INTERVALO_5	;VERIFICA O PRÓXIMO INTERVALO
	
INTERVALO_5
	
	BANK1
	MOVLW   B'10101001'	;LOW RANGE. Vref = 1,875 (1001)
	MOVWF	VRCON		;MOVE PARA VRCON
	BANK0
	BTFSS	CMCON,COUT	;VERIFICA Cout E PULA CASO ELE SEJA 1
	GOTO	OUT_4		;ESCREVE 4 NA SAÍDA
	GOTO	INTERVALO_6	;VERIFICA O PRÓXIMO INTERVALO
	
INTERVALO_6
	BANK1
	MOVLW   B'10000110'	;HIGH RANGE. Vref = 2,187 (0110)
	MOVWF	VRCON		;MOVE PARA VRCON
	BANK0
	BTFSS	CMCON,COUT	;VERIFICA Cout E PULA CASO ELE SEJA 1
	GOTO	OUT_5		;ESCREVE 5 NA SAÍDA
	GOTO	INTERVALO_7	;VERIFICA O PRÓXIMO INTERVALO
	
INTERVALO_7
	
	BANK1
	MOVLW   B'10001000'	;HIGH RANGE. Vref = 2,500 (1000)
	MOVWF	VRCON		;MOVE PARA VRCON
	BANK0
	BTFSS	CMCON,COUT	;VERIFICA Cout E PULA CASO ELE SEJA 1
	GOTO	OUT_6		;ESCREVE 6 NA SAÍDA
	GOTO	INTERVALO_8	;VERIFICA O PRÓXIMO INTERVALO
	
INTERVALO_8
	
	BANK1
	MOVLW   B'10101110'	;LOW RANGE. Vref = 2,916 (1110)
	MOVWF	VRCON		;MOVE PARA VRCON
	BANK0
	BTFSS	CMCON,COUT	;VERIFICA Cout E PULA CASO ELE SEJA 1
	GOTO	OUT_7		;ESCREVE 7 NA SAÍDA
	GOTO	INTERVALO_9	;VERIFICA O PRÓXIMO INTERVALO
	
INTERVALO_9
	
	BANK1
	MOVLW   B'10101111'	;LOW RANGE. Vref = 3,125 (1111)
	MOVWF	VRCON		;MOVE PARA VRCON
	BANK0
	BTFSS	CMCON,COUT	;VERIFICA Cout E PULA CASO ELE SEJA 1
	GOTO	OUT_8		;ESCREVE 8 NA SAÍDA
	GOTO	OUT_9		;ESCREVE 9 NA SAÍDA
	
	;INTERVALO_10
	;MUDAR PARA A ESCALA HIGH
	;BANK1
	;MOVLW   B'10101111'	;LOW RANGE. Vref = 3,593 (1111)
	;MOVWF	VRCON		;MOVE PARA VRCON
	;BANK0
	;BTFSS	CMCON,COUT	;VERIFICA Cout E PULA CASO ELE SEJA 1
	;GOTO	OUT_9		;ESCREVE 9 NA SAÍDA
	;GOTO	OUT_10		;ESCREVE 10 NA SAÍDA
	
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
