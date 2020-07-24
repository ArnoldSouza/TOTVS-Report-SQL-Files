alter VIEW VW_PRTGER
AS
--#######		TITULOS ATRAVES DE NFE QUE SOFRERAM FATURA #########
SELECT CCUSTO AS GERCCCOD,
	NATUREZA AS GERNATCOD,
	PREFIXO AS GERPREF,
	NUMERO AS GERNUM,
	TIPO AS GERTIPO,
	COD_FORNECEDOR AS GERCODFR,
	LOJA AS GERLOJ,
	NOMEFOR AS GERFORNOM,
	DT_EMISSAO AS GERDTEMS,
	VENCTO_REAL AS GERDTVCT,
	DT_BAIXA AS GERDTBX,
	ANO_BAIXA AS GERANO,
	MES_BAIXA AS GERMES,
	HISTORICO AS GERHIST,
	VALOR_ORIGINAL AS GERVLRORG,
	VALOR_PAGO AS GERVLRPG,
	ITEM_CTA AS GERITCT,
	CLASSE_VALOR AS GERCLVL,
	ORIGEM AS GERORIG,
	INFORMACOES_COMPL AS GERINFCP,
	RECNO AS R_E_C_N_O_,
	D1_PEDIDO AS GERNUMPC,
	C1_NUM AS GERNUMSC,
	CHAVE AS GERCHAVE,
	CHAVE2 AS GERCHAVEORIG,
	PARCELA AS GERPARCEL,
	'N' AS GERDELET,
	'N' AS GERALTER,
	'N' AS GERDIF,
	'' AS GEROBS,
	'' AS GERREF
FROM (
	SELECT (
		CASE 
			WHEN TB_GER02.D1_CC = ''
				AND TB_GER02.C7_CC <> ''
				THEN TB_GER02.C7_CC
			WHEN TB_GER02.D1_CC = ''
				AND TB_GER02.C7_CC = ''
				THEN TB_GER02.C1_CC
			ELSE TB_GER02.D1_CC
			END
		) AS CCUSTO,
	TB_GER02.SE5FAT_NATUREZ AS NATUREZA,
	TB_GER02.SE5FAT_PREFIXO AS PREFIXO,
	TB_GER02.SE5FAT_NUMERO AS NUMERO,
	TB_GER02.SE5FAT_PARCELA AS PARCELA,
	TB_GER02.SE5FAT_TIPO AS TIPO,
	TB_GER02.SE5FAT_CLIFOR AS COD_FORNECEDOR,
	TB_GER02.SE5FAT_LOJA AS LOJA,
	TB_GER02.A2_NOME AS NOMEFOR,
	TB_GER02.SE2FAT_EMISSAO AS DT_EMISSAO,
	TB_GER02.SE2FAT_VENCREA AS VENCTO_REAL,
	TB_GER02.SE5FAT_DATA AS DT_BAIXA,
	YEAR(TB_GER02.SE5FAT_DATA) AS ANO_BAIXA,
	MONTH(TB_GER02.SE5FAT_DATA) AS MES_BAIXA,
	TB_GER02.E2_HIST AS HISTORICO,
	TB_GER02.E2_INFCOMP AS INFORMACOES_COMPL,
	/*TB_GER02.SE2FAT_VALOR * (TB_GER02.D1_TOTAL/TB_GER02.F1_VALBRUT) AS VALOR_ORIGINAL,
	TB_GER02.SE5FAT_VALOR * (TB_GER02.D1_TOTAL/TB_GER02.F1_VALBRUT) AS VALOR_PAGO,*/
	TB_GER02.SE2FAT_VALOR * (TB_GER02.D1_TOTAL/ 
	(SELECT sUM(E2_VALOR) FROM SE2010 SE2VALOR WHERE SE2VALOR.E2_FILIAL=TB_GER02.SE5FAT_FILIAL AND  
	SE2VALOR.E2_PREFIXO=TB_GER02.SE5FAT_PREFIXO AND
	SE2VALOR.E2_NUM=TB_GER02.SE5FAT_NUMERO AND
	SE2VALOR.E2_TIPO=TB_GER02.SE5FAT_TIPO AND
	--SE2VALOR.E2_PARCELA=TB_GER02.E5_PARCELA AND
	SE2VALOR.E2_FORNECE=TB_GER02.SE5FAT_CLIFOR AND
	SE2VALOR.E2_LOJA=TB_GER02.SE5FAT_LOJA AND
	SE2VALOR.D_E_L_E_T_=''
	) 
	) AS VALOR_ORIGINAL,
	TB_GER02.SE5FAT_VALOR * (TB_GER02.D1_TOTAL/
	(SELECT sUM(E2_VALOR) FROM SE2010 SE2VALOR WHERE SE2VALOR.E2_FILIAL=TB_GER02.SE5FAT_FILIAL AND  
	SE2VALOR.E2_PREFIXO=TB_GER02.SE5FAT_PREFIXO AND
	SE2VALOR.E2_NUM=TB_GER02.SE5FAT_NUMERO AND
	SE2VALOR.E2_TIPO=TB_GER02.SE5FAT_TIPO AND
	--SE2VALOR.E2_PARCELA=TB_GER02.E5_PARCELA AND
	SE2VALOR.E2_FORNECE=TB_GER02.SE5FAT_CLIFOR AND
	SE2VALOR.E2_LOJA=TB_GER02.SE5FAT_LOJA AND
	SE2VALOR.D_E_L_E_T_=''
	) 
	) AS VALOR_PAGO,
	TB_GER02.D1_ITEMCTA AS ITEM_CTA,
	(
		CASE 
			WHEN TB_GER02.D1_CLVL = ''
				AND TB_GER02.C7_CLVL <> ''
				THEN TB_GER02.C7_CLVL
			WHEN TB_GER02.D1_CLVL = ''
				AND TB_GER02.C7_CLVL = ''
				THEN TB_GER02.C1_CLVL
			ELSE TB_GER02.D1_CLVL
			END
		) AS CLASSE_VALOR,
		ORIGEM='COMPRAS',
		(
		CASE 
			WHEN TB_GER02.SC7_RECNO IS NULL
				THEN 0
			ELSE TB_GER02.SC7_RECNO
			END
		) + (
		CASE 
			WHEN TB_GER02.SC1_RECNO IS NULL
				THEN 0
			ELSE TB_GER02.SC1_RECNO
			END
		) + (
		CASE 
			WHEN TB_GER02.SE2_RECNO IS NULL
				THEN 0
			ELSE TB_GER02.SE2_RECNO
			END
		) + (
		CASE 
			WHEN TB_GER02.SD1_RECNO IS NULL
				THEN 0
			ELSE TB_GER02.SD1_RECNO
			END
		) + (
		CASE 
			WHEN TB_GER02.SE5_RECNO IS NULL
				THEN 0
			ELSE TB_GER02.SE5_RECNO
			END
		) + (
		CASE 
			WHEN TB_GER02.SF1_RECNO IS NULL
				THEN 0
			ELSE TB_GER02.SF1_RECNO
			END
		) + (
		CASE 
			WHEN TB_GER02.SE5FAT_RECNO IS NULL
				THEN 0
			ELSE TB_GER02.SE5FAT_RECNO
			END
		) + (
		CASE 
			WHEN TB_GER02.SE2FAT_RECNO IS NULL
				THEN 0
			ELSE TB_GER02.SE2FAT_RECNO
			END
		) + (
		CASE 
			WHEN TB_GER02.SA2_RECNO IS NULL
				THEN 0
			ELSE TB_GER02.SA2_RECNO
			END
		) + convert(INT, TB_GER02.SE5FAT_DATA) AS RECNO,
	TB_GER02.C7_NUM AS D1_PEDIDO,
	TB_GER02.C1_NUM,
	CHAVE = TB_GER02.SE5FAT_FILIAL + '-' + TB_GER02.SE5FAT_PREFIXO + '-' + TB_GER02.SE5FAT_NUMERO + '-' + TB_GER02.SE5FAT_PARCELA + '-' + TB_GER02.SE5FAT_TIPO,
	CHAVE2 = TB_GER02.E5_FILIAL + '-' + TB_GER02.E5_PREFIXO + '-' + TB_GER02.E5_NUMERO + '-' + TB_GER02.E5_PARCELA + '-' + TB_GER02.E5_TIPO /*+ '-' +TB_GER02.D1_ITEM*/,
	REF = 'COMPRAS-FATURA'
FROM (
	SELECT TB_GER01.E5_FILORIG,
		TB_GER01.E5_FILIAL,
		TB_GER01.E5_PREFIXO,
		TB_GER01.E5_NUMERO,
		TB_GER01.E5_PARCELA,
		TB_GER01.E5_TIPO,
		TB_GER01.E5_VALOR,
		TB_GER01.E5_CLIFOR,
		TB_GER01.E5_LOJA,
		TB_GER01.E2_EMISSAO,
		TB_GER01.E2_VALOR,
		TB_GER01.E2_INFCOMP,
		TB_GER01.E2_HIST,
		TB_GER01.E2_FATURA,
		TB_GER01.E2_FATFOR,
		TB_GER01.E2_FATPREF,
		TB_GER01.E2_FATLOJ,
		TB_GER01.E2_TIPOFAT,
		TB_GER01.D1_TOTAL,
		TB_GER01.D1_VALDESC,
		SE5FAT.E5_DATA AS SE5FAT_DATA,
		SE5FAT.E5_NATUREZ AS SE5FAT_NATUREZ,
		SE5FAT.E5_VALOR AS SE5FAT_VALOR,
		SE2FAT.E2_VALOR AS SE2FAT_VALOR,
		SE2FAT.E2_EMISSAO AS SE2FAT_EMISSAO,
		SE2FAT.E2_VENCREA AS SE2FAT_VENCREA,
		TB_GER01.D1_CC,
		TB_GER01.C7_CC,
		TB_GER01.C1_CC,
		TB_GER01.C7_CLVL,
		TB_GER01.C1_CLVL,
		SA2.A2_NOME,
		TB_GER01.D1_ITEMCTA,
		TB_GER01.D1_CLVL,
		TB_GER01.C7_NUM,
		TB_GER01.C1_NUM,
		TB_GER01.D1_ITEM,
		SE5FAT.E5_FILIAL AS SE5FAT_FILIAL,
		SE5FAT.E5_PREFIXO AS SE5FAT_PREFIXO,
		SE5FAT.E5_NUMERO AS SE5FAT_NUMERO,
		SE5FAT.E5_PARCELA AS SE5FAT_PARCELA ,
		SE5FAT.E5_CLIFOR AS SE5FAT_CLIFOR,
		SE5FAT.E5_LOJA AS SE5FAT_LOJA,
		SE5FAT.E5_FILORIG AS SE5FAT_FILORIG,
		SE5FAT.E5_TIPO AS SE5FAT_TIPO,
		TB_GER01.F1_VALBRUT,
		TB_GER01.SD1_RECNO,
		TB_GER01.SC7_RECNO,
		TB_GER01.SC1_RECNO,
		TB_GER01.SE2_RECNO,
		TB_GER01.SE5_RECNO,
		TB_GER01.SF1_RECNO,
		SE5FAT.R_E_C_N_O_ AS SE5FAT_RECNO,
		SE2FAT.R_E_C_N_O_ AS SE2FAT_RECNO,
		SA2.R_E_C_N_O_ AS SA2_RECNO
	FROM (
		SELECT SE5.E5_FILORIG,
			SE5.E5_FILIAL,
			SE5.E5_PREFIXO,
			SE5.E5_NUMERO,
			SE5.E5_PARCELA,
			SE5.E5_TIPO,
			SE5.E5_VALOR,
			SE5.E5_CLIFOR,
			SE5.E5_LOJA,
			SE2.E2_EMISSAO,
			SE2.E2_VALOR,
			SE2.E2_INFCOMP,
			SE2.E2_HIST,
			SE2.E2_FATURA,
			SE2.E2_FATFOR,
			SE2.E2_FATPREF,
			SE2.E2_FATLOJ,
			SE2.E2_TIPOFAT,
			SD1.D1_TOTAL,
			SD1.D1_CC,
			SD1.D1_ITEMCTA,
			SC7.C7_CC,
			SC1.C1_CC,
			SC7.C7_CLVL,
			SC1.C1_CLVL,
			SD1.D1_CLVL,
			SF1.R_E_C_N_O_ AS SF1_RECNO,
			SD1.R_E_C_N_O_ AS SD1_RECNO,
			SC7.R_E_C_N_O_ AS SC7_RECNO,
			SC1.R_E_C_N_O_ AS SC1_RECNO,
			SE2.R_E_C_N_O_ AS SE2_RECNO,
			SE5.R_E_C_N_O_ AS SE5_RECNO,
			SD1.D1_VALDESC,
			SD1.D1_ITEM,
			SF1.F1_VALBRUT,
			SC7.C7_NUM,
			SC1.C1_NUM
		FROM SF1010 SF1 WITH (NOLOCK)
		INNER JOIN SD1010 SD1 WITH (NOLOCK)
			ON SF1.F1_FILIAL = D1_FILIAL
				AND SF1.F1_SERIE = D1_SERIE
				AND SF1.F1_DOC = D1_DOC
				AND SF1.F1_FORNECE = D1_FORNECE
				AND SF1.F1_LOJA = D1_LOJA
		LEFT JOIN SC7010 SC7 WITH (NOLOCK)
			ON (
					CASE 
						WHEN C7_FILIAL = C7_FILENT
							THEN C7_FILIAL
						ELSE C7_FILENT
						END
					) = SD1.D1_FILIAL
				AND SD1.D1_PEDIDO = SC7.C7_NUM
				AND SD1.D1_ITEMPC = SC7.C7_ITEM
		LEFT JOIN SC1010 SC1 WITH (NOLOCK)
			ON SC1.C1_FILIAL = SC7.C7_FILIAL
				AND C7_NUMSC = C1_NUM
				AND C7_ITEMSC = C1_ITEM
		INNER JOIN SE2010 SE2 WITH (NOLOCK)
			ON SE2.E2_FILORIG = F1_FILIAL
				AND SE2.E2_PREFIXO = SF1.F1_SERIE
				AND SE2.E2_NUM = SF1.F1_DOC
				AND SE2.E2_FORNECE = SF1.F1_FORNECE
				AND SE2.E2_LOJA = SF1.F1_LOJA
		INNER JOIN SE5010 SE5 WITH (NOLOCK)
			ON SE5.E5_FILORIG = SE2.E2_FILORIG
				AND SE5.E5_PREFIXO = SE2.E2_PREFIXO
				AND SE5.E5_NUMERO = SE2.E2_NUM
				AND SE5.E5_PARCELA = SE2.E2_PARCELA
				AND SE5.E5_TIPO = SE2.E2_TIPO
				AND SE5.E5_CLIFOR = SE2.E2_FORNECE
				AND SE5.E5_LOJA = SE2.E2_LOJA
				AND SE5.E5_DATA = SE2.E2_BAIXA
		WHERE SF1.D_E_L_E_T_ = ''
			AND SD1.D_E_L_E_T_ = ''
			AND SE2.D_E_L_E_T_=''
			AND SE5.D_E_L_E_T_ = ''
			AND ISNULL(SC7.D_E_L_E_T_, '') = ''
			AND ISNULL(SC1.D_E_L_E_T_, '') = ''
			AND D1_TES<>''
			AND F1_STATUS='A'
			AND E5_TIPODOC NOT IN ('DC','JR')
		) AS TB_GER01
	INNER JOIN SE2010 SE2FAT WITH (NOLOCK)
		ON SE2FAT.E2_PREFIXO = TB_GER01.E2_FATPREF
			AND SE2FAT.E2_NUM = TB_GER01.E2_FATURA
			AND SE2FAT.E2_FORNECE = TB_GER01.E2_FATFOR
			AND SE2FAT.E2_LOJA = TB_GER01.E2_FATLOJ
			AND SE2FAT.E2_TIPO = TB_GER01.E2_TIPOFAT
	INNER JOIN SE5010 SE5FAT WITH (NOLOCK)
		ON SE5FAT.E5_FILIAL = SE2FAT.E2_FILIAL
			AND SE5FAT.E5_PREFIXO = SE2FAT.E2_PREFIXO
			AND SE5FAT.E5_NUMERO = SE2FAT.E2_NUM
			AND SE5FAT.E5_PARCELA = SE2FAT.E2_PARCELA
			AND SE5FAT.E5_CLIFOR = SE2FAT.E2_FORNECE
			AND SE5FAT.E5_LOJA = SE2FAT.E2_LOJA
			AND SE5FAT.E5_FILORIG = SE2FAT.E2_FILORIG
			AND SE2FAT.E2_BAIXA=SE5FAT.E5_DATA
	INNER JOIN SA2010 SA2 WITH (NOLOCK)
		ON SA2.A2_COD = SE5FAT.E5_CLIFOR
			AND SA2.A2_LOJA = SE5FAT.E5_LOJA
	WHERE
	      SE2FAT.D_E_L_E_T_ = ''
		AND SE5FAT.D_E_L_E_T_ = ''
		AND SA2.D_E_L_E_T_ = '' 
		AND SE5FAT.E5_DTCANBX=''
		AND TB_GER01.E5_PARCELA = 
		(SELECT TOP 1 FI8_PARORI 
		FROM FI8010 FI8 WITH (NOLOCK) 
		WHERE FI8.D_E_L_E_T_='' AND 
		FI8_PRFDES=SE5FAT.E5_PREFIXO AND 
		FI8_NUMDES=SE5FAT.E5_NUMERO AND 
		--FI8_PARDES=SE5FAT.E5_PARCELA AND
		FI8_TIPDES=SE5FAT.E5_TIPO AND 
		FI8_FORDES=SE5FAT.E5_CLIFOR AND
		FI8_LOJDES=SE5FAT.E5_LOJA)
		AND SE5FAT.E5_DTCANBX=''
		AND SE5FAT.E5_TIPODOC IN (
			'VL',
			'CP')
		AND  SE5FAT.E5_MOTBX IN (
			'NOR',
			'DEB',
			'CMP'
			)
	) AS TB_GER02
	
	UNION ALL
	
	--#######		TITULOS ATRAVES DE NFE QUE NÃO SOFRERAM FATURA #########
	SELECT (
			CASE 
				WHEN D1_CC = ''
					AND C7_CC <> ''
					THEN C7_CC
				WHEN D1_CC = ''
					AND C7_CC = ''
					THEN C1_CC
				ELSE D1_CC
				END
			) AS CCUSTO,
		SE5.E5_NATUREZ AS NATUREZA,
		SE5.E5_PREFIXO AS PREFIXO,
		SE5.E5_NUMERO AS NUMERO,
		SE5.E5_PARCELA AS PARCELA,
		SE5.E5_TIPO AS TIPO,
		SE5.E5_CLIFOR AS COD_FORNECEDOR,
		SE5.E5_LOJA AS LOJA,
		SA2.A2_NOME AS NOMEFOR,
		D1_EMISSAO AS DT_EMISSAO,
		SE2.E2_VENCREA AS VENCTO_REAL,
		SE5.E5_DATA AS DT_BAIXA,
		YEAR(SE5.E5_DATA) AS ANO_BAIXA,
		MONTH(SE5.E5_DATA) AS MES_BAIXA,
		SE2.E2_HIST AS HISTORICO,
		SE2.E2_INFCOMP AS INFORMACOES_COMPL,
		(E2_VALOR)*((D1_TOTAL-D1_VALDESC+D1_DESPESA)/SF1.F1_VALBRUT) AS VALOR_ORIGINAL,
		(E5_VALOR)*((D1_TOTAL-D1_VALDESC+D1_DESPESA)/SF1.F1_VALBRUT) AS VALOR_PAGO,
		D1_ITEMCTA AS ITEM_CTA,
		(
			CASE 
				WHEN D1_CLVL = ''
					AND C7_CLVL <> ''
					THEN C7_CLVL
				WHEN D1_CLVL = ''
					AND C7_CLVL = ''
					THEN C1_CLVL
				ELSE D1_CLVL
				END
			) AS CLASSE_VALOR,
		(
			CASE 
				WHEN LEFT(SE2.E2_ORIGEM, 4) = 'MATA'
					THEN 'COMPRAS'
				END
			) AS ORIGEM,
		(
			CASE 
				WHEN SD1.R_E_C_N_O_ IS NULL
					THEN 0
				ELSE SD1.R_E_C_N_O_
				END
			) + (
			CASE 
				WHEN SE2.R_E_C_N_O_ IS NULL
					THEN 0
				ELSE SE2.R_E_C_N_O_
				END
			) + (
			CASE 
				WHEN SE5.R_E_C_N_O_ IS NULL
					THEN 0
				ELSE SE5.R_E_C_N_O_
				END
			) + (
			CASE 
				WHEN SC1.R_E_C_N_O_ IS NULL
					THEN 0
				ELSE SC1.R_E_C_N_O_
				END
			) + (
			CASE 
				WHEN SC7.R_E_C_N_O_ IS NULL
					THEN 0
				ELSE SC7.R_E_C_N_O_
				END
			) + (
			CASE 
				WHEN SA2.R_E_C_N_O_ IS NULL
					THEN 0
				ELSE SA2.R_E_C_N_O_
				END
			) + convert(INT, SE5.E5_DATA) AS RECNO,
		D1_PEDIDO,
		C1_NUM,
		CHAVE = SE2.E2_FILORIG + '-' + SE2.E2_PREFIXO + '-' + SE2.E2_NUM + '-' + SE2.E2_PARCELA + '-' + SE2.E2_TIPO + '-' + SD1.D1_ITEM,
		CHAVE2 = '',
		REF = 'COMPRAS-NOTFATURA'
	FROM PROTHEUS..SE5010 SE5 WITH (NOLOCK)
	LEFT JOIN PROTHEUS..SE2010 SE2 WITH (NOLOCK)
		ON SE5.E5_PREFIXO = SE2.E2_PREFIXO
			AND SE5.E5_CLIFOR = SE2.E2_FORNECE
			AND SE5.E5_LOJA = SE2.E2_LOJA
			AND SE5.E5_NUMERO = SE2.E2_NUM
			AND SE5.E5_PARCELA = SE2.E2_PARCELA
			AND SE5.E5_FILORIG = SE2.E2_FILORIG
			AND SE5.E5_FILIAL = SE2.E2_FILIAL
			AND SE5.E5_TIPO = SE2.E2_TIPO
	LEFT JOIN PROTHEUS..SD1010 SD1 WITH (NOLOCK)
		ON SE2.E2_FILORIG = D1_FILIAL
			AND SE2.E2_NUM = D1_DOC
			AND SE2.E2_FORNECE = D1_FORNECE
			AND SE2.E2_LOJA = D1_LOJA
			AND SE2.E2_PREFIXO = D1_SERIE
	LEFT JOIN PROTHEUS..SC7010 SC7 WITH (NOLOCK)
		ON D1_FILIAL = C7_FILIAL
			AND D1_PEDIDO = C7_NUM
			AND D1_ITEMPC = C7_ITEM
			AND D1_FORNECE = C7_FORNECE
			AND D1_LOJA = C7_LOJA
	LEFT JOIN PROTHEUS..SF1010 SF1 WITH (NOLOCK)
		ON SF1.F1_FILIAL = D1_FILIAL
				AND SF1.F1_SERIE = D1_SERIE
				AND SF1.F1_DOC = D1_DOC
				AND SF1.F1_FORNECE = D1_FORNECE
				AND SF1.F1_LOJA = D1_LOJA
	LEFT JOIN PROTHEUS..SC1010 SC1 WITH (NOLOCK)
		ON C7_NUMSC = C1_NUM
			AND C7_ITEMSC = C1_ITEM
			AND C1_FILIAL = C7_FILIAL
	LEFT JOIN PROTHEUS..SA2010 SA2 WITH (NOLOCK)
		ON A2_COD = SE5.E5_CLIFOR
			AND SE5.E5_LOJA = A2_LOJA
	WHERE ISNULL(SC1.D_E_L_E_T_, '') = ''
		AND ISNULL(SF1.D_E_L_E_T_, '') = ''
		AND ISNULL(SC7.D_E_L_E_T_, '') = ''
		AND ISNULL(SD1.D_E_L_E_T_, '') = ''
		AND ISNULL(SE2.D_E_L_E_T_, '') = ''
		AND ISNULL(SE5.D_E_L_E_T_, '') = ''
		AND ISNULL(SA2.D_E_L_E_T_, '') = ''
		AND LEFT(SE2.E2_ORIGEM, 4) = 'MATA'
		AND SE2.E2_FATURA = ''
		AND SE5.E5_TIPODOC IN (
			'VL',
			'CP'
			)
		AND SE5.E5_MOTBX IN (
			'NOR',
			'DEB',
			'CMP'
			)
		AND SE2.E2_SALDO = 0
		AND SE2.E2_TIPO <> 'TX'
		AND SE5.E5_SITUACA <> 'C'
		AND SE5.E5_DTCANBX = ''
		AND SE5.E5_SEQ = (
			SELECT MAX(E5_SEQ)
			FROM PROTHEUS..SE5010 SE5SEQ WITH (NOLOCK)
			WHERE SE5SEQ.D_E_L_E_T_ = ''
				AND SE5SEQ.R_E_C_N_O_ = SE5.R_E_C_N_O_
			)
	
	UNION ALL
	
	--#######		TITULOS GERADOS DIRETAMENTE NO FINANCEIRO SEM FATURAS	  #########
	SELECT E2_CCD AS CCUSTO,
		SE5.E5_NATUREZ AS NATUREZA,
		SE5.E5_PREFIXO AS PREFIXO,
		SE5.E5_NUMERO AS NUMERO,
		SE5.E5_TIPO AS TIPO,
		SE5.E5_PARCELA AS PARCELA,
		SE5.E5_CLIFOR AS COD_FORNECEDOR,
		SE5.E5_LOJA AS LOJA,
		SA2.A2_NOME AS NOMEFOR,
		E2_EMISSAO AS DT_EMISSAO,
		SE5.E5_VENCTO AS VENCTO_REAL,
		SE5.E5_DATA AS DT_BAIXA,
		YEAR(SE5.E5_DATA) AS ANO_BAIXA,
		MONTH(SE5.E5_DATA) AS MES_BAIXA,
		SE2.E2_HIST AS HISTORICO,
		E2_INFCOMP AS INFORMACOES_COMPL,
		E2_VALOR AS VALOR_ORIGINAL,
		E5_VALOR AS VALOR_PAGO,
		E2_ITEMCTA AS ITEM_CTA,
		SE2.E2_CLVL AS CLASSE_VALOR,
		(
			CASE 
				WHEN LEFT(E2_ORIGEM, 4) = 'FINA'
					THEN 'FINANCEIRO'
				ELSE 'FOLHA'
				END
			) AS ORIGEM,
		(
			CASE 
				WHEN SE2.R_E_C_N_O_ IS NULL
					THEN 0
				ELSE SE2.R_E_C_N_O_
				END
			) + (
			CASE 
				WHEN SE5.R_E_C_N_O_ IS NULL
					THEN 0
				ELSE SE5.R_E_C_N_O_
				END
			) + (
			CASE 
				WHEN SA2.R_E_C_N_O_ IS NULL
					THEN 0
				ELSE SA2.R_E_C_N_O_
				END
			) + convert(INT, SE5.E5_DATA) AS RECNO,
		D1_PEDIDO = '',
		C1_NUM = '',
		CHAVE = SE2.E2_FILORIG + '-' + SE2.E2_PREFIXO + '-' + SE2.E2_NUM + '-' + SE2.E2_PARCELA + '-' + SE2.E2_TIPO,
		CHAVE2 = '',
		REF = 'FINANCEIRO-NOTFATURA'
	FROM PROTHEUS..SE5010 SE5 WITH (NOLOCK)
	LEFT JOIN PROTHEUS..SE2010 SE2 WITH (NOLOCK)
		ON E5_PREFIXO = E2_PREFIXO
			AND E5_CLIFOR = E2_FORNECE
			AND E5_LOJA = E2_LOJA
			AND E5_NUMERO = E2_NUM
			AND E2_PARCELA = E5_PARCELA
			AND E2_FILORIG = E5_FILORIG
			AND E2_FILIAL = E5_FILIAL
	LEFT JOIN PROTHEUS..SA2010 SA2 WITH (NOLOCK)
		ON A2_COD = SE5.E5_CLIFOR
			AND SE5.E5_LOJA = A2_LOJA
	WHERE ISNULL(SE2.D_E_L_E_T_, '') = ''
		AND ISNULL(SA2.D_E_L_E_T_, '') = ''
		AND ISNULL(SE5.D_E_L_E_T_, '') = ''
		AND E2_FATURA = ''
		AND SE2.E2_ORIGEM NOT IN (
			'FINA565',
			'FINA290',
			'MATA100'
			)
		AND SE5.E5_TIPODOC IN (
			'VL',
			'CP'
			)
		AND SE5.E5_MOTBX IN (
			'NOR',
			'DEB',
			'CMP'
			)
		AND SE2.E2_SALDO = 0
		AND SE5.E5_DTCANBX = ''
		AND SE5.E5_SITUACA <> 'C'
		AND SE5.E5_SEQ = (
			SELECT MAX(E5_SEQ)
			FROM PROTHEUS..SE5010 SE5SEQ WITH (NOLOCK)
			WHERE SE5SEQ.D_E_L_E_T_ = ''
				AND SE5SEQ.R_E_C_N_O_ = SE5.R_E_C_N_O_
			)
	
	UNION ALL
	
	--#######		TITULOS GERADOS DIRETAMENTE NO FINANCEIRO COM FATURAS	  #########
	SELECT (
			CASE 
				WHEN SE2FAT.E2_CCD = ''
					THEN SE2.E2_CCD
				ELSE SE2FAT.E2_CCD
				END
			) AS CCUSTO,
		SE5.E5_NATUREZ AS NATUREZA,
		SE5.E5_PREFIXO AS PREFIXO,
		SE5.E5_NUMERO AS NUMERO,
		SE5.E5_PARCELA AS PARCELA,
		SE5.E5_TIPO AS TIPO,
		SE5.E5_CLIFOR AS COD_FORNECEDOR,
		SE5.E5_LOJA AS LOJA,
		SA2.A2_NOME AS NOMEFOR,
		SE2FAT.E2_EMISSAO AS DT_EMISSAO,
		SE2FAT.E2_VENCREA AS VENCTO_REAL,
		SE5.E5_DATA AS DT_BAIXA,
		YEAR(SE5.E5_DATA) AS ANO_BAIXA,
		MONTH(SE5.E5_DATA) AS MES_BAIXA,
		SE2FAT.E2_HIST AS HISTORICO,
		SE2FAT.E2_INFCOMP AS INFORMACOES_COMPL,
		SE2FAT.E2_VALOR AS VALOR_ORIGINAL,
		SE5.E5_VALOR * (SE2FAT.E2_VALOR / SE5.E5_VALOR) AS VALOR_PAGO,
		SE2FAT.E2_ITEMCTA AS ITEM_CTA,
		SE2FAT.E2_CLVL AS CLASSE_VALOR,
		(
			CASE 
				WHEN LEFT(SE2FAT.E2_ORIGEM, 4) = 'FINA'
					THEN 'FINANCEIRO'
				ELSE 'FOLHA'
				END
			) AS ORIGEM,
		(
			CASE 
				WHEN SE2FAT.R_E_C_N_O_ IS NULL
					THEN 0
				ELSE SE2FAT.R_E_C_N_O_
				END
			) + (
			CASE 
				WHEN SE2.R_E_C_N_O_ IS NULL
					THEN 0
				ELSE SE2.R_E_C_N_O_
				END
			) + (
			CASE 
				WHEN SE5.R_E_C_N_O_ IS NULL
					THEN 0
				ELSE SE5.R_E_C_N_O_
				END
			) + (
			CASE 
				WHEN SA2.R_E_C_N_O_ IS NULL
					THEN 0
				ELSE SA2.R_E_C_N_O_
				END
			) + convert(INT, SE5.E5_DATA) AS RECNO,
		D1_PEDIDO = '',
		C1_NUM = '',
		CHAVE = SE2FAT.E2_FILORIG + '-' + SE2FAT.E2_PREFIXO + '-' + SE2FAT.E2_NUM + '-' + SE2FAT.E2_PARCELA + '-' + SE2FAT.E2_TIPO,
		CHAVE2 = SE2.E2_FILORIG + '-' + SE2.E2_PREFIXO + '-' + SE2.E2_NUM + '-' + SE2.E2_PARCELA + '-' + SE2.E2_TIPO,
		REF = 'FINANCEIRO-FATURA'
	FROM PROTHEUS..SE5010 SE5 WITH (NOLOCK)
	LEFT JOIN PROTHEUS..SE2010 SE2FAT WITH (NOLOCK)
		ON SE5.E5_PREFIXO = SE2FAT.E2_PREFIXO
			AND SE5.E5_CLIFOR = SE2FAT.E2_FORNECE
			AND SE5.E5_LOJA = SE2FAT.E2_LOJA
			AND SE5.E5_NUMERO = SE2FAT.E2_NUM
			AND SE2FAT.E2_PARCELA = SE5.E5_PARCELA
			AND SE2FAT.E2_FILORIG = SE5.E5_FILORIG
			AND SE2FAT.E2_FILIAL = SE5.E5_FILIAL
	LEFT JOIN PROTHEUS..SE2010 SE2 WITH (NOLOCK)
		ON SE2.E2_FATPREF = SE2FAT.E2_PREFIXO
			AND SE2.E2_FATURA = SE2FAT.E2_NUM
			AND SE2.E2_TIPOFAT = SE2FAT.E2_TIPO
			AND SE2.E2_FATFOR = SE2FAT.E2_FORNECE
			AND SE2.E2_FATLOJ = SE2FAT.E2_LOJA
	LEFT JOIN PROTHEUS..SA2010 SA2 WITH (NOLOCK)
		ON A2_COD = SE5.E5_CLIFOR
			AND SE5.E5_LOJA = A2_LOJA
	WHERE ISNULL(SE2.D_E_L_E_T_, '') = ''
		AND ISNULL(SA2.D_E_L_E_T_, '') = ''
		AND ISNULL(SE5.D_E_L_E_T_, '') = ''
		AND ISNULL(SE2FAT.D_E_L_E_T_, '') = ''
		AND SE2FAT.E2_FATURA <> ''
		AND SE2FAT.E2_ORIGEM IN (
			'FINA290',
			'FINA565'
			)
		AND SUBSTRING(SE2.E2_ORIGEM, 1, 4) <> 'MATA'
		AND SE5.E5_TIPODOC IN (
			'VL',
			'CP'
			)
		AND SE5.E5_MOTBX IN (
			'NOR',
			'DEB',
			'CMP'
			)
		AND SE2FAT.E2_SALDO = 0
		AND SE2.E2_SALDO = 0
		AND SE5.E5_DTCANBX = ''
		AND SE5.E5_SITUACA <> 'C'
		AND SE5.E5_SEQ = (
			SELECT MAX(E5_SEQ)
			FROM PROTHEUS..SE5010 SE5SEQ WITH (NOLOCK)
			WHERE SE5SEQ.D_E_L_E_T_ = ''
				AND SE5SEQ.R_E_C_N_O_ = SE5.R_E_C_N_O_
			)
	union all 

	SELECT --*
		SE5.E5_CCD AS CCUSTO,
		SE5.E5_NATUREZ AS NATUREZA,
		SE5.E5_PREFIXO AS PREFIXO,
		SE5.E5_DOCUMEN AS NUMERO,
		SE5.E5_PARCELA AS PARCELA,
		SE5.E5_TIPO AS TIPO,
		SE5.E5_CLIFOR AS COD_FORNECEDOR,
		SE5.E5_LOJA AS LOJA,
		NOMEFOR='',
		SE5.E5_DTDIGIT AS DT_EMISSAO,
		SE5.E5_VENCTO AS VENCTO_REAL,
		SE5.E5_DATA AS DT_BAIXA,
		YEAR(SE5.E5_DATA) AS ANO_BAIXA,
		MONTH(SE5.E5_DATA) AS MES_BAIXA,
		SE5.E5_HISTOR AS HISTORICO,
		INFORMACOES_COMPL='',
		SE5.E5_VALOR AS VALOR_ORIGINAL,
		SE5.E5_VALOR AS VALOR_PAGO,
		SE5.E5_ITEMD AS ITEM_CTA,
		SE5.E5_CLVLDB AS CLASSE_VALOR,
		'FINANCEIRO' AS ORIGEM,
		(
			CASE 
				WHEN SE5.R_E_C_N_O_ IS NULL
					THEN 0
				ELSE SE5.R_E_C_N_O_
				END
		) + convert(INT, SE5.E5_DATA) AS RECNO,
		D1_PEDIDO = '',
		C1_NUM = '',
		CHAVE = SE5.E5_FILORIG + '-' + SE5.E5_PREFIXO + '-' + SE5.E5_NUMERO + '-' + SE5.E5_PARCELA + '-' + SE5.E5_TIPO,
		CHAVE2 = '',
		REF = 'FINANCEIRO-MOVB'
	FROM SE5010 SE5 WITH (NOLOCK)
	WHERE 
	E5_ORIGEM='FINA100' 
	AND E5_TIPODOC NOT IN ('TR') 
	AND E5_DTCANBX='' 
	AND E5_SITUACA<>'C' 
	AND E5_RECPAG='P'
	AND SE5.D_E_L_E_T_=''
	) AS TBGERENCIAL
	/*WHERE
	ANO_BAIXA=2020 AND
	MES_BAIXA=1 AND
	NUMERO IN ('000293') AND
	COD_FORNECEDOR='952387' */