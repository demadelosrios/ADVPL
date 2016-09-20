#Include 'Protheus.ch'



/*/{Protheus.doc} PRRAjSF4
Rotina para Ajustar SF4 - Texto 	
@type function
@author Win10_Dev
@since 10/08/2016
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)

/*/User Function PRRAjSF4()

Local aArea 		:= GetArea()
Local cSF4Alias 	:= "SF4"
Local cSX5Alias 	:= "SX5"
Local cX5Chave		:= xFilial("SX5") + "13"
Local cLogOk 		:= ""
Local cLogNotOk		:= ""  
Local cDescr		:= ""
Local cTxtPerg		:= "Ao executar essa rotina, será ajustado o campo F4_TEXTO de todas as TES Cadastradas de acordo com a Descrição do cadastro de CFOP."


If MSGYesNo("Ajuste SF4!"+CRLF+cTxtPerg+CRLF+CRLF+"Deseja Continuar?") 
	dbSelectArea(cSX5Alias)
	(cSX5Alias)->(dbSetOrder(1))
	
	dbSelectArea(cSF4Alias)
	(cSF4Alias)->(dbGoTop())
	While (cSF4Alias)->(!EOF())
	
		If (cSX5Alias)->(MsSeek( cX5Chave + AllTrim((cSF4Alias)->F4_CF )  ))
		
			cDescr 	:= X5Descri()
			
			If Reclock(cSF4Alias,.F.)
				
				(cSF4Alias)->F4_TEXTO  := AllTrim(cDescr)
				cLogOk	+= (cSF4Alias)->F4_CODIGO  + " ; " + " Alterado com sucesso! " + CRLF 
				
				(cSF4Alias)->(MsUnlock())
			EndIf 
		
		Else 
		
			cLogNotOk += (cSF4Alias)->F4_CODIGO  + " ; " + " Não encontrado CFOP na tabela genérica 13." + CRLF 
			
		EndIf 
	
		(cSF4Alias)->(dbSkip())
	EndDo 
	
	cLog := Iif( !Empty(cLogOk) , "TES alteradas com sucesso: " + CRLF + CRLF + cLogOk , "" )
	cLog += CRLF + CRLF + Replicate("-",40) + CRLF + CRLF 
	cLog += Iif( !Empty(cLogNotOk) , "TES não alteradas: " + CRLF + CRLF + cLogNotOk , "" )
	
	Aviso("Fim do Processamento",cLog,{"Fechar"},3)

Else 
	Alert("Operação Abortada!")
EndIf 

RestArea(aArea)

Return Nil

