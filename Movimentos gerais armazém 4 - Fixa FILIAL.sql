/* DECLARAÇÃO INICIAL DE CONFIGURAÇÃO */
SET NOCOUNT ON
/*  DECLARA VARIÁVEIS  */
DECLARE @dateFrom datetime = '20190101'
DECLARE @dateTo datetime = '20201231'
DECLARE @filial varchar(2) = '13'
/* CHECA SE A TABELA TEMPORÁRIA #movimentos JÁ EXISTE E A DELETA */
IF OBJECT_ID('tempdb..#movimentos') IS NOT NULL DROP TABLE #movimentos
/* -------------------------------------------------------------------------- */
/* --------------- INICIA CALCULO DE MOVIMENTOS ----------------------------- */
/* -------------------------------------------------------------------------- */
-- ALOCA O RESULTADO DE TODA A CONSULTA PARA A TABELA TEMPORARIA @MOVIMENTOS
SELECT TEMPORARIA.*
INTO #movimentos
FROM
	(
		/* -- ENTRADA POR PRÉ-NOTA */
		SELECT
			'PRÉ-NOTA' AS 'TIPO REGISTRO',
			SD1010.D1_FILIAL AS 'FILIAL',
			SD1010.D1_LOCAL AS 'LOCAL',
			CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' WHEN Z01010.Z01_TME = '006' THEN 'Reuso' ELSE 'ERRO' END AS 'TIPO',
			CASE WHEN Z01010.Z01_TIPO = 2 THEN 'Aplicação Direta' WHEN Z01010.Z01_TIPO = 1 THEN 'Estoque'  ELSE 'ERRO' END AS 'TIPO DE ARMAZÉM',
			CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END AS 'SITUAÇÃO',
			CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END AS 'INVENTARIADO?',
			SD1010.D1_FILIAL+SD1010.D1_LOCAL+'-'+RTRIM(Z01010.Z01_DESC) AS 'ARMAZÉM',
			CAST(SF1010.F1_DTDIGIT AS DATETIME) AS 'DT',
			SD1010.D1_DOC AS 'DOCUMENTO',
			'NF' AS 'TP_DOC',
			'ENTRADA' AS 'MOVIMENTO',
			SD1010.D1_TES AS 'TM_TES',
			SB1010.B1_GRUPO AS 'COD GRUPO',
			RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO',
			RTRIM(SD1010.D1_COD) AS 'CODIGO',
			RTRIM(SD1010.D1_DESCRI) AS 'DESCRIÇÃO',
			SUM(SD1010.D1_QUANT) AS 'QUANTIDADE',
			SUM(SD1010.D1_TOTAL) AS 'TOTAL',
			CASE WHEN RTRIM(SD1010.D1_CLVL)='001' THEN 'INVESTIMENTO' WHEN RTRIM(SD1010.D1_CLVL)='004' THEN 'CUSTEIO - RESSUPRIMENTO' WHEN RTRIM(SD1010.D1_NFORI)<>'' THEN 'ESTORNO' ELSE 'CUSTEIO - OUTROS' END AS 'TIPO MOVIMENTO',
			CASE WHEN SF4010.F4_ESTOQUE = 'S' THEN 'SIM' ELSE 'NÃO' END AS 'ATUALIZOU ESTOQUE?',
			CASE WHEN RTRIM(SD1010.D1_NFORI)<>'' THEN 'ESTORNO (NF ORIGEM): '+RTRIM(SD1010.D1_NFORI) ELSE 'PC: '+RTRIM(SD1010.D1_PEDIDO)+' | USER INCLU: '+RTRIM(SF1010.F1_NMUSER)+' | USER CLA: '+RTRIM(SF1010.F1_NMCLASS) END AS 'DETALHE',
			RTRIM(SF1010.F1_NMUSER) AS 'USER MOVIMENTO'
		FROM PROTHEUS.dbo.SD1010 SD1010
			LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON Z01010.Z01_CODGER = (SD1010.D1_FILIAL+SD1010.D1_LOCAL) AND Z01010.D_E_L_E_T_<>'*'
			LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SD1010.D1_COD=SB1010.B1_COD AND SB1010.D_E_L_E_T_<>'*'
			LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SB1010.B1_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_<>'*'
			LEFT JOIN PROTHEUS.dbo.SF1010 SF1010 ON SD1010.D1_DOC=SF1010.F1_DOC AND SD1010.D1_SERIE=SF1010.F1_SERIE AND SD1010.D1_FORNECE=SF1010.F1_FORNECE AND SD1010.D1_LOJA=SF1010.F1_LOJA AND SF1010.D_E_L_E_T_<>'*'
			LEFT JOIN PROTHEUS.dbo.SF4010 SF4010 ON SF4010.F4_CODIGO=SD1010.D1_TES  AND SF4010.D_E_L_E_T_<>'*'
			LEFT JOIN PROTHEUS.dbo.SA2010 SA2010 ON SA2010.A2_COD=SF1010.F1_FORNECE AND SD1010.D1_LOJA=SA2010.A2_LOJA AND SA2010.D_E_L_E_T_<>'*'
		WHERE
			(SD1010.D_E_L_E_T_<>'*') AND -- RETIRA DELETADOS
			(LEFT(SA2010.A2_CGC,8)<>'05061494') AND --RETIRA ENTRADAS DE NF'S ENDICON (TRANSFERENCIA EXTERNA)
			(
				(SF1010.F1_DTDIGIT>=@dateFrom AND SF1010.F1_DTDIGIT<=@dateTo) AND  --FIXA PERIODO
				(SF4010.F4_ESTOQUE='S')  --DESCONSIDERA NF'S NÃO CLASSIFICADAS / NÃO CONTABILIZA ATIVOS
			) AND
			(SD1010.D1_FILIAL= @filial) --LOCAL E FILIAL
		GROUP BY
			SD1010.D1_FILIAL,
			SD1010.D1_LOCAL,
			CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' WHEN Z01010.Z01_TME = '006' THEN 'Reuso' ELSE 'ERRO' END,
			CASE WHEN Z01010.Z01_TIPO = 2 THEN 'Aplicação Direta' WHEN Z01010.Z01_TIPO = 1 THEN 'Estoque'  ELSE 'ERRO' END,
			CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END,
			CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END,
			SD1010.D1_FILIAL+SD1010.D1_LOCAL+'-'+RTRIM(Z01010.Z01_DESC),
			CAST(SF1010.F1_DTDIGIT AS DATETIME),
			SD1010.D1_DOC,
			SD1010.D1_TES,
			SB1010.B1_GRUPO,
			SBM010.BM_DESC,
			SD1010.D1_COD,
			SD1010.D1_DESCRI,
			CASE WHEN RTRIM(SD1010.D1_CLVL)='001' THEN 'INVESTIMENTO' WHEN RTRIM(SD1010.D1_CLVL)='004' THEN 'CUSTEIO - RESSUPRIMENTO' WHEN RTRIM(SD1010.D1_NFORI)<>'' THEN 'ESTORNO' ELSE 'CUSTEIO - OUTROS' END,
			SF4010.F4_ESTOQUE,
			CASE WHEN RTRIM(SD1010.D1_NFORI)<>'' THEN 'ESTORNO (NF ORIGEM): '+RTRIM(SD1010.D1_NFORI) ELSE 'PC: '+RTRIM(SD1010.D1_PEDIDO)+' | USER INCLU: '+RTRIM(SF1010.F1_NMUSER)+' | USER CLA: '+RTRIM(SF1010.F1_NMCLASS) END,
			RTRIM(SF1010.F1_NMUSER)
		UNION ALL
		/* -- MOVIMENTOS POR TRANSFERÊNCIA LOCAL */
		SELECT
			CASE WHEN SD3010.D3_DOC='INVENT' THEN 'INVENTÁRIO' WHEN SD3010.D3_TM IN ('499', '999') THEN 'TRANSFERÊNCIA INTERNA' END AS 'TIPO REGISTRO',
			SD3010.D3_FILIAL AS 'FILIAL',
			SD3010.D3_LOCAL AS 'LOCAL',
			CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' WHEN Z01010.Z01_TME = '006' THEN 'Reuso' ELSE 'ERRO' END AS 'TIPO',
			CASE WHEN Z01010.Z01_TIPO = 2 THEN 'Aplicação Direta' WHEN Z01010.Z01_TIPO = 1 THEN 'Estoque'  ELSE 'ERRO' END AS 'TIPO DE ARMAZÉM',
			CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END AS 'SITUAÇÃO',
			CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END AS 'INVENTARIADO?',
			SD3010.D3_FILIAL+SD3010.D3_LOCAL+'-'+RTRIM(Z01010.Z01_DESC) AS 'DESCRIÇÃO ARMAZÉM',
			CAST(SD3010.D3_EMISSAO AS DATETIME) AS 'DT',
			RTRIM(SD3010.D3_DOC) AS 'DOCUMENTO',
			'DOC SD3' AS 'TP_DOC',
			CASE WHEN (LEFT(SD3010.D3_CF,2) = 'DE') THEN 'ENTRADA' WHEN (LEFT(SD3010.D3_CF,2) = 'RE') THEN 'SAIDA' END AS 'MOVIMENTO',
			SD3010.D3_TM AS 'TM_TES',
			SB1010.B1_GRUPO AS 'COD GRUPO',
			RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO',
			RTRIM(SD3010.D3_COD) AS 'COD',
			RTRIM(SB1010.B1_DESC) AS 'DESCRIÇÃO',
			CASE WHEN SD3010.D3_TM = '499' THEN SUM(SD3010.D3_QUANT) WHEN SD3010.D3_TM = '999' THEN SUM(SD3010.D3_QUANT*-1) END AS 'QUANTIDADE',
			/*
			ATENÇÃO: AO SE UTILIZAR O VALOR POR ÚLTIMO PREÇO DE COMPRA, PERDE-SE AS VALORIZAÇÕES COM QUANTIDADE IGUAL A ZERO
			ESSAS VALORIZAÇÕES OCORREM QUANDO SE É ESCRITURADO O FRETE. ENTRA QUANTIDADE ZERO MAS COM VALOR

			-- CASE WHEN SD3010.D3_TM = '499' THEN SUM(SB1010.B1_UPRC*SD3010.D3_QUANT)  WHEN SD3010.D3_TM = '999' THEN SUM((SB1010.B1_UPRC*SD3010.D3_QUANT)*-1) END AS 'VAL TOTAL', --ULT. PREÇ. COMPRA
			*/
			CASE WHEN SD3010.D3_TM = '499' THEN SUM(SD3010.D3_CUSTO1)  WHEN SD3010.D3_TM = '999' THEN SUM(SD3010.D3_CUSTO1*-1) END AS 'VAL TOTAL', --CUSTO SISTEMA
			CASE WHEN SD3010.D3_DOC='INVENT' THEN 'INVENTÁRIO' WHEN SD3010.D3_TM IN ('499', '999') THEN 'TRANSF LOCAL' END AS 'TIPO MOVIMENTO',
			'SIM' AS 'ATUALIZOU ESTOQUE?',
			CASE
			WHEN SD3010.D3_DOC='INVENT'
				THEN 'INVENT USER: '+RTRIM(SD3010.D3_USUARIO)
			WHEN SD3010.D3_TM = '499'
				THEN
					RTRIM(ENTRADA.Z22_FILIAL+ENTRADA.Z22_ALMORI)+'->'+RTRIM(ENTRADA.Z22_FILIAL+ENTRADA.Z22_ALMDES)+' | DOC TRF:'+RTRIM(ENTRADA.Z22_DOC)+
					' - DOC SD3: '+RTRIM(ENTRADA.Z22_SD3DOC)+' SOLIC: '+RTRIM(ENTRADA.Z22_USUARI)+' OBS: '+RTRIM(ENTRADA.Z22_OBS)
			WHEN SD3010.D3_TM = '999'
				THEN
					RTRIM(SAIDA.Z22_FILIAL+SAIDA.Z22_ALMORI)+'->'+RTRIM(SAIDA.Z22_FILIAL+SAIDA.Z22_ALMDES)+' | DOC TRF:'+RTRIM(SAIDA.Z22_DOC)+
					' - DOC SD3: '+RTRIM(SAIDA.Z22_SD3DOC)+' SOLIC: '+RTRIM(SAIDA.Z22_USUARI)+' OBS: '+RTRIM(SAIDA.Z22_OBS)
			END AS 'DETALHE',
			RTRIM(SD3010.D3_USUARIO) AS 'USER MOVIMENTO'
		FROM PROTHEUS.dbo.SD3010 SD3010
			LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON SD3010.D3_LOCAL=Z01010.Z01_COD AND SD3010.D3_FILIAL=Z01010.Z01_FILIAL AND Z01010.D_E_L_E_T_ <> '*' --ARMAZÉM
			LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SD3010.D3_COD=SB1010.B1_COD AND SB1010.D_E_L_E_T_ <> '*' --PRODUTO
			LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SD3010.D3_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_ <> '*' --GRUPO DE PRODUTO
			--JOIN ENTRADA: 499
			LEFT JOIN PROTHEUS.dbo.Z22010 ENTRADA ON --TABELA DE APROVAÇÃO DE TRANSFERÊNCIAS LOCAIS
				(ENTRADA.D_E_L_E_T_<>'*') AND
				(ENTRADA.Z22_FILIAL+ENTRADA.Z22_ALMDES=SD3010.D3_FILIAL+SD3010.D3_LOCAL) AND --PESQUISA ARMAZÉM DE DESTINO
				(ENTRADA.Z22_SD3DOC=SD3010.D3_DOC) AND
				(ENTRADA.Z22_PRDDES=SD3010.D3_COD) AND
				(ENTRADA.Z22_APROV='L')
			--JOIN SAIDA: 999
			LEFT JOIN PROTHEUS.dbo.Z22010 SAIDA ON --TABELA DE APROVAÇÃO DE TRANSFERÊNCIAS LOCAIS
				(SAIDA.D_E_L_E_T_<>'*') AND
				(SAIDA.Z22_FILIAL+SAIDA.Z22_ALMORI=SD3010.D3_FILIAL+SD3010.D3_LOCAL) AND --PESQUISA ARMAZÉM DE ORIGEM
				(SAIDA.Z22_SD3DOC=SD3010.D3_DOC) AND
				(SAIDA.Z22_PRDDES=SD3010.D3_COD) AND
				(SAIDA.Z22_APROV='L')
		WHERE
			(SD3010.D_E_L_E_T_<>'*') AND -- DESCONSIDERA DELETADOS
			(SD3010.D3_ESTORNO='') AND --DESCONSIDERA ESTORNO
			(SD3010.D3_TM='499' OR SD3010.D3_TM='999') AND -- FIXA ENTRADA/SAÍDA POR TRANS LOCAL
			((SD3010.D3_EMISSAO>=@dateFrom) AND (SD3010.D3_EMISSAO<=@dateTo)) AND --FIXA PERÍODO
			SD3010.D3_FILIAL = @filial
		GROUP BY
			SD3010.D3_FILIAL,
			SD3010.D3_LOCAL,
			CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' WHEN Z01010.Z01_TME = '006' THEN 'Reuso' ELSE 'ERRO' END,
			CASE WHEN Z01010.Z01_TIPO = 2 THEN 'Aplicação Direta' WHEN Z01010.Z01_TIPO = 1 THEN 'Estoque'  ELSE 'ERRO' END,
			CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END,
			CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END,
			SD3010.D3_FILIAL+SD3010.D3_LOCAL+'-'+RTRIM(Z01010.Z01_DESC),
			CAST(SD3010.D3_EMISSAO AS DATETIME),
			SD3010.D3_DOC,
			CASE WHEN (LEFT(SD3010.D3_CF,2) = 'DE') THEN 'ENTRADA' WHEN (LEFT(SD3010.D3_CF,2) = 'RE') THEN 'SAIDA' END,
			SD3010.D3_TM,
			SB1010.B1_GRUPO,
			RTRIM(SBM010.BM_DESC),
			RTRIM(SD3010.D3_COD),
			RTRIM(SB1010.B1_DESC),
			CASE
			WHEN SD3010.D3_DOC='INVENT'
				THEN 'INVENT USER: '+RTRIM(SD3010.D3_USUARIO)
			WHEN SD3010.D3_TM = '499'
				THEN
					RTRIM(ENTRADA.Z22_FILIAL+ENTRADA.Z22_ALMORI)+'->'+RTRIM(ENTRADA.Z22_FILIAL+ENTRADA.Z22_ALMDES)+' | DOC TRF:'+RTRIM(ENTRADA.Z22_DOC)+
					' - DOC SD3: '+RTRIM(ENTRADA.Z22_SD3DOC)+' SOLIC: '+RTRIM(ENTRADA.Z22_USUARI)+' OBS: '+RTRIM(ENTRADA.Z22_OBS)
			WHEN SD3010.D3_TM = '999'
				THEN
					RTRIM(SAIDA.Z22_FILIAL+SAIDA.Z22_ALMORI)+'->'+RTRIM(SAIDA.Z22_FILIAL+SAIDA.Z22_ALMDES)+' | DOC TRF:'+RTRIM(SAIDA.Z22_DOC)+
					' - DOC SD3: '+RTRIM(SAIDA.Z22_SD3DOC)+' SOLIC: '+RTRIM(SAIDA.Z22_USUARI)+' OBS: '+RTRIM(SAIDA.Z22_OBS)
			END,
			RTRIM(SD3010.D3_USUARIO)
		UNION ALL
		/* -- MOVIMENTOS POR TRANSFERÊNCIA EXTERNA - ENTRADA*/
		SELECT
			'TRANSFERÊNCIA EXTERNA' AS 'TIPO REGISTRO',
			SD1010.D1_FILIAL AS 'FILIAL',
			SD1010.D1_LOCAL AS 'LOCAL',
			CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' WHEN Z01010.Z01_TME = '006' THEN 'Reuso' ELSE 'ERRO' END AS 'TIPO',
			CASE WHEN Z01010.Z01_TIPO = 2 THEN 'Aplicação Direta' WHEN Z01010.Z01_TIPO = 1 THEN 'Estoque'  ELSE 'ERRO' END AS 'TIPO DE ARMAZÉM',
			CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END AS 'SITUAÇÃO',
			CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END AS 'INVENTARIADO?',
			SD1010.D1_FILIAL+SD1010.D1_LOCAL+'-'+RTRIM(Z01010.Z01_DESC) AS 'DESCRIÇÃO ARMAZÉM',
			CAST(SF1010.F1_DTDIGIT AS DATETIME) AS 'DT',
			RTRIM(SD1010.D1_DOC)+'-'+RTRIM(SD1010.D1_SERIE) AS 'DOCUMENTO',
			'NF-SR' AS 'TP_DOC',
			'ENTRADA' AS 'MOVIMENTO',
			SD1010.D1_TES AS 'TM_TES',
			SB1010.B1_GRUPO AS 'COD GRUPO',
			RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO',
			RTRIM(SD1010.D1_COD) AS 'CODIGO',
			RTRIM(SD1010.D1_DESCRI) AS 'DESCRIÇÃO',
			SUM(SD1010.D1_QUANT) AS 'QUANTIDADE',
			SUM(SD1010.D1_TOTAL) AS 'VAL TOTAL',
			'TRANSF EXTERNA' AS 'TIPO DE MOVIMENTO',
			CASE WHEN SF4010.F4_ESTOQUE = 'S' THEN 'SIM' ELSE 'NÃO' END AS 'ATUALIZOU ESTOQUE?',
			-- TODO: ALGUNS DETALHES ESTÃO VINDO NULL POR MOTIVOS AINDA NÃO IDENTIFICADOS. ENTRETANTO O MOVIMENTO EXISTE E É VÁLIDO
			SD2010.D2_FILIAL+SD2010.D2_LOCAL+'->'+SD1010.D1_FILIAL+SD1010.D1_LOCAL+' | PV: '+
			RTRIM(SC5010.C5_NUM) + ' | USER: ' + RTRIM(SC5010.C5_USUINL) + ' | OBS: ' + RTRIM(SC5010.C5_MENNOTA) AS 'DETALHE',
			RTRIM(SC5010.C5_USUINL) AS 'USER MOVIMENTO'
		FROM PROTHEUS.dbo.SD1010 SD1010
			LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON Z01010.Z01_CODGER = (SD1010.D1_FILIAL+SD1010.D1_LOCAL) AND Z01010.D_E_L_E_T_<>'*'
			LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SD1010.D1_COD=SB1010.B1_COD AND SB1010.D_E_L_E_T_<>'*'
			LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SB1010.B1_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_<>'*'
			LEFT JOIN PROTHEUS.dbo.SF4010 SF4010 ON SF4010.F4_CODIGO=SD1010.D1_TES AND SF4010.D_E_L_E_T_<>'*'
			LEFT JOIN PROTHEUS.dbo.SF1010 SF1010 ON SD1010.D1_DOC=SF1010.F1_DOC AND SD1010.D1_SERIE=SF1010.F1_SERIE AND SD1010.D1_FORNECE=SF1010.F1_FORNECE AND SD1010.D1_LOJA=SF1010.F1_LOJA AND SF1010.D_E_L_E_T_<>'*'
			LEFT JOIN PROTHEUS.dbo.SA2010 SA2010 ON SA2010.A2_COD=SD1010.D1_FORNECE AND SD1010.D1_LOJA=SA2010.A2_LOJA AND SA2010.D_E_L_E_T_<>'*'
			LEFT JOIN
			(
				SELECT
					CLIENTE.A1_COD AS CLIENTE_COD,
					CLIENTE.A1_LOJA AS CLIENTE_LOJA,
					CLIENTE.A1_NREDUZ AS CLIENTE_NOME,
					CLIENTE.A1_END AS CLIENTE_END,
					CLIENTE.A1_EST AS CLIENTE_UF,
					CLIENTE.A1_MUN AS CLIENTE_MUN,
					CLIENTE.A1_BAIRRO AS CLIENTE_BAIRRO,
					CLIENTE.A1_CGC AS CLIENTE_CNPJ,
					FORNECE.A2_COD AS FORNECE_COD,
					FORNECE.A2_LOJA AS FORNECE_LOJA,
					FORNECE.A2_NREDUZ AS FORNECE_NOME,
					FORNECE.A2_END AS FORNECE_END,
					FORNECE.A2_BAIRRO AS FORNECE_BAIRRO,
					FORNECE.A2_EST AS FORNECE_UF,
					FORNECE.A2_MUN AS FORNECE_MUN,
					FORNECE.A2_CGC AS FORNECE_CNPJ
				FROM PROTHEUS.DBO.SA1010 CLIENTE
					LEFT JOIN PROTHEUS.DBO.SA2010 FORNECE ON A1_CGC=A2_CGC AND FORNECE.D_E_L_E_T_<>'*'
				WHERE
					CLIENTE.D_E_L_E_T_<>'*' AND
				    LEFT(CLIENTE.A1_CGC,8)='05061494' AND --SOMENTE FILIAIS ENDICON
					FORNECE.A2_COD <> '003333' --ESTE CODIGO COMPARTILHA O MESMO CNPJ DE OUTRA FILIAL
			) AS CLIENTE_FORNECEDOR ON SA2010.A2_CGC = CLIENTE_FORNECEDOR.[CLIENTE_CNPJ]
			--LINK COM ITENS DA NF SAÍDA
			LEFT JOIN PROTHEUS.dbo.SD2010 SD2010 ON SD1010.D1_DOC=SD2010.D2_DOC AND SD1010.D1_SERIE=SD2010.D2_SERIE AND RIGHT(SD1010.D1_ITEM,2)=SD2010.D2_ITEM AND SD2010.D2_CLIENTE = CLIENTE_FORNECEDOR.CLIENTE_COD AND SD2010.D2_LOJA = CLIENTE_FORNECEDOR.CLIENTE_LOJA AND SD2010.D_E_L_E_T_<>'*'
			--LINK COM O CABEÇALHO DO PV - PARA SAÍDA
			LEFT JOIN PROTHEUS.dbo.SC5010 SC5010 ON SC5010.C5_NUM=SD2010.D2_PEDIDO AND SD2010.D2_FILIAL=SC5010.C5_FILIAL AND SC5010.D_E_L_E_T_<>'*'
		WHERE
			(SD1010.D_E_L_E_T_<>'*') AND
			(LEFT(SA2010.A2_CGC,8)='05061494') AND --SOMENTE ENTRADAS DE NF'S ENDICON (TRANSFERENCIA EXTERNA)
			(
				(SF1010.F1_DTDIGIT>=@dateFrom AND SF1010.F1_DTDIGIT<=@dateTo) AND  --FIXA PERIODO
				(SF4010.F4_ESTOQUE='S')  --DESCONSIDERA NF'S NÃO CLASSIFICADAS / NÃO CONTABILIZA ATIVOS
			) AND
			(SD1010.D1_FILIAL= @filial)
		GROUP BY
			SD1010.D1_FILIAL,
			SD1010.D1_LOCAL,
			CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' WHEN Z01010.Z01_TME = '006' THEN 'Reuso' ELSE 'ERRO' END,
			CASE WHEN Z01010.Z01_TIPO = 2 THEN 'Aplicação Direta' WHEN Z01010.Z01_TIPO = 1 THEN 'Estoque'  ELSE 'ERRO' END,
			CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END,
			CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END,
			SD1010.D1_FILIAL+SD1010.D1_LOCAL+'-'+RTRIM(Z01010.Z01_DESC),
			SUBSTRING(SF1010.F1_DTDIGIT,5,2)+' - '+LEFT(SF1010.F1_DTDIGIT,4),
			SF1010.F1_DTDIGIT,
			RTRIM(SD1010.D1_DOC)+'-'+RTRIM(SD1010.D1_SERIE),
			SD1010.D1_TES,
			SB1010.B1_GRUPO,
			SBM010.BM_DESC,
			SD1010.D1_COD,
			SD1010.D1_DESCRI,
			SD1010.D1_CLVL,
			SF4010.F4_ESTOQUE,
			SD2010.D2_FILIAL+SD2010.D2_LOCAL+'->'+SD1010.D1_FILIAL+SD1010.D1_LOCAL+' | PV: '+
			RTRIM(SC5010.C5_NUM) + ' | USER: ' + RTRIM(SC5010.C5_USUINL) + ' | OBS: ' + RTRIM(SC5010.C5_MENNOTA),
			RTRIM(SC5010.C5_USUINL)
		UNION ALL
		/* -- MOVIMENTOS POR TRANSFERÊNCIA EXTERNA - SAÍDA*/
		SELECT
			'TRANSFERÊNCIA EXTERNA' AS 'TIPO REGISTRO',
			SD2010.D2_FILIAL AS 'FILIAL',
			SD2010.D2_LOCAL AS 'LOCAL',
			CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' WHEN Z01010.Z01_TME = '006' THEN 'Reuso' ELSE 'ERRO' END AS 'TIPO',
			CASE WHEN Z01010.Z01_TIPO = 2 THEN 'Aplicação Direta' WHEN Z01010.Z01_TIPO = 1 THEN 'Estoque'  ELSE 'ERRO' END AS 'TIPO DE ARMAZÉM',
			CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END AS 'SITUAÇÃO',
			CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END AS 'INVENTARIADO?',
			SD2010.D2_FILIAL+SD2010.D2_LOCAL+'-'+RTRIM(Z01010.Z01_DESC) AS 'ARMAZÉM',
			CAST(SD2010.D2_EMISSAO AS DATETIME) AS 'DT',
			RTRIM(SD2010.D2_DOC)+'-'+RTRIM(SD2010.D2_SERIE) AS 'DOCUMENTO',
			'NF-SR' AS 'TP_DOC',
			'SAIDA' AS 'MOVIMENTO',
			SD2010.D2_TES AS 'TM_TES',
			SB1010.B1_GRUPO AS 'COD GRUPO',
			RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO',
			RTRIM(SD2010.D2_COD) AS 'CODIGO',
			RTRIM(SB1010.B1_DESC) AS 'DESCRIÇÃO',
			CASE WHEN SD2010.D2_TIPO = 'D' THEN SUM(SD2010.D2_QUANT*-1) ELSE SUM(SD2010.D2_QUANT*-1) END AS 'QUANTIDADE',
			CASE WHEN SD2010.D2_TIPO = 'D' THEN SUM(SD2010.D2_TOTAL*-1) ELSE SUM(SD2010.D2_TOTAL*-1) END AS 'VAL TOTAL',
			CASE WHEN SD2010.D2_TIPO = 'D' THEN 'TRANSF EXTERNA' ELSE 'TRANSF EXTERNA' END AS 'TIPO DE MOVIMENTO',
			CASE WHEN SF4010.F4_ESTOQUE = 'S' THEN 'SIM' ELSE 'NÃO' END AS 'ATUALIZOU ESTOQUE?',
			CASE WHEN RTRIM(SD2010.D2_NFORI)<>'' THEN 'DEVOLUÇÃO - NF ORIGEM: '+RTRIM(SD2010.D2_NFORI)+' | PV: '+RTRIM(SC5010.C5_NUM) + ' | USER: ' + RTRIM(SC5010.C5_USUINL) ELSE SD2010.D2_FILIAL+SD2010.D2_LOCAL+'->'+SC5010.C5_FILDEST+SC5010.C5_LOCDEST+' | PV: '+RTRIM(SC5010.C5_NUM) + ' | USER: ' + RTRIM(SC5010.C5_USUINL) + ' | OBS: ' + RTRIM(SC5010.C5_MENNOTA) END AS 'DETALHE',
			RTRIM(SC5010.C5_USUINL)  AS 'USER MOV'
		FROM PROTHEUS.dbo.SD2010 SD2010
			LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON Z01010.Z01_CODGER=(SD2010.D2_FILIAL+SD2010.D2_LOCAL) AND Z01010.D_E_L_E_T_ <> '*'
			LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SD2010.D2_COD=SB1010.B1_COD AND SB1010.D_E_L_E_T_ <> '*'
			LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SB1010.B1_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_ <> '*'
			LEFT JOIN PROTHEUS.dbo.SF4010 SF4010 ON SF4010.F4_CODIGO=SD2010.D2_TES AND SF4010.D_E_L_E_T_ <> '*'
			--LINK COM GERAÇÃO DE PV PARA SAÍDA
			LEFT JOIN PROTHEUS.dbo.SC5010 SC5010 ON SC5010.C5_NOTA=SD2010.D2_DOC AND SD2010.D2_SERIE=SC5010.C5_SERIE AND SC5010.C5_FILIAL=SD2010.D2_FILIAL AND SC5010.D_E_L_E_T_<>'*'
		WHERE
			SD2010.D_E_L_E_T_<>'*' AND
			((SD2010.D2_EMISSAO>=@dateFrom) AND (SD2010.D2_EMISSAO<=@dateTo)) AND
			SF4010.F4_ESTOQUE='S' AND
			SD2010.D2_FILIAL = @filial
		GROUP BY
			SD2010.D2_FILIAL,
			SD2010.D2_LOCAL,
			CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' WHEN Z01010.Z01_TME = '006' THEN 'Reuso' ELSE 'ERRO' END,
			CASE WHEN Z01010.Z01_TIPO = 2 THEN 'Aplicação Direta' WHEN Z01010.Z01_TIPO = 1 THEN 'Estoque'  ELSE 'ERRO' END,
			CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END,
			CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END,
			SD2010.D2_FILIAL+SD2010.D2_LOCAL+'-'+RTRIM(Z01010.Z01_DESC),
			CAST(SD2010.D2_EMISSAO AS DATETIME),
			RTRIM(SD2010.D2_DOC)+'-'+RTRIM(SD2010.D2_SERIE),
			SD2010.D2_TES,
			SB1010.B1_GRUPO,
			SBM010.BM_DESC,
			SD2010.D2_COD,
			SB1010.B1_DESC,
			SD2010.D2_TIPO,
			SF4010.F4_ESTOQUE,
			CASE WHEN RTRIM(SD2010.D2_NFORI)<>'' THEN 'DEVOLUÇÃO - NF ORIGEM: '+RTRIM(SD2010.D2_NFORI)+' | PV: '+RTRIM(SC5010.C5_NUM) + ' | USER: ' + RTRIM(SC5010.C5_USUINL) ELSE SD2010.D2_FILIAL+SD2010.D2_LOCAL+'->'+SC5010.C5_FILDEST+SC5010.C5_LOCDEST+' | PV: '+RTRIM(SC5010.C5_NUM) + ' | USER: ' + RTRIM(SC5010.C5_USUINL) + ' | OBS: ' + RTRIM(SC5010.C5_MENNOTA) END,
			RTRIM(SC5010.C5_USUINL)
		UNION ALL
		/* -- MOVIMENTOS SOLICITAÇÃO AO ARMAZÉM - SAÍDA */
		SELECT
			'SOLICITAÇÃO AO ARMAZÉM' AS 'TIPO REGISTRO',
			SD3010.D3_FILIAL AS 'FILIAL',
			SD3010.D3_LOCAL AS 'LOCAL',
			CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' WHEN Z01010.Z01_TME = '006' THEN 'Reuso' ELSE 'ERRO' END AS 'TIPO',
			CASE WHEN Z01010.Z01_TIPO = 2 THEN 'Aplicação Direta' WHEN Z01010.Z01_TIPO = 1 THEN 'Estoque'  ELSE 'ERRO' END AS 'TIPO DE ARMAZÉM',
			CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END AS 'SITUAÇÃO',
			CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END AS 'INVENTARIADO?',
			SD3010.D3_FILIAL+SD3010.D3_LOCAL+'-'+RTRIM(Z01010.Z01_DESC) AS 'ARMAZÉM',
			CAST(SD3010.D3_EMISSAO AS DATETIME) AS 'DT',
			SD3010.D3_DOC AS 'DOCUMENTO',
			'RM-SA' AS 'TP_DOC',
			'SAIDA' AS 'MOVIMENTO',
			SD3010.D3_TM AS 'TM_TES',
			SB1010.B1_GRUPO AS 'COD GRUPO',
			RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO',
			RTRIM(SD3010.D3_COD) AS 'COD',
			RTRIM(SB1010.B1_DESC) AS 'DESCRIÇÃO',
			SUM(SD3010.D3_QUANT*-1) AS 'QUANTIDADE',
			SUM(SD3010.D3_CUSTO1*-1) AS 'VAL TOTAL', --VALORIZADO POR CUSTO DO SISTEMA, PEGA CORREÇÕES DE VALOR E AGREGAÇÃO DE FRETE
			--SUM((SB1010.B1_UPRC*SD3010.D3_QUANT)*-1) AS 'VAL TOTAL', --VALORIZADO POR UPC, NÃO PEGA AS CORREÇÕES DE VALOR TOTAL
			CASE
				WHEN SD3010.D3_TM = '501' AND RTRIM(SD3010.D3_CLVL)='001' THEN 'INVESTIMENTO ENDICON'
				WHEN SD3010.D3_TM = '501' AND RTRIM(SD3010.D3_CLVL)<>'001' THEN 'CUSTO ENDICON'
				WHEN SD3010.D3_TM = '502' THEN 'CUSTO CLIENTE'
				WHEN SD3010.D3_TM = '503' THEN 'AJUSTE ESTOQUE'
				WHEN SD3010.D3_TM = '505' THEN 'ATIVO'
				WHEN SD3010.D3_TM = '506' THEN 'S/APLICAÇÃO'
				WHEN SD3010.D3_TM = '507' THEN 'MAT RECONDICIONADO'
				ELSE 'ERRO'
			END AS 'TIPO MOVIMENTO',
			'SIM' AS 'ATUALIZOU ESTOQUE?',
			--DADOS DE DETALHE SOBRE MOVIMENTO
			'SA: '+RTRIM(SCQ010.CQ_NUM)+' | SOLIC: '+RTRIM(SCP010.CP_SOLICIT)+' | OBS: '+RTRIM(SCP010.CP_OBS)+' | MAT: '+ CASE WHEN SCP010.CP_FORNECE='      ' THEN '' ELSE RTRIM(SCP010.CP_FORNECE)+'-'+RTRIM(SA2010.A2_NOME) END AS 'DETALHE',
			RTRIM(SD3010.D3_USUARIO)  AS 'USER MOV'
		FROM PROTHEUS.dbo.SD3010 SD3010
			LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON SD3010.D3_LOCAL=Z01010.Z01_COD AND SD3010.D3_FILIAL=Z01010.Z01_FILIAL AND Z01010.D_E_L_E_T_ <> '*'
			LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SD3010.D3_COD=SB1010.B1_COD AND SB1010.D_E_L_E_T_ <> '*'
			LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SD3010.D3_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_ <> '*'
			--DADOS DE SA
			LEFT JOIN PROTHEUS.dbo.SCQ010 SCQ010 ON SD3010.D3_NUMSEQ=SCQ010.CQ_NUMREQ AND SCQ010.D_E_L_E_T_ <> '*'
			LEFT JOIN PROTHEUS.dbo.SCP010 SCP010 ON SCP010.CP_NUM+SCP010.CP_ITEM=SCQ010.CQ_NUM+SCQ010.CQ_ITEM AND SCP010.D_E_L_E_T_ <> '*'
			LEFT JOIN PROTHEUS.dbo.SA2010 SA2010 ON  SA2010.A2_COD=SCP010.CP_FORNECE AND SA2010.D_E_L_E_T_ <> '*'
		WHERE
			(SD3010.D_E_L_E_T_<>'*') AND
			(LEFT(SD3010.D3_CF,2) = 'RE') AND
			(SD3010.D3_ESTORNO='') AND
			(SD3010.D3_TM<>'999') AND
			((SD3010.D3_EMISSAO>=@dateFrom) AND (SD3010.D3_EMISSAO<=@dateTo)) AND
			SD3010.D3_FILIAL = @filial
		GROUP BY
			SD3010.D3_FILIAL,
			SD3010.D3_LOCAL,
			CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' WHEN Z01010.Z01_TME = '006' THEN 'Reuso' ELSE 'ERRO' END,
			CASE WHEN Z01010.Z01_TIPO = 2 THEN 'Aplicação Direta' WHEN Z01010.Z01_TIPO = 1 THEN 'Estoque'  ELSE 'ERRO' END,
			CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END,
			CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END,
			SD3010.D3_FILIAL+SD3010.D3_LOCAL+'-'+RTRIM(Z01010.Z01_DESC),
			CAST(SD3010.D3_EMISSAO AS DATETIME),
			SD3010.D3_DOC,
			SD3010.D3_TM,
			SB1010.B1_GRUPO,
			RTRIM(SBM010.BM_DESC),
			RTRIM(SD3010.D3_COD),
			RTRIM(SB1010.B1_DESC),
			CASE
				WHEN SD3010.D3_TM = '501' AND RTRIM(SD3010.D3_CLVL)='001' THEN 'INVESTIMENTO ENDICON'
				WHEN SD3010.D3_TM = '501' AND RTRIM(SD3010.D3_CLVL)<>'001' THEN 'CUSTO ENDICON'
				WHEN SD3010.D3_TM = '502' THEN 'CUSTO CLIENTE'
				WHEN SD3010.D3_TM = '503' THEN 'AJUSTE ESTOQUE'
				WHEN SD3010.D3_TM = '505' THEN 'ATIVO'
				WHEN SD3010.D3_TM = '506' THEN 'S/APLICAÇÃO'
				WHEN SD3010.D3_TM = '507' THEN 'MAT RECONDICIONADO'
				ELSE 'ERRO'
			END,
			'SA: '+RTRIM(SCQ010.CQ_NUM)+' | SOLIC: '+RTRIM(SCP010.CP_SOLICIT)+' | OBS: '+RTRIM(SCP010.CP_OBS)+' | MAT: '+ CASE WHEN SCP010.CP_FORNECE='      ' THEN '' ELSE RTRIM(SCP010.CP_FORNECE)+'-'+RTRIM(SA2010.A2_NOME) END,
			RTRIM(SD3010.D3_USUARIO)
		UNION ALL
		/* -- MOVIMENTOS SOLICITAÇÃO AO ARMAZÉM - ENTRADA */
		SELECT
			'SOLICITAÇÃO AO ARMAZÉM' AS 'TIPO REGISTRO',
			SD3010.D3_FILIAL AS 'FILIAL',
			SD3010.D3_LOCAL AS 'LOCAL',
			CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' WHEN Z01010.Z01_TME = '006' THEN 'Reuso' ELSE 'ERRO' END AS 'TIPO',
			CASE WHEN Z01010.Z01_TIPO = 2 THEN 'Aplicação Direta' WHEN Z01010.Z01_TIPO = 1 THEN 'Estoque'  ELSE 'ERRO' END AS 'TIPO DE ARMAZÉM',
			CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END AS 'SITUAÇÃO',
			CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END AS 'INVENTARIADO?',
			SD3010.D3_FILIAL+SD3010.D3_LOCAL+'-'+RTRIM(Z01010.Z01_DESC) AS 'ARMAZÉM',
			CAST(SD3010.D3_EMISSAO AS DATETIME) AS 'DT',
			SD3010.D3_DOC AS 'DOCUMENTO',
			'RM-SA' AS 'TP_DOC',
			'ENTRADA' AS 'MOVIMENTO',
			SD3010.D3_TM AS 'TM_TES',
			SB1010.B1_GRUPO AS 'COD GRUPO',
			RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO',
			RTRIM(SD3010.D3_COD) AS 'COD',
			RTRIM(SB1010.B1_DESC) AS 'DESCRIÇÃO',
			SUM(SD3010.D3_QUANT) AS 'QUANTIDADE',
			SUM(SD3010.D3_CUSTO1) AS 'VAL TOTAL', --VALORIZADO POR CUSTO DO SISTEMA, PEGA CORREÇÕES DE VALOR E AGREGAÇÃO DE FRETE
			--SUM((SB1010.B1_UPRC*SD3010.D3_QUANT)) AS 'VAL TOTAL', --VALORIZADO POR UPC, NÃO PEGA AS CORREÇÕES DE VALOR TOTAL
			CASE
				WHEN SD3010.D3_TM = '001' AND RTRIM(SD3010.D3_CLVL)='001' THEN 'DEVOLUÇÃO INVESTIMENTO ENDICON'
				WHEN SD3010.D3_TM = '001' AND RTRIM(SD3010.D3_CLVL)<>'001' THEN 'DEVOLUÇÃO CUSTO ENDICON'
				WHEN SD3010.D3_TM = '002' THEN 'DEVOLUÇÃO CUSTO CLIENTE'
				WHEN SD3010.D3_TM = '003' THEN 'AJUSTE ESTOQUE'
				WHEN SD3010.D3_TM = '005' THEN 'DEVOLUÇÃO ATIVO'
				WHEN SD3010.D3_TM = '006' THEN 'DEVOLUÇÃO S/APLICAÇÃO'
				WHEN SD3010.D3_TM = '007' THEN 'DEVOLUÇÃO MAT RECONDICIONADO'
				ELSE 'ERRO'
			END AS 'TIPO MOVIMENTO',
			'SIM' AS 'ATUALIZOU ESTOQUE?',
			'USER: '+RTRIM(SD3010.D3_USUARIO)+' | CC: '+RTRIM(SD3010.D3_CC)+'-'+RTRIM(CTT010.CTT_DESC01)+' | OBS: '+RTRIM(SD3010.D3_MEMO) AS 'DETALHE',
			RTRIM(SD3010.D3_USUARIO)  AS 'USER MOV'
		FROM PROTHEUS.dbo.SD3010 SD3010
			LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON SD3010.D3_LOCAL=Z01010.Z01_COD AND SD3010.D3_FILIAL=Z01010.Z01_FILIAL AND Z01010.D_E_L_E_T_ <> '*'
			LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SD3010.D3_COD=SB1010.B1_COD AND SB1010.D_E_L_E_T_ <> '*'
			LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SD3010.D3_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_ <> '*'
			LEFT JOIN PROTHEUS.dbo.CTT010 CTT010 ON SD3010.D3_CC=CTT010.CTT_CUSTO AND CTT010.D_E_L_E_T_ <> '*'
		WHERE
			(SD3010.D_E_L_E_T_<>'*') AND
			(LEFT(SD3010.D3_CF,2) = 'DE') AND
			(SD3010.D3_ESTORNO='') AND
			(SD3010.D3_TM<>'499') AND
			((SD3010.D3_EMISSAO>=@dateFrom) AND (SD3010.D3_EMISSAO<=@dateTo)) AND
			SD3010.D3_FILIAL = @filial
		GROUP BY
			SD3010.D3_FILIAL,
			SD3010.D3_LOCAL,
			CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' WHEN Z01010.Z01_TME = '006' THEN 'Reuso' ELSE 'ERRO' END,
			CASE WHEN Z01010.Z01_TIPO = 2 THEN 'Aplicação Direta' WHEN Z01010.Z01_TIPO = 1 THEN 'Estoque'  ELSE 'ERRO' END,
			CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END,
			CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END,
			SD3010.D3_FILIAL+SD3010.D3_LOCAL+'-'+RTRIM(Z01010.Z01_DESC),
			CAST(SD3010.D3_EMISSAO AS DATETIME),
			SD3010.D3_DOC,
			SD3010.D3_TM,
			SB1010.B1_GRUPO,
			RTRIM(SBM010.BM_DESC),
			RTRIM(SD3010.D3_COD),
			RTRIM(SB1010.B1_DESC),
			CASE
				WHEN SD3010.D3_TM = '001' AND RTRIM(SD3010.D3_CLVL)='001' THEN 'DEVOLUÇÃO INVESTIMENTO ENDICON'
				WHEN SD3010.D3_TM = '001' AND RTRIM(SD3010.D3_CLVL)<>'001' THEN 'DEVOLUÇÃO CUSTO ENDICON'
				WHEN SD3010.D3_TM = '002' THEN 'DEVOLUÇÃO CUSTO CLIENTE'
				WHEN SD3010.D3_TM = '003' THEN 'AJUSTE ESTOQUE'
				WHEN SD3010.D3_TM = '005' THEN 'DEVOLUÇÃO ATIVO'
				WHEN SD3010.D3_TM = '006' THEN 'DEVOLUÇÃO S/APLICAÇÃO'
				WHEN SD3010.D3_TM = '007' THEN 'DEVOLUÇÃO MAT RECONDICIONADO'
				ELSE 'ERRO'
			END,
			'USER: '+RTRIM(SD3010.D3_USUARIO)+' | CC: '+RTRIM(SD3010.D3_CC)+'-'+RTRIM(CTT010.CTT_DESC01)+' | OBS: '+RTRIM(SD3010.D3_MEMO),
			RTRIM(SD3010.D3_USUARIO)
	) TEMPORARIA
/* -------------------------------------------------------------------------- */
/* ---------------- TERMINA CALCULO DE MOVIMENTOS --------------------------- */
/* -------------------------------------------------------------------------- */
/*  SELECT DADOS FINAL  */
SELECT *
FROM #movimentos
ORDER BY #movimentos.DT, #movimentos.MOVIMENTO
/* FINALIZA ELIMINANDO A TABELA TEMPORÁRIA */
DROP TABLE #movimentos