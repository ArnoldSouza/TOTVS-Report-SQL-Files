SELECT
	SCP010.CP_FILIAL AS 'FILIAL',
	SCP010.CP_LOCAL AS 'ARMAZÉM',
	RTRIM(Z01010.Z01_DESC) AS 'DESC_ALMOX', 
	SCP010.CP_NUM AS 'NUM SA',
	SCP010.CP_ITEM AS 'ITEM',
	SCP010.CP_PRODUTO AS 'COD',
	RTRIM(SCP010.CP_DESCRI) AS 'DESCRIÇÃO DO PRODUTO',
	SCP010.CP_UM AS 'UND',
	SCP010.CP_QUANT AS 'QTDE',
	SB1010.B1_UPRC AS 'R$ UND (ULT R$ COMPR)', 
	(SB1010.B1_UPRC*SCP010.CP_QUANT) AS 'R$ TOTAL (ULT R$ COMPR)', 
	SCP010.CP_QUJE AS 'QTDE ATENDIDA',
	(SB1010.B1_UPRC*SCP010.CP_QUJE) AS 'R$ TOTAL ATENDIDO (ULT R$ COMPR)', 
	(SCP010.CP_QUANT-SCP010.CP_QUJE) AS 'QTDE FALTA ATENDER',
	RTRIM(SCP010.CP_OBS) AS 'OBSERVAÇÃO',
	SB1010.B1_GRUPO AS 'GRUPO',
	RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO',  
	RTRIM(SCP010.CP_CC) AS 'CENTRO DE CUSTO',
	RTRIM(CTT010.CTT_DESC01) AS 'DESC CENTRO DE CUSTO',

  CASE WHEN CTT010.CTT_TPCC = 'O' THEN SBM010.BM_CTACUST ELSE SBM010.BM_CTADESP END AS 'C CONTABIL CORRETA',

	RTRIM(SCP010.CP_CONTA) AS 'CONTA CONTÁBIL',
	RTRIM(CT1010.CT1_DESC01) AS 'DESC CONTA',
	CAST(SCP010.CP_EMISSAO AS DATETIME) AS 'DT EMISSÃO', 
	CASE WHEN SCP010.CP_PREREQU = 'S' THEN 'SIM' WHEN SCP010.CP_PREREQU = ' '  THEN 'NÃO' ELSE 'ERRO' END AS 'PRE-REQUISIÇÃO', 
	CASE WHEN SCP010.CP_STATUS = 'E' THEN 'ENCERRADA' WHEN SCP010.CP_STATUS = ' ' THEN 'ABERTA' ELSE 'ERRO' END AS 'STATUS DA SA', 
	CASE WHEN SCP010.CP_STATSA = 'L' THEN 'LIBERADA' WHEN SCP010.CP_STATSA = 'B' THEN 'BLOQUEADA' ELSE 'ERRO' END AS 'STATUS SA', 
	SCP010.CP_ITEMCTA AS 'CARRO',
	RTRIM(SCP010.CP_ITEMCTA+' - '+CTD010.CTD_DESC01) AS 'DESC CARRO',
	SCP010.CP_CLVL AS 'OBRA',
	RTRIM(SCP010.CP_CLVL+' - '+CTH010.CTH_DESC01) AS 'DESC OBRA/PROJETO',
	SCP010.CP_NUMSC AS 'NUM SC',
	SCP010.CP_ITSC AS 'ITEM SC',
	SCP010.CP_USUARIO AS 'USUÁRIO',
	SCP010.CP_SOLICIT AS 'SOLICITANTE',
	SCP010.CP_FORNECE AS 'MATRÍCULA',
	CASE WHEN SCP010.CP_FORNECE='      ' THEN '' ELSE RTRIM(SA2010.A2_NOME) END AS 'NOME',
	SCP010.CP_HORINCL AS 'HORA INCLUSÃO'
FROM PROTHEUS.dbo.SCP010 SCP010 
	LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SCP010.CP_PRODUTO=SB1010.B1_COD AND SB1010.D_E_L_E_T_ <> '*'
	LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON SCP010.CP_LOCAL=Z01010.Z01_COD AND SCP010.CP_FILIAL=Z01010.Z01_FILIAL AND Z01010.D_E_L_E_T_ <> '*' 
	LEFT JOIN PROTHEUS.dbo.CTT010 CTT010 ON SCP010.CP_CC=CTT010.CTT_CUSTO AND CTT010.D_E_L_E_T_ <> '*'  
	LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SB1010.B1_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_ <> '*'  
	LEFT JOIN PROTHEUS.dbo.CT1010 CT1010 ON SCP010.CP_CONTA=CT1010.CT1_CONTA AND CT1010.D_E_L_E_T_ <> '*' 
	LEFT JOIN PROTHEUS.dbo.CTD010 CTD010 ON SCP010.CP_ITEMCTA=CTD010.CTD_ITEM
	LEFT JOIN PROTHEUS.dbo.CTH010 CTH010 ON SCP010.CP_CLVL=CTH010.CTH_CLVL
	LEFT JOIN PROTHEUS.dbo.SA2010 SA2010 ON  SA2010.A2_COD=SCP010.CP_FORNECE
WHERE
	SCP010.D_E_L_E_T_<>'*' AND
	SCP010.CP_FILIAL = '13' AND
	SCP010.CP_PREREQU=' ' AND
	SCP010.CP_QUJE<SCP010.CP_QUANT AND
	SCP010.CP_STATUS=' ' AND
	SCP010.CP_STATSA='L' AND
	(SCP010.CP_EMISSAO>='20200101' AND SCP010.CP_EMISSAO<='20181231')