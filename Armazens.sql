SELECT 
	Z01010.Z01_CODGER+' - '+Z01010.Z01_DESC AS DESCRICAO_ARMAZEM,
	CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END AS SITUACAO,
	CASE WHEN Z01010.Z01_TME = '001' THEN 'ENDICON - MATERIAIS NOVOS' WHEN Z01010.Z01_TME = '002' THEN 'CLIENTE' WHEN Z01010.Z01_TME = '005' THEN 'ATIVO' WHEN Z01010.Z01_TME = '006' THEN 'ENDICON - MATERIAIS USADOS' ELSE 'ERRO' END AS 'TIPO',
	CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END AS 'INVENTARIADO?',
	CASE WHEN Z01010.Z01_OBRA = 'N' THEN 'Não' WHEN Z01010.Z01_OBRA = 'S' THEN 'Sim' ELSE 'ERRO' END AS 'OBRIGA OBRA?',
	CASE WHEN Z01010.Z01_TIPO = 2 THEN 'Aplicação Direta' WHEN Z01010.Z01_TIPO = 1 THEN 'Estoque'  ELSE 'ERRO' END AS 'TIPO DE ARMAZÉM'
	
	/* --SC APROVADAS PARA O ARMAZÉM
	(
		SELECT
			SUM((SC1010.C1_QUANT-SC1010.C1_QUJE)*SC1010.C1_VLESTIM)
		FROM PROTHEUS.dbo.SC1010 SC1010 
		WHERE
			SC1010.D_E_L_E_T_<>'*' AND
			Z01010.Z01_CODGER=SC1010.C1_FILIAL+SC1010.C1_LOCAL AND
			SC1010.C1_CC = '          ' AND
			SC1010.C1_RESIDUO = ' ' AND
			SC1010.C1_APROV = 'L' AND
			(SC1010.C1_QUANT-SC1010.C1_QUJE)>0 AND
			SC1010.C1_EMISSAO>='20180101' AND SC1010.C1_EMISSAO<='20181231'
	) AS 'SC APROVADA',
	
	--SC EM PROCESSO DE APROVAÇÃO PARA O ARMAZÉM
	(
		SELECT
			SUM(SC1010.C1_VTOTAL)
		FROM PROTHEUS.dbo.SC1010 SC1010 
		WHERE
			SC1010.D_E_L_E_T_<>'*' AND
			Z01010.Z01_CODGER=SC1010.C1_FILIAL+SC1010.C1_LOCAL AND
			SC1010.C1_CC = '          ' AND
			SC1010.C1_RESIDUO = ' ' AND
			SC1010.C1_APROV = 'B' AND
			SC1010.C1_EMISSAO>='20180101' AND SC1010.C1_EMISSAO<='20181231'
	) AS 'SC BLOQUEADA',
	
	--SC REJEITADA PARA O ARMAZÉM
	(
		SELECT
			SUM(SC1010.C1_VTOTAL)
		FROM PROTHEUS.dbo.SC1010 SC1010 
		WHERE
			SC1010.D_E_L_E_T_<>'*' AND
			Z01010.Z01_CODGER=SC1010.C1_FILIAL+SC1010.C1_LOCAL AND
			SC1010.C1_CC = '          ' AND
			SC1010.C1_RESIDUO = ' ' AND
			SC1010.C1_APROV = 'R' AND
			SC1010.C1_EMISSAO>='20180101' AND SC1010.C1_EMISSAO<='20181231'
	) AS 'SC REJEITADA',
	
	--SC ELIMINADA POR RESÍDUO
	(
		SELECT
			SUM(SC1010.C1_VTOTAL)
		FROM PROTHEUS.dbo.SC1010 SC1010 
		WHERE
			SC1010.D_E_L_E_T_<>'*' AND
			Z01010.Z01_CODGER=SC1010.C1_FILIAL+SC1010.C1_LOCAL AND
			SC1010.C1_CC = '          ' AND
			SC1010.C1_RESIDUO <> ' ' AND
			SC1010.C1_EMISSAO>='20180101' AND SC1010.C1_EMISSAO<='20181231'
	) AS 'SC RESIDUO',
	
	-- COMPRAS APROVADAS
	(
		SELECT
			SUM((SC7010.C7_QUANT-(SC7010.C7_QUJE+SC7010.C7_QTDACLA))*SC7010.C7_PRECO)
		FROM PROTHEUS.dbo.SC7010 SC7010
		WHERE
			(SC7010.D_E_L_E_T_<>'*') AND 
			SC7010.C7_FILIAL+SC7010.C7_LOCAL=Z01010.Z01_CODGER AND
			(SC7010.C7_CC = '         ') AND
			(SC7010.C7_RESIDUO=' ') AND
			(SC7010.C7_CONAPRO = 'L') AND
			(SC7010.C7_EMISSAO>='20180101') AND (SC7010.C7_EMISSAO<='20181231')
	) AS 'PC APROVADO',
	
	-- COMPRAS BLOQUEADAS
	(
		SELECT
			SUM(SC7010.C7_TOTAL)
		FROM PROTHEUS.dbo.SC7010 SC7010
		WHERE
			(SC7010.D_E_L_E_T_<>'*') AND 
			SC7010.C7_FILIAL+SC7010.C7_LOCAL=Z01010.Z01_CODGER AND
			(SC7010.C7_CC = '         ') AND
			(SC7010.C7_RESIDUO=' ') AND
			(SC7010.C7_CONAPRO = 'B') AND
			(SC7010.C7_EMISSAO>='20180101') AND (SC7010.C7_EMISSAO<='20181231')
	) AS 'PC BLOQUEADO',
	
		-- COMPRAS ELIMINADAS POR RESIDUO
	(
		SELECT
			SUM(SC7010.C7_TOTAL)
		FROM PROTHEUS.dbo.SC7010 SC7010
		WHERE
			(SC7010.D_E_L_E_T_<>'*') AND 
			SC7010.C7_FILIAL+SC7010.C7_LOCAL=Z01010.Z01_CODGER AND
			(SC7010.C7_CC = '         ') AND
			(SC7010.C7_RESIDUO<>' ') AND
			(SC7010.C7_EMISSAO>='20180101') AND (SC7010.C7_EMISSAO<='20181231')
	) AS 'PC BLOQUEADO',
	
	-- PRE NOTAS CLASSIFICADAS
	(
		SELECT
			SUM(SD1010.D1_TOTAL)
		FROM PROTHEUS.dbo.SD1010 SD1010
			LEFT JOIN PROTHEUS.dbo.SF1010 SF1010 ON SD1010.D1_DOC=SF1010.F1_DOC AND SD1010.D1_SERIE=SF1010.F1_SERIE AND SD1010.D1_FORNECE=SF1010.F1_FORNECE AND SD1010.D1_LOJA=SF1010.F1_LOJA
			LEFT JOIN PROTHEUS.dbo.SF4010 SF4010 ON SF4010.F4_CODIGO=SD1010.D1_TES
			LEFT JOIN PROTHEUS.dbo.SA2010 SA2010 ON  SA2010.A2_COD=SD1010.D1_FORNECE
		WHERE
			(SD1010.D_E_L_E_T_<>'*') AND
			(SD1010.D1_FILIAL+SD1010.D1_LOCAL=Z01010.Z01_CODGER) AND
			(LEFT(SA2010.A2_CGC,8)<>'05061494') AND
			((SF1010.F1_DTDIGIT>='20180101' AND SF1010.F1_DTDIGIT<='20181231') AND ((SF4010.F4_ESTOQUE='S') OR (SF4010.F4_CODIGO='103' OR SF4010.F4_CODIGO='140'))) 
	) AS 'PN CLASSI',
	
	-- PRE NOTAS PENDENTE DE CLASSIFICACAO 
	(
		SELECT
			SUM(SD1010.D1_TOTAL )
		FROM PROTHEUS.dbo.SD1010 SD1010
			LEFT JOIN PROTHEUS.dbo.SF1010 SF1010 ON SD1010.D1_DOC=SF1010.F1_DOC AND SD1010.D1_SERIE=SF1010.F1_SERIE AND SD1010.D1_FORNECE=SF1010.F1_FORNECE AND SD1010.D1_LOJA=SF1010.F1_LOJA
			LEFT JOIN PROTHEUS.dbo.SF4010 SF4010 ON SF4010.F4_CODIGO=SD1010.D1_TES
			LEFT JOIN PROTHEUS.dbo.SA2010 SA2010 ON  SA2010.A2_COD=SD1010.D1_FORNECE
		WHERE
			(SD1010.D_E_L_E_T_<>'*') AND
			SD1010.D1_FILIAL+SD1010.D1_LOCAL=Z01010.Z01_CODGER AND
			(LEFT(SA2010.A2_CGC,8)<>'05061494') AND
			((SF1010.F1_DTDIGIT>='20180101' AND SF1010.F1_DTDIGIT<='20181231') AND (SD1010.D1_CC='          ' AND SD1010.D1_TES='   '))
	) AS 'PN NAO CLASSI',

	-- TRANF EXT ENTRADA CLASSIFICADA 
	(
		SELECT
			SUM(SD1010.D1_TOTAL )
		FROM PROTHEUS.dbo.SD1010 SD1010
			LEFT JOIN PROTHEUS.dbo.SF1010 SF1010 ON SD1010.D1_DOC=SF1010.F1_DOC AND SD1010.D1_SERIE=SF1010.F1_SERIE AND SD1010.D1_FORNECE=SF1010.F1_FORNECE AND SD1010.D1_LOJA=SF1010.F1_LOJA
			LEFT JOIN PROTHEUS.dbo.SF4010 SF4010 ON SF4010.F4_CODIGO=SD1010.D1_TES
			LEFT JOIN PROTHEUS.dbo.SA2010 SA2010 ON  SA2010.A2_COD=SD1010.D1_FORNECE
		WHERE
			(SD1010.D_E_L_E_T_<>'*') AND
			SD1010.D1_FILIAL+SD1010.D1_LOCAL=Z01010.Z01_CODGER AND
			(LEFT(SA2010.A2_CGC,8)='05061494') AND
			((SF1010.F1_DTDIGIT>='20180101' AND SF1010.F1_DTDIGIT<='20181231') AND ((SF4010.F4_ESTOQUE='S') OR (SF4010.F4_CODIGO='103' OR SF4010.F4_CODIGO='140'))) 
	) AS 'TRANSF EXT - ENTRADA - CLASSI',
	
		-- PRE NOTAS PENDENTE DE CLASSIFICACAO 
	(
		SELECT
			SUM(SD1010.D1_TOTAL )
		FROM PROTHEUS.dbo.SD1010 SD1010
			LEFT JOIN PROTHEUS.dbo.SF1010 SF1010 ON SD1010.D1_DOC=SF1010.F1_DOC AND SD1010.D1_SERIE=SF1010.F1_SERIE AND SD1010.D1_FORNECE=SF1010.F1_FORNECE AND SD1010.D1_LOJA=SF1010.F1_LOJA
			LEFT JOIN PROTHEUS.dbo.SF4010 SF4010 ON SF4010.F4_CODIGO=SD1010.D1_TES
			LEFT JOIN PROTHEUS.dbo.SA2010 SA2010 ON  SA2010.A2_COD=SD1010.D1_FORNECE
		WHERE
			(SD1010.D_E_L_E_T_<>'*') AND
			SD1010.D1_FILIAL+SD1010.D1_LOCAL=Z01010.Z01_CODGER AND
			(LEFT(SA2010.A2_CGC,8)='05061494') AND
			((SF1010.F1_DTDIGIT>='20180101' AND SF1010.F1_DTDIGIT<='20181231') AND (SD1010.D1_CC='          ' AND SD1010.D1_TES='   '))
	) AS 'TRANSF EXT - ENTRADA - NÃO CLASSI',
	
	--TRANSFERÊNCIAS INTERNAS - ENTRADA
	(
		SELECT
			SUM(SB1010.B1_UPRC*SD3010.D3_QUANT)
		FROM PROTHEUS.dbo.SD3010 SD3010 
			LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SD3010.D3_COD=SB1010.B1_COD AND SB1010.D_E_L_E_T_ <> '*'
		WHERE
			(SD3010.D_E_L_E_T_<>'*') AND 
			(SD3010.D3_FILIAL+SD3010.D3_LOCAL=Z01010.Z01_CODGER) AND
			(SD3010.D3_ESTORNO='') AND 
			(SD3010.D3_DOC NOT LIKE '%INVENT%') AND 
			(SD3010.D3_TM='499') AND 
			((SD3010.D3_EMISSAO>='20180101') AND (SD3010.D3_EMISSAO<='20181231'))
	) AS 'TRANSF INT - ENTRADA',
		
	--TRANSFERÊNCIAS INTERNAS - SAÍDA
	(
		SELECT
			SUM(SB1010.B1_UPRC*SD3010.D3_QUANT)
		FROM PROTHEUS.dbo.SD3010 SD3010 
			LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SD3010.D3_COD=SB1010.B1_COD AND SB1010.D_E_L_E_T_ <> '*'
		WHERE
			(SD3010.D_E_L_E_T_<>'*') AND 
			(SD3010.D3_FILIAL+SD3010.D3_LOCAL=Z01010.Z01_CODGER) AND
			(SD3010.D3_ESTORNO='') AND 
			(SD3010.D3_DOC NOT LIKE '%INVENT%') AND 
			(SD3010.D3_TM='999') AND 
			((SD3010.D3_EMISSAO>='20180101') AND (SD3010.D3_EMISSAO<='20181231'))
	) AS 'TRANSF INT - SAÍDA',
	
		--TRANSFERÊNCIAS EXTERNAS - SAÍDA
	(
		SELECT
			SUM(DBP.TRANSF) AS TRANSFER_EXT
		FROM 
			(SELECT 
				CASE WHEN (SF4010.F4_CF = '5556' OR SF4010.F4_CF = '6556') THEN SUM(SC6010.C6_QTDENT*SC6010.C6_PRCVEN*-1) ELSE SUM(SC6010.C6_QTDENT*SC6010.C6_PRCVEN) END AS TRANSF
			FROM PROTHEUS.dbo.SC6010 SC6010 
				LEFT JOIN PROTHEUS.dbo.SC5010 SC5010 ON SC5010.C5_NUM=SC6010.C6_NUM AND SC6010.C6_FILIAL=SC5010.C5_FILIAL AND SC5010.D_E_L_E_T_ <> '*' 
				LEFT JOIN PROTHEUS.dbo.SF4010 SF4010 ON SF4010.F4_CODIGO=SC6010.C6_TES AND SF4010.D_E_L_E_T_ <> '*' 
			WHERE
				SC6010.D_E_L_E_T_ <> '*' AND
				SC6010.C6_FILIAL+SC6010.C6_LOCAL=Z01010.Z01_CODGER AND
				SC6010.C6_NOTA<>'         ' AND
				SF4010.F4_ESTOQUE='S' AND
				(SC6010.C6_DATFAT>='20180101' AND SC6010.C6_DATFAT<='20181231')
			GROUP BY
				SF4010.F4_CF) AS DBP
	) AS 'TRANSF EXT - SAÍDA',
	
	--SAs Bloqueadas
	(
		SELECT
			SUM(SB1010.B1_UPRC*SCP010.CP_QUANT) AS 'VAL TOTAL ULT. PREC. COMPRA'
		FROM PROTHEUS.dbo.SCP010 SCP010 
			LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SCP010.CP_PRODUTO=SB1010.B1_COD AND SB1010.D_E_L_E_T_ <> '*'
		WHERE
			SCP010.D_E_L_E_T_<>'*' AND
			SCP010.CP_FILIAL+SCP010.CP_LOCAL=Z01010.Z01_CODGER AND
			SCP010.CP_PREREQU=' ' AND
			SCP010.CP_QUJE='0' AND
			SCP010.CP_STATUS=' ' AND
			SCP010.CP_STATSA='B' AND
			(SCP010.CP_EMISSAO>='20180101' AND SCP010.CP_EMISSAO<='20181231')
	) AS 'SAs BLOQUEADAS',

	--SAs Aprovadas
	(
		SELECT
			SUM(SB1010.B1_UPRC*SCP010.CP_QUANT) AS 'VAL TOTAL ULT. PREC. COMPRA'
		FROM PROTHEUS.dbo.SCP010 SCP010 
			LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SCP010.CP_PRODUTO=SB1010.B1_COD AND SB1010.D_E_L_E_T_ <> '*'
		WHERE
			SCP010.D_E_L_E_T_<>'*' AND
			SCP010.CP_FILIAL+SCP010.CP_LOCAL=Z01010.Z01_CODGER AND
			SCP010.CP_PREREQU=' ' AND
			SCP010.CP_QUJE='0' AND
			SCP010.CP_STATUS=' ' AND
			SCP010.CP_STATSA='L' AND
			(SCP010.CP_EMISSAO>='20180101' AND SCP010.CP_EMISSAO<='20181231')
	) AS 'SAs APROVADAS',	
	
	--SAs em pré-requisição
	(
		SELECT
			SUM(SB1010.B1_UPRC*SCP010.CP_QUANT) AS 'VAL TOTAL ULT. PREC. COMPRA'
		FROM PROTHEUS.dbo.SCP010 SCP010 
			LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SCP010.CP_PRODUTO=SB1010.B1_COD AND SB1010.D_E_L_E_T_ <> '*'
		WHERE
			SCP010.D_E_L_E_T_<>'*' AND
			SCP010.CP_FILIAL+SCP010.CP_LOCAL=Z01010.Z01_CODGER AND
			SCP010.CP_PREREQU='S' AND
			SCP010.CP_QUJE='0' AND
			SCP010.CP_STATUS=' ' AND
			SCP010.CP_STATSA='L' AND
			(SCP010.CP_EMISSAO>='20180101' AND SCP010.CP_EMISSAO<='20181231')
	) AS 'SAs PRE REQUISICAO',	
	
	--SAs baixadas
	(
		SELECT
			SUM(SB1010.B1_UPRC*SCP010.CP_QUJE) AS 'VAL TOTAL ULT. PREC. COMPRA'
		FROM PROTHEUS.dbo.SCP010 SCP010 
			LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SCP010.CP_PRODUTO=SB1010.B1_COD AND SB1010.D_E_L_E_T_ <> '*'
		WHERE
			SCP010.D_E_L_E_T_<>'*' AND
			SCP010.CP_FILIAL+SCP010.CP_LOCAL=Z01010.Z01_CODGER AND
			SCP010.CP_PREREQU='S' AND
			SCP010.CP_QUJE>'0' AND
			SCP010.CP_STATUS='E' AND
			SCP010.CP_STATSA='L' AND
			(SCP010.CP_EMISSAO>='20180101' AND SCP010.CP_EMISSAO<='20181231')
	) AS 'SAs BAIXADAS' */

FROM PROTHEUS.dbo.Z01010 Z01010
WHERE
	(Z01010.D_E_L_E_T_<>'*') AND
	Z01010.Z01_MSBLQL = 2 AND
	Z01010.Z01_TME = '001' AND
	(
		Z01010.Z01_CODGER IN ('1395','1396','1397')
	)
	