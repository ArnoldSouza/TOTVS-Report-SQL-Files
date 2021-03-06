/* DECLARAÇÃO INICIAL DE CONFIGURAÇÃO */
SET NOCOUNT ON
/*  DECLARA VARIÁVEIS  */
DECLARE @dateFrom datetime = '20180101'
DECLARE @dateTo datetime = '20191231'
/* -------------------------------------------------------------------------- */
/* ----------------------------- INICIA CALCULO ----------------------------- */
/* -------------------------------------------------------------------------- */

/* -- TRANSFERÊNCIA INTERNA - SAÍDA */
SELECT
	Z22010.Z22_FILIAL+Z22010.Z22_ALMORI AS 'ORIGEM',
	Z22010.Z22_FILIAL+Z22010.Z22_ALMDES AS 'DESTINO',
	Z22010.Z22_FILIAL+Z22010.Z22_ALMORI+'->'+Z22010.Z22_FILIAL+Z22010.Z22_ALMDES AS 'DE->PARA',
	--Z22010.Z22_DOC AS 'DOCUMENTO', --DOCUMENTO NA TABELA DE APROVAÇÃO DE TRANSFERÊNCIAS
	RTRIM(Z22010.Z22_SD3DOC) AS 'DOCUMENTO',
	'SD3 MOV INTERNOS' AS 'TP DOC',
	RTRIM(Z22010.Z22_PRDORI) AS 'PRODUTO',
	RTRIM(PRODUTO.DESCRICAO) AS 'DESCRIÇÃO',
	Z22010.Z22_UM AS 'UND',
	Z22010.Z22_QUANT AS 'QTDE',
	PRODUTO.ULTIMO_PREÇO AS 'VAL UND',
	(Z22010.Z22_QUANT*PRODUTO.ULTIMO_PREÇO) AS 'VAL TOTAL',
	RTRIM(PRODUTO.DESC_GRUPO) AS 'DESCRIÇÃO GRUPO',

	Z22010.Z22_USUARI AS 'SOLICITANTE TRANSFERÊNCIA',
	Case RTrim(Coalesce(Z22010.Z22_EMISSA,'')) WHEN ''  THEN Null ELSE convert(datetime, Z22010.Z22_EMISSA, 112)END AS 'DT SOLICITADO',

	CASE RTRIM(Coalesce((SELECT MAX(LastUpdateDate) FROM (VALUES (Z22010.Z22_DTLIB1), (Z22010.Z22_DTLIB2), (Z22010.Z22_DTLIB3)) AS UpdateDate(LastUpdateDate)),''))
		WHEN '' THEN Null
		ELSE convert(datetime,(SELECT MAX(LastUpdateDate) FROM (VALUES (Z22010.Z22_DTLIB1), (Z22010.Z22_DTLIB2), (Z22010.Z22_DTLIB3)) AS UpdateDate(LastUpdateDate)), 112)
	END AS 'DATA REALIZADO',

	CASE
		WHEN Z22010.Z22_APROV='L' OR Z22010.Z22_APROV='R'
			THEN DATEDIFF(DAY,Z22010.Z22_EMISSA,(SELECT MAX(LastUpdateDate) FROM (VALUES (Z22010.Z22_DTLIB1),(Z22010.Z22_DTLIB2),(Z22010.Z22_DTLIB3)) AS UpdateDate(LastUpdateDate)))
		ELSE DATEDIFF(DAY,Z22010.Z22_EMISSA, GETDATE())
	END AS 'TEMPO DECORRIDO',

	RTRIM(Z22010.Z22_OBS) AS 'OBSERVAÇÃO',

	'1' AS 'ROUTE ORDER',
	Z22010.Z22_FILIAL+Z22010.Z22_ALMORI AS 'ROUTE LOCATION',
	'INTERNA' AS 'TRANSFERÊNCIA'
FROM PROTHEUS.dbo.Z22010 Z22010 --TAB DE TRANSFERÊNCIAS
	LEFT JOIN
		(
			SELECT
				SB1010.B1_COD AS CODIGO,
				SB1010.B1_DESC AS DESCRICAO,
				SB1010.B1_GRUPO AS COD_GRUPO,
				GRUPO.DESCRICAO_GRUPO AS DESC_GRUPO,
				SB1010.B1_UPRC AS ULTIMO_PREÇO
			FROM PROTHEUS.dbo.SB1010 SB1010
				LEFT JOIN
					(
						SELECT
							SBM010.BM_GRUPO AS CODIGO_GRUPO,
							SBM010.BM_DESC AS DESCRICAO_GRUPO
						FROM PROTHEUS.dbo.SBM010 SBM010
						WHERE
							(SBM010.D_E_L_E_T_<>'*')
					) AS GRUPO ON SB1010.B1_GRUPO=GRUPO.CODIGO_GRUPO
			WHERE
				(SB1010.D_E_L_E_T_<>'*')
		) AS PRODUTO ON Z22010.Z22_PRDORI=PRODUTO.CODIGO
WHERE
	(Z22010.D_E_L_E_T_ <>'*')	AND
	((Z22010.Z22_SD3DOC<>'         ') OR Z22010.Z22_APROV = 'L') AND
	(
		(SELECT MAX(LastUpdateDate) FROM (VALUES (Z22010.Z22_DTLIB1), (Z22010.Z22_DTLIB2), (Z22010.Z22_DTLIB3)) AS UpdateDate(LastUpdateDate))>= @dateFrom AND
		(SELECT MAX(LastUpdateDate) FROM (VALUES (Z22010.Z22_DTLIB1), (Z22010.Z22_DTLIB2), (Z22010.Z22_DTLIB3)) AS UpdateDate(LastUpdateDate)) <= @dateTo
	)


UNION ALL


/* -- TRANSFERÊNCIA INTERNA - ENTRADA */
SELECT
	Z22010.Z22_FILIAL+Z22010.Z22_ALMORI AS 'ORIGEM',
	Z22010.Z22_FILIAL+Z22010.Z22_ALMDES AS 'DESTINO',
	Z22010.Z22_FILIAL+Z22010.Z22_ALMORI+'->'+Z22010.Z22_FILIAL+Z22010.Z22_ALMDES AS 'DE->PARA',
	--Z22010.Z22_DOC AS 'DOCUMENTO', --DOCUMENTO NA TABELA DE APROVAÇÃO DE TRANSFERÊNCIAS
	RTRIM(Z22010.Z22_SD3DOC) AS 'DOCUMENTO',
	'SD3 MOV INTERNOS' AS 'TP DOC',
	RTRIM(Z22010.Z22_PRDORI) AS 'PRODUTO',
	RTRIM(PRODUTO.DESCRICAO) AS 'DESCRIÇÃO',
	Z22010.Z22_UM AS 'UND',
	Z22010.Z22_QUANT AS 'QTDE',
	PRODUTO.ULTIMO_PREÇO AS 'VAL UND',
	(Z22010.Z22_QUANT*PRODUTO.ULTIMO_PREÇO) AS 'VAL TOTAL',
	RTRIM(PRODUTO.DESC_GRUPO) AS 'DESCRIÇÃO GRUPO',

	Z22010.Z22_USUARI AS 'SOLICITANTE TRANSFERÊNCIA',

	Case RTrim(Coalesce(Z22010.Z22_EMISSA,'')) WHEN ''  THEN Null ELSE convert(datetime, Z22010.Z22_EMISSA, 112)END AS 'DT SOLICITADO',

	CASE RTRIM(Coalesce((SELECT MAX(LastUpdateDate) FROM (VALUES (Z22010.Z22_DTLIB1), (Z22010.Z22_DTLIB2), (Z22010.Z22_DTLIB3)) AS UpdateDate(LastUpdateDate)),''))
		WHEN '' THEN Null
		ELSE convert(datetime,(SELECT MAX(LastUpdateDate) FROM (VALUES (Z22010.Z22_DTLIB1), (Z22010.Z22_DTLIB2), (Z22010.Z22_DTLIB3)) AS UpdateDate(LastUpdateDate)), 112)
	END AS 'DATA REALIZADO',

	CASE
		WHEN Z22010.Z22_APROV='L' OR Z22010.Z22_APROV='R'
			THEN DATEDIFF(DAY,Z22010.Z22_EMISSA,(SELECT MAX(LastUpdateDate) FROM (VALUES (Z22010.Z22_DTLIB1),(Z22010.Z22_DTLIB2),(Z22010.Z22_DTLIB3)) AS UpdateDate(LastUpdateDate)))
		ELSE DATEDIFF(DAY,Z22010.Z22_EMISSA, GETDATE())
	END AS 'TEMPO DECORRIDO',

	RTRIM(Z22010.Z22_OBS) AS 'OBSERVAÇÃO',

	'2' AS 'ROUTE ORDER',
	Z22010.Z22_FILIAL+Z22010.Z22_ALMDES AS 'ROUTE LOCATION',
	'INTERNA' AS 'TRANSFERÊNCIA'
FROM PROTHEUS.dbo.Z22010 Z22010 --TAB DE TRANSFERÊNCIAS
	LEFT JOIN
		(
			SELECT
				SB1010.B1_COD AS CODIGO,
				SB1010.B1_DESC AS DESCRICAO,
				SB1010.B1_GRUPO AS COD_GRUPO,
				GRUPO.DESCRICAO_GRUPO AS DESC_GRUPO,
				SB1010.B1_UPRC AS ULTIMO_PREÇO
			FROM PROTHEUS.dbo.SB1010 SB1010
				LEFT JOIN
					(
						SELECT
							SBM010.BM_GRUPO AS CODIGO_GRUPO,
							SBM010.BM_DESC AS DESCRICAO_GRUPO
						FROM PROTHEUS.dbo.SBM010 SBM010
						WHERE
							(SBM010.D_E_L_E_T_<>'*')
					) AS GRUPO ON SB1010.B1_GRUPO=GRUPO.CODIGO_GRUPO
			WHERE
				(SB1010.D_E_L_E_T_<>'*')
		) AS PRODUTO ON Z22010.Z22_PRDORI=PRODUTO.CODIGO

WHERE
	(Z22010.D_E_L_E_T_ <>'*')	AND
	((Z22010.Z22_SD3DOC<>'         ') OR Z22010.Z22_APROV = 'L') AND
	(
		(
			SELECT MAX(LastUpdateDate)
			FROM (VALUES (Z22010.Z22_DTLIB1), (Z22010.Z22_DTLIB2), (Z22010.Z22_DTLIB3)) AS UpdateDate(LastUpdateDate)
		)>= @dateFrom AND
		(
			SELECT MAX(LastUpdateDate)
			FROM (VALUES (Z22010.Z22_DTLIB1), (Z22010.Z22_DTLIB2), (Z22010.Z22_DTLIB3)) AS UpdateDate(LastUpdateDate)
		) <= @dateTo
	)


UNION ALL


/* -- TRANSFERÊNCIA EXTERNA - SAÍDA */
SELECT
	--DADOS DE FILIAL E ARMAZÉM
	SD2010.D2_FILIAL+SD2010.D2_LOCAL AS 'ORIGEM',
	SC5010.C5_FILDEST+SC5010.C5_LOCDEST AS 'DESTINO',
	SC5010.C5_FILIAL+SC6010.C6_LOCAL +'->'+ SD1010.D1_FILIAL+SD1010.D1_LOCAL AS 'DE->PARA',
	RTRIM(SD2010.D2_DOC) AS 'DOCUMENTO',
	'SD2/SD1 NF REMESSA' AS 'TP DOC',
	RTRIM(SD2010.D2_COD) AS 'PRODUTO',
	RTRIM(SB1010.B1_DESC) AS 'DESCRIÇÃO',
	SD2010.D2_UM AS 'UND',
	CASE WHEN SD2010.D2_TIPO = 'D' THEN SD2010.D2_QUANT*-1 ELSE SD2010.D2_QUANT END AS 'QTDE',
	SD2010.D2_PRCVEN AS 'VAL UND', --O PREÇO UTILIZADO É O PREÇO DE VENDA
	CASE WHEN SD2010.D2_TIPO = 'D' THEN SD2010.D2_TOTAL*-1 ELSE SD2010.D2_TOTAL END AS 'VAL TOTAL',
	RTRIM(SBM010.BM_DESC) AS 'DESCRIÇÃO GRUPO',
	RTRIM(SC5010.C5_USUINL) AS 'SOLICITANTE TRANSFERÊNCIA',
	Case RTrim(Coalesce(SD2010.D2_EMISSAO,'')) WHEN ''  THEN Null ELSE convert(datetime,SD2010.D2_EMISSAO, 112)END AS 'DT SOLICITADO',
	Case RTrim(Coalesce(NF_ENT_CABE.[DT DIGITAÇÃO],'')) WHEN ''  THEN Null ELSE convert(datetime,NF_ENT_CABE.[DT DIGITAÇÃO], 112)END AS 'DT REALIZADO',
	DATEDIFF(DAY,SD2010.D2_EMISSAO, NF_ENT_CABE.[DT DIGITAÇÃO]) AS 'TEMPO DECORRIDO',

	--OBSERVAÇÃO
	'TS/TE:'+SD2010.D2_TES+'/'+SD1010.D1_TES+' | '+
    'PV:'+SD2010.D2_PEDIDO+' | '+
    'OBS:'+RTRIM(SC5010.C5_MENNOTA)+' | '+
    'FOR:'+CASE WHEN SD2010.D2_TIPO = 'D' THEN RTRIM(SA2010.A2_CGC) ELSE RTRIM(SA1010.A1_CGC) END+'-'+CASE WHEN SD2010.D2_TIPO = 'D' THEN RTRIM(SA2010.A2_NREDUZ) ELSE RTRIM(SA1010.A1_NREDUZ) END +' | '+
    'STK/PN:'+SD2010.D2_ESTOQUE+'/'+SC5010.C5_PRENF+' | '+
    'SIT:'+CASE WHEN SD1010.D1_TES = '   ' THEN 'Ñ.CLA' ELSE 'CLA' END AS 'OBSERVAÇÃO',

	'1' AS 'ROUTE ORDER',
	SC5010.C5_FILIAL+SC6010.C6_LOCAL AS 'ROUTE LOCATION',
	'EXTERNA' AS 'TRANSFERÊNCIA'
FROM PROTHEUS.dbo.SD2010 SD2010
	LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SB1010.B1_COD=SD2010.D2_COD AND SB1010.D_E_L_E_T_<>'*' -- LINK DESCRIÇÃO PRODUTO
	LEFT JOIN PROTHEUS.dbo.SA1010 SA1010 ON SA1010.A1_COD=SD2010.D2_CLIENTE AND SA1010.A1_LOJA=SD2010.D2_LOJA AND SA1010.D_E_L_E_T_<>'*' --TABELA DE CLIENTES (SAÍDA: P NF'S DE TRANSFERÊNCIA)
	LEFT JOIN PROTHEUS.dbo.SA2010 SA2010 ON SA2010.A2_COD=SD2010.D2_CLIENTE AND SA2010.A2_COD=SD2010.D2_LOJA AND SA2010.D_E_L_E_T_<>'*' --TABELA DE FORNECEDORES (ENTRADA: P/ NF'S DE DEVOLUÇÃO)
	LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SB1010.B1_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_<>'*' --LINK DE GRUPO DE PRODUTO
	--LINK COM O CABEÇALHO DO PV
	LEFT JOIN PROTHEUS.dbo.SC5010 SC5010 ON SC5010.C5_NUM=SD2010.D2_PEDIDO AND SD2010.D2_FILIAL=SC5010.C5_FILIAL AND SC5010.D_E_L_E_T_<>'*'
	--LINK COM CORPO DO PV
	LEFT JOIN PROTHEUS.dbo.SC6010 SC6010 ON SC6010.C6_FILIAL=SD2010.D2_FILIAL AND SC6010.C6_LOCAL = SD2010.D2_LOCAL AND SD2010.D2_PEDIDO = SC6010.C6_NUM AND SD2010.D2_ITEMPV = SC6010.C6_ITEM AND SC6010.D_E_L_E_T_<>'*'
	--LINK COM O CABEÇALHO DA NF SAÍDA
	LEFT JOIN PROTHEUS.dbo.SF2010 SF2010 ON SF2010.F2_DOC=SD2010.D2_DOC AND SF2010.F2_SERIE=SD2010.D2_SERIE AND SF2010.F2_CLIENTE=SD2010.D2_CLIENTE AND SF2010.F2_LOJA=SD2010.D2_LOJA AND SF2010.D_E_L_E_T_<>'*'
	--LINK COM O CABEÇALHO DA NF ENTRADA
	LEFT JOIN (
		SELECT
			SF1010.F1_FILIAL AS 'FILIAL PARA',
			SF1010.F1_DOC AS 'DOC PARA',
			SF1010.F1_SERIE AS 'SERIE PN',
			FORN.A2_COD 'FORNECEDOR',
			FORN.A2_LOJA AS 'LOJA FORNECEDOR',
			FORN.A2_CGC AS 'CNPJ FORNECEDOR',
			SF1010.F1_NMCLASS 'USER CLASSIFICAÇÃO', --USUÁRIO CLASSIFICOU
			Case RTrim(Coalesce(SF1010.F1_DTDIGIT,'')) WHEN ''  THEN Null ELSE convert(datetime,SF1010.F1_DTDIGIT, 112)END AS 'DT DIGITAÇÃO', --DT EM QUE OCORREU A CLASSIFICAÇÃO
			Case RTrim(Coalesce(SF1010.F1_DTINCL,'')) WHEN ''  THEN Null ELSE convert(datetime,SF1010.F1_DTINCL, 112)END AS 'DT INCLUSÃO',
			Case RTrim(Coalesce(SF1010.F1_DTLANC,'')) WHEN ''  THEN Null ELSE convert(datetime,SF1010.F1_DTLANC, 112)END AS 'DT CLASSIFICAÇÃO',  --DT DA CONTABILIZAÇÃO
			Case RTrim(Coalesce(SF1010.F1_RECBMTO,'')) WHEN ''  THEN Null ELSE convert(datetime,SF1010.F1_RECBMTO, 112)END AS 'DT RECEBIMENTO', --DT EM QUE O MATERIAL FOI RECEBIDO
			SF1010.F1_NMUSER 'USER INCLUSÃO PN', --USUÁRIO INCLUIU PRENOTA
			SF1010.F1_LOGNF AS 'HISTORICO NF',
			SF1010.F1_OBS AS 'OBS PN', --OBS. PRE-NOTA
			SF1010.F1_MOTRET AS 'MOT REJEIÇÃO', --MOT. RETORNO
			SF1010.F1_OBSCLA AS 'OBS CLASSIFICAÇÃO', --OBS. CLASSIF
			SF1010.F1_ESPECIE AS 'ESPECIE DOC PN' --ESPEC. DOC
		FROM PROTHEUS.dbo.SF1010 SF1010
			LEFT JOIN PROTHEUS.dbo.SA2010 FORN ON SF1010.F1_FORNECE = FORN.A2_COD AND SF1010.F1_LOJA = FORN.A2_LOJA
		WHERE
			SF1010.D_E_L_E_T_<>'*'
	) AS NF_ENT_CABE ON NF_ENT_CABE."DOC PARA"=SD2010.D2_DOC AND NF_ENT_CABE."SERIE PN"=SD2010.D2_SERIE AND NF_ENT_CABE."CNPJ FORNECEDOR"=SA1010.A1_CGC
	--LINK COM O CORPO DA NF ENTRADA
	LEFT JOIN PROTHEUS.dbo.SD1010 SD1010 ON SD1010.D1_DOC=SD2010.D2_DOC AND SD1010.D1_SERIE=SD2010.D2_SERIE AND RIGHT(SD1010.D1_ITEM,2)=SD2010.D2_ITEM AND NF_ENT_CABE.FORNECEDOR=SD1010.D1_FORNECE AND NF_ENT_CABE.[LOJA FORNECEDOR]=SD1010.D1_LOJA AND SD1010.D_E_L_E_T_<>'*'
WHERE
  (SD2010.D_E_L_E_T_<>'*') AND --DESCONSIDERA DELETADOS
  (SD2010.D2_FILIAL<>'01') AND --DESCONSIDERA FATURAMENTO NA FILIAL 01
  (SD2010.D2_EMISSAO>=@dateFrom) AND (SD2010.D2_EMISSAO<=@dateTo) AND --FIXA PERÍODO
  (SD2010.D2_ESTOQUE = 'S') --CONSIDERA APENAS PV'S QUE ATUALIZAM ESTOQUE


UNION ALL

  
/* -- TRANSFERÊNCIA EXTERNA - ENTRADA */
SELECT
	--DADOS DE FILIAL E ARMAZÉM
	SD2010.D2_FILIAL+SD2010.D2_LOCAL AS 'ORIGEM',
	SC5010.C5_FILDEST+SC5010.C5_LOCDEST AS 'DESTINO',
	SC5010.C5_FILIAL+SC6010.C6_LOCAL +'->'+ SD1010.D1_FILIAL+SD1010.D1_LOCAL AS 'DE->PARA',
	RTRIM(SD2010.D2_DOC) AS 'DOCUMENTO',
	'SD2/SD1 NF REMESSA' AS 'TP DOC',
	RTRIM(SD2010.D2_COD) AS 'PRODUTO',
	RTRIM(SB1010.B1_DESC) AS 'DESCRIÇÃO',
	SD2010.D2_UM AS 'UND',
	CASE WHEN SD2010.D2_TIPO = 'D' THEN SD2010.D2_QUANT*-1 ELSE SD2010.D2_QUANT END AS 'QTDE',
	SD2010.D2_PRCVEN AS 'VAL UND', --O PREÇO UTILIZADO É O PREÇO DE VENDA
	CASE WHEN SD2010.D2_TIPO = 'D' THEN SD2010.D2_TOTAL*-1 ELSE SD2010.D2_TOTAL END AS 'VAL TOTAL',
	RTRIM(SBM010.BM_DESC) AS 'DESCRIÇÃO GRUPO',
	RTRIM(SC5010.C5_USUINL) AS 'SOLICITANTE TRANSFERÊNCIA',
	Case RTrim(Coalesce(SD2010.D2_EMISSAO,'')) WHEN ''  THEN Null ELSE convert(datetime,SD2010.D2_EMISSAO, 112)END AS 'DT SOLICITADO',
	Case RTrim(Coalesce(NF_ENT_CABE.[DT DIGITAÇÃO],'')) WHEN ''  THEN Null ELSE convert(datetime,NF_ENT_CABE.[DT DIGITAÇÃO], 112)END AS 'DT REALIZADO',
	DATEDIFF(DAY,SD2010.D2_EMISSAO, NF_ENT_CABE.[DT DIGITAÇÃO]) AS 'TEMPO DECORRIDO',

	--OBSERVAÇÃO
	'TS/TE:'+SD2010.D2_TES+'/'+SD1010.D1_TES+' | '+
	'PV:'+SD2010.D2_PEDIDO+' | '+
	'OBS:'+RTRIM(SC5010.C5_MENNOTA)+' | '+
	'FOR:'+CASE WHEN SD2010.D2_TIPO = 'D' THEN RTRIM(SA2010.A2_CGC) ELSE RTRIM(SA1010.A1_CGC) END+'-'+CASE WHEN SD2010.D2_TIPO = 'D' THEN RTRIM(SA2010.A2_NREDUZ) ELSE RTRIM(SA1010.A1_NREDUZ) END +' | '+
	'STK/PN:'+SD2010.D2_ESTOQUE+'/'+SC5010.C5_PRENF+' | '+
	'SIT:'+CASE WHEN SD1010.D1_TES = '   ' THEN 'Ñ.CLA' ELSE 'CLA' END AS 'OBSERVAÇÃO',

	'2' AS 'ROUTE ORDER',
	SD1010.D1_FILIAL+SD1010.D1_LOCAL AS 'ROUTE LOCATION',
	'EXTERNA' AS 'TRANSFERÊNCIA'
FROM PROTHEUS.dbo.SD2010 SD2010
	LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SB1010.B1_COD=SD2010.D2_COD AND SB1010.D_E_L_E_T_<>'*' -- LINK DESCRIÇÃO PRODUTO
	LEFT JOIN PROTHEUS.dbo.SA1010 SA1010 ON SA1010.A1_COD=SD2010.D2_CLIENTE AND SA1010.A1_LOJA=SD2010.D2_LOJA AND SA1010.D_E_L_E_T_<>'*' --TABELA DE CLIENTES (SAÍDA: P NF'S DE TRANSFERÊNCIA)
	LEFT JOIN PROTHEUS.dbo.SA2010 SA2010 ON SA2010.A2_COD=SD2010.D2_CLIENTE AND SA2010.A2_COD=SD2010.D2_LOJA AND SA2010.D_E_L_E_T_<>'*' --TABELA DE FORNECEDORES (ENTRADA: P/ NF'S DE DEVOLUÇÃO)
	LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SB1010.B1_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_<>'*' --LINK DE GRUPO DE PRODUTO
	--LINK COM O CABEÇALHO DO PV
	LEFT JOIN PROTHEUS.dbo.SC5010 SC5010 ON SC5010.C5_NUM=SD2010.D2_PEDIDO AND SD2010.D2_FILIAL=SC5010.C5_FILIAL AND SC5010.D_E_L_E_T_<>'*'
	--LINK COM CORPO DO PV
	LEFT JOIN PROTHEUS.dbo.SC6010 SC6010 ON SC6010.C6_FILIAL=SD2010.D2_FILIAL AND SC6010.C6_LOCAL = SD2010.D2_LOCAL AND SD2010.D2_PEDIDO = SC6010.C6_NUM AND SD2010.D2_ITEMPV = SC6010.C6_ITEM AND SC6010.D_E_L_E_T_<>'*'
	--LINK COM O CABEÇALHO DA NF SAÍDA
	LEFT JOIN PROTHEUS.dbo.SF2010 SF2010 ON SF2010.F2_DOC=SD2010.D2_DOC AND SF2010.F2_SERIE=SD2010.D2_SERIE AND SF2010.F2_CLIENTE=SD2010.D2_CLIENTE AND SF2010.F2_LOJA=SD2010.D2_LOJA AND SF2010.D_E_L_E_T_<>'*'
	--LINK COM O CABEÇALHO DA NF ENTRADA
	LEFT JOIN (
		SELECT
			SF1010.F1_FILIAL AS 'FILIAL PARA',
			SF1010.F1_DOC AS 'DOC PARA',
			SF1010.F1_SERIE AS 'SERIE PN',
			FORN.A2_COD 'FORNECEDOR',
			FORN.A2_LOJA AS 'LOJA FORNECEDOR',
			FORN.A2_CGC AS 'CNPJ FORNECEDOR',
			SF1010.F1_NMCLASS 'USER CLASSIFICAÇÃO', --USUÁRIO CLASSIFICOU
			Case RTrim(Coalesce(SF1010.F1_DTDIGIT,'')) WHEN ''  THEN Null ELSE convert(datetime,SF1010.F1_DTDIGIT, 112)END AS 'DT DIGITAÇÃO', --DT EM QUE OCORREU A CLASSIFICAÇÃO
			Case RTrim(Coalesce(SF1010.F1_DTINCL,'')) WHEN ''  THEN Null ELSE convert(datetime,SF1010.F1_DTINCL, 112)END AS 'DT INCLUSÃO',
			Case RTrim(Coalesce(SF1010.F1_DTLANC,'')) WHEN ''  THEN Null ELSE convert(datetime,SF1010.F1_DTLANC, 112)END AS 'DT CLASSIFICAÇÃO',  --DT DA CONTABILIZAÇÃO
			Case RTrim(Coalesce(SF1010.F1_RECBMTO,'')) WHEN ''  THEN Null ELSE convert(datetime,SF1010.F1_RECBMTO, 112)END AS 'DT RECEBIMENTO', --DT EM QUE O MATERIAL FOI RECEBIDO
			SF1010.F1_NMUSER 'USER INCLUSÃO PN', --USUÁRIO INCLUIU PRENOTA
			SF1010.F1_LOGNF AS 'HISTORICO NF',
			SF1010.F1_OBS AS 'OBS PN', --OBS. PRE-NOTA
			SF1010.F1_MOTRET AS 'MOT REJEIÇÃO', --MOT. RETORNO
			SF1010.F1_OBSCLA AS 'OBS CLASSIFICAÇÃO', --OBS. CLASSIF
			SF1010.F1_ESPECIE AS 'ESPECIE DOC PN' --ESPEC. DOC
		FROM PROTHEUS.dbo.SF1010 SF1010
			LEFT JOIN PROTHEUS.dbo.SA2010 FORN ON SF1010.F1_FORNECE = FORN.A2_COD AND SF1010.F1_LOJA = FORN.A2_LOJA
		WHERE
			SF1010.D_E_L_E_T_<>'*'
	) AS NF_ENT_CABE ON NF_ENT_CABE."DOC PARA"=SD2010.D2_DOC AND NF_ENT_CABE."SERIE PN"=SD2010.D2_SERIE AND NF_ENT_CABE."CNPJ FORNECEDOR"=SA1010.A1_CGC
	--LINK COM O CORPO DA NF ENTRADA
	LEFT JOIN PROTHEUS.dbo.SD1010 SD1010 ON SD1010.D1_DOC=SD2010.D2_DOC AND SD1010.D1_SERIE=SD2010.D2_SERIE AND RIGHT(SD1010.D1_ITEM,2)=SD2010.D2_ITEM AND NF_ENT_CABE.FORNECEDOR=SD1010.D1_FORNECE AND NF_ENT_CABE.[LOJA FORNECEDOR]=SD1010.D1_LOJA AND SD1010.D_E_L_E_T_<>'*'
WHERE
	(SD2010.D_E_L_E_T_<>'*') AND --DESCONSIDERA DELETADOS
	(SD2010.D2_FILIAL<>'01') AND --DESCONSIDERA FATURAMENTO NA FILIAL 01
	(SD2010.D2_EMISSAO>=@dateFrom) AND (SD2010.D2_EMISSAO<=@dateTo) AND --FIXA PERÍODO
	(SD2010.D2_ESTOQUE = 'S') --CONSIDERA APENAS PV'S QUE ATUALIZAM ESTOQUE