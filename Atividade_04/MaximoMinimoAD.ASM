;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICAÇÕES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2014                            *
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
#INCLUDE <P12F675.INC>	;ARQUIVO PADRÃO MICROCHIP PARA 12F675

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

	CBLOCK	0x20	;ENDEREÇO INICIAL DA MEMÓRIA DE USUÁRIO
	
		W_TEMP		;REGISTRADORES TEMPORÁRIOS PARA USO
		STATUS_TEMP	;JUNTO ÀS INTERRUPÇÕES
		DADO		;ARMAZENA O DADO PARA A EEPROM

		;NOVAS VARIÁVEIS
		AUX		;VARIAVEL AUXILIAR
		MENOR		;ARMAZENA O MENOR VALOR ECONTRADO NA CONVERSÃO
		MAIOR		;ARMAZENA O MAIOR VALOR ECONTRADO NA CONVERSÃO

	ENDC			;FIM DO BLOCO DE MEMÓRIA
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINIÇÃO DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA
; INICIALIZAÇÃO DA EEPROM, DE ACORDO COM A DESCRIÇÃO NO ARQUIVO "Def_Rega_Formigas.inc"

;A PARTIR DO ENDEREÇO ZERO DA EEPROM, DADOS EM ORDEM ALEATÓRIA
	ORG 0x2100
	DE	0X89,0X1E,0X39,0X9F,0XC2,0X0C,0XAB,0X33,0X63,0XD3,0X95,0X7B,0X38,0XD6,0X1E,0X48
	DE	0XDB,0XD8,0X86,0XFD,0XA5,0XFC,0X0C,0XBE,0X68,0X9B,0XD9,0X10,0XD8,0XEC,0X90,0X91
	DE	0XAA,0XBB,0XCC,0XDD,0XEE,0XF1,0XC9,0X77

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

	ORG	0x00		;ENDEREÇO INICIAL DE PROCESSAMENTO
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
	
LE_EEPROM			;LER DADO DA EEPROM, CUJO ENDEREÇO É INDICADO EM.O DADO LIDO RETORNA EM W
	ANDLW	.127		;LIMITA ENDEREÇO MAX. 127
	BANK1			;ACESSO VIA BANK 1
	MOVWF	EEADR		;INDICA O END. DE LEITURA
	BSF	EECON1,RD	;INICIA O PROCESSO DE LEITURA
	MOVF	EEDATA,W	;COLOCA DADO LIDO EM W
	BANK0			;POSICIONA PARA BANK 0
	RETURN

GRAVA_EEPROM			;ESCREVE DADO (DADO) NA EEPROM, CUJO ENDEREÇO É INDICADO EM W
	ANDLW	.127		;LIMITA ENDEREÇO MAX. 127
	BANK1			;ACESSO VIA BANK 1
	MOVWF	EEADR
	MOVF	DADO,W
	MOVWF	EEDATA
	BSF	EECON1,WREN	;HABILITA ESCRITA
	BCF	INTCON,GIE	;DESLIGA INTERRUPÇÕES
	MOVLW	B'01010101'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	MOVLW	B'10101010'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	BSF	EECON1,WR	;INICIA A ESCRITA
AGUARDA
	BTFSC	EECON1,WR	;TERMINOU?
	GOTO	AGUARDA
	BSF	INTCON,GIE	;HABILITA INTERRUPÇÕES
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
	MOVLW	B'00000001'	;
	MOVWF	TRISIO		;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVLW	B'00010010'	; 
	CLRF	ANSEL 		;DEFINE A O CLOCK MAX PARA A CONVERSÃO
	MOVLW	B'00010000'	;
	MOVWF	OPTION_REG	;DEFINE OPÇÕES DE OPERAÇÃO
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OPÇÕES DE INTERRUPÇÕES
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
	MOVLW	.0		;INICIA AS VARIAVEIS COM ZERO
	MOVWF	MENOR
	MOVWF	MAIOR
	MOVWF	AUX
	
VERIFICA_GP0
	BTFSC	GPIO,GP0	;VERIFICA O VALOR DE GP0
	GOTO	VERIFICA_GP0	;PERMANECE EM LOOP ENQUANTO GP0 NÃO FOR 0
	
SINALIZACAO_1
	BSF	ADCON0,GO	;SINALIZA O INICIO DA CONVERSÃO (GO <- 1)
	
CONVERSAO_1
	BTFSC	ADCON0,GO	;VERIFICA O VALOR DE GO
	GOTO	CONVERSAO_1	;PERMANECE EM LOOP ENQUANTO GO NÃO FOR 0
	
	MOVLW	.140		;MOVE 140 PARA O W	
	SUBWF	ADRESH,W	;SUBTRAI W DO ADRESH (ADRESH - W)
	BTFSS	STATUS,C	;VERIFICA O VALOR DE C. CASO C = 1, O VALOR DA SUBTRAÇÃO FOI > 0
	GOTO	SINALIZACAO_1	;VOLTA PARA O FAZER A CONVERSÃO NOVAMENTE
	
	MOVLW	.181		;MOVE 181 PARA O W
	MOVWF	TMR0		;NO PRESCALER 1:256 O VALOR 181 DEIXA O TIME EXATAMENTE EM 19,2ms
	BCF	INTCON,T0IF	;LIMPA A SINALIZAÇÃO DO "ESTOURO" DO TIMER

SINALIZACAO_2			;INICIA O LOOP ENQUANTO A INTERRUPÇÃO NÃO FOR ATIVADA
	
	BTFSC	INTCON,T0IF	;VERIFICA SE O CONTADOR "ESTOUROU"
	GOTO	GRAVA_VALORES	;
	BSF	ADCON0,GO	;SINALIZA O INICIO DA CONVERSÃO (GO <- 1)
	
CONVERTENDO_2
	BTFSC	ADCON0,GO	;VERIFICA O VALOR DE GO
	GOTO	CONVERTENDO_2	;PERMANECE EM LOOP ENQUANTO GO NÃO FOR 0
	
	MOVFW	ADRESH		;MOVE O VALOR OBTIDO EM ADRESH PARA O W
	MOVWF	AUX		;MOVE O W PARA O AUX
	GOTO	GUARDA_MAIOR
	FLUXO_1
	GOTO	GUARDA_MENOR
	FLUXO_2
	GOTO	SINALIZACAO_2	;VOLTA PARA O FAZER A CONVERSÃO NOVAMENTE
	
GUARDA_MAIOR			;IF AUX > MAIOR, MAIOR = AUX
	MOVFW	MAIOR		;MOVE MAIOR PARA O W
	SUBWF	AUX,W		;SUBTRAI W DO AUX (AUX - MAIOR)
	BTFSS	STATUS,C	;VERIFICA O VALOR DE C. CASO C = 1, O VALOR DA SUBTRAÇÃO FOI > 0
	GOTO	FLUXO_1		;VOLTA PARA O FLUXO INICIAL SEM ATUALIZAR O MAIOR
	MOVFW	AUX		;MOVE AUX PARA O W
	MOVWF	MAIOR		;MOVE W PARA O MAIOR
	GOTO	FLUXO_1		;VOLTA PARA O FLUXO INICIAL COM O MAIOR ATUALIZADO
	
GUARDA_MENOR			;IF AUX < MENOR, MENOR = AUX
	MOVFW	AUX		;MOVE AUX PARA O W
	SUBWF	MENOR,W		;SUBTRAI W DO MENOR (MENOR - AUX)
	BTFSS	STATUS,C	;VERIFICA O VALOR DE C. CASO C = 1, O VALOR DA SUBTRAÇÃO FOI > 0
	GOTO	FLUXO_2		;VOLTA PARA O FLUXO INICIAL SEM ATUALIZAR O MENOR
	MOVFW	AUX		;MOVE AUX PARA O W
	MOVWF	MENOR		;MOVE O W PARA O MENOR
	GOTO	FLUXO_2		;;VOLTA PARA O FLUXO INICIAL COM O MENOR ATUALIZADO
	
GRAVA_VALORES
	MOVFW	MAIOR		;MOVE MAIOR PARA W
	MOVWF	DADO		;MOVE W PARA DADO
	MOVLW	.14		;MOVE 14 (0Eh) PARA O W
	CALL	GRAVA_EEPROM	;GRAVA O MAIOR VALOR NA POSIÇÃO 0Eh DA EEPROM
	CLRF	DADO
	
	MOVFW	MENOR		;MOVE MENOR PARA W
	MOVWF	DADO		;MOVE W PARA DADO
	MOVLW	.15		;MOVE 15 (0Fh) PARA O W
	CALL	GRAVA_EEPROM	;GRAVA O MAIOR VALOR NA POSIÇÃO 0Fh DA EEPROM
	CLRF	DADO
	
	GOTO	VERIFICA_GP0	;VOLTA PARA VERIFICAR O GP0
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
