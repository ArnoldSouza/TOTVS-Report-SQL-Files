SELECT
	--IDENTIFICA LOCAL CASO TENHA CENTRO DE CUSTO
	ISNULL(REPLACE(RTRIM(CTT010.CTT_XREGIO),'_',' '),'ESTOQUE') AS 'REGIONAL',

	ISNULL(IIF(
		REPLACE(REPLACE(RTRIM(CTT_XPOLO),'_',' '),'POLO ', '')=REPLACE(RTRIM(CTT010.CTT_XREGIO),'_',' '),
		REPLACE(REPLACE(RTRIM(CTT_XPOLO),'_',' '),'POLO ', ''),
		REPLACE(REPLACE(REPLACE(RTRIM(CTT_XPOLO),'_',' '),'POLO ', ''), REPLACE(RTRIM(CTT010.CTT_XREGIO),'_',' ')+' ', '')
	),'ESTOQUE') AS 'POLO',

	SD1010.D1_FILIAL AS 'FILIAL',
	SD1010.D1_LOCAL AS 'LOCAL',
	CONCAT(SD1010.D1_FILIAL,SD1010.D1_LOCAL,'-',Z01010.Z01_DESC) AS 'DESCRIÇÃO ARMAZÉM',
	SD1010.D1_CC AS 'CENTRO DE CUSTO',
	SD1010.D1_DOC AS 'DOCUMENTO',
	SD1010.D1_ITEM AS 'ITEM',
	SD1010.D1_COD AS 'CODIGO',
	RTRIM(SB1010.B1_DESC) AS 'DESCRIÇÃO',
	SD1010.D1_UM AS 'UND',
	SD1010.D1_QUANT AS 'QTDE DOC',
	SD1010.D1_VUNIT	AS 'VAL UND',
	SD1010.D1_TOTAL AS 'VAL TOTAL',
	SD1010.D1_CONTA AS 'CONTA CONTÁBIL',
	CASE WHEN SD1010.D1_CONTA = '                    ' THEN 'ATIVO FIXO' ELSE RTRIM(CT1010.CT1_DESC01) END AS 'DESC CONT CONTÁBIL',
	CASE WHEN SD1010.D1_CC = '         ' THEN 'PROCESSO PARA ARMAZÉM' ELSE RTRIM(CTT010.CTT_DESC01) END AS 'DESCRIÇÃO CENTRO DE CUSTO',
	SD1010.D1_PEDIDO AS 'NUM PC',
	SD1010.D1_ITEMPC AS 'ITEM PC',

	--*************************************************--
	--*** DADOS DE SOLICITAÇÃO E PEDIDOS DE COMPRAS ***--
	--*************************************************--

	--DADOS DE PC
	SC7010.C7_NUMSC AS 'NUM SC',
	SC7010.C7_ITEMSC AS 'ITEM SC',
	SC7010.C7_USER AS 'COD COMPRADOR',
	RTRIM(SY1010.Y1_NOME) AS 'NOME COMPRADOR',
	--FAZ PESQUISA NO HISTÓRICO DE COMPRAS SOBRE O PC EM QUESTÃO E RETORNA A DATA
		(
			SELECT
				TOP 1 Case RTrim(Coalesce(ZE2010.ZE2_DATA,'')) WHEN ''  THEN Null ELSE convert(DATETIME, ZE2010.ZE2_DATA, 112) END
			FROM ZE2010
			WHERE ZE2010.ZE2_PEDIDO = SC7010.C7_NUM AND ZE2010.ZE2_FILIAL = SC7010.C7_FILIAL AND ZE2010.D_E_L_E_T_ <> '*'
			ORDER BY ZE2010.R_E_C_N_O_ DESC
		) AS 'STATUS PC DATA ',

		(
			SELECT TOP 1 RTRIM(ZE2010.ZE2_OBS)
			FROM ZE2010
			WHERE ZE2010.ZE2_PEDIDO = SC7010.C7_NUM AND ZE2010.ZE2_FILIAL = SC7010.C7_FILIAL AND ZE2010.D_E_L_E_T_ <> '*'
			ORDER BY ZE2010.R_E_C_N_O_ DESC
		) AS 'OBS STATUS',
	--DATA DE APROVAÇÃO
		CONVERT(DATETIME,
			(
				SELECT MAX(LastUpdateDate)
				FROM (VALUES (SC7010.C7_DTLIB1),(SC7010.C7_DTLIB2),(SC7010.C7_DTLIB3),(SC7010.C7_DTLIB4),(SC7010.C7_DTLIB5),(SC7010.C7_DTLIB6),(SC7010.C7_DTLIB7), (SC7010.C7_EMISSAO), (SC7010.C7_ALTDATA)) AS UpdateDate(LastUpdateDate)
			)
		, 112) AS 'DT APROVAÇÃO PC',
		--TEMPO ATÉ APROVAR PROCESSO
		DATEDIFF(DAY,
			CONVERT(DATETIME, IIF(SC7010.C7_ALTDATA>SC7010.C7_EMISSAO, SC7010.C7_ALTDATA, SC7010.C7_EMISSAO), 112),
			CONVERT(
			   DATETIME,
				   (
						SELECT MAX(LastUpdateDate)
						FROM (VALUES (SC7010.C7_DTLIB1),(SC7010.C7_DTLIB2),(SC7010.C7_DTLIB3),(SC7010.C7_DTLIB4),(SC7010.C7_DTLIB5),(SC7010.C7_DTLIB6),(SC7010.C7_DTLIB7), (SC7010.C7_EMISSAO), (SC7010.C7_ALTDATA)) AS UpdateDate(LastUpdateDate)
					)
			)
		) AS 'TEMPO APROVA PC',

	--DADOS DE SC
	SC1010.C1_SOLICIT AS 'NOME SOLICITANTE SC',
	SC1010.C1_OBS AS 'OBSERVAÇÃO',
	CASE WHEN SC1010.C1_TPCOMPR='2' THEN 'AP DIRETA' WHEN SC1010.C1_TPCOMPR='1' THEN 'ESTOQUE' END AS 'TIPO DE COMPRA ',
	--DATA EM QUE O PROCESSO FOI APROVADO OU ULTIMA ATUALIZAÇÃO REGISTRADA
		CONVERT(DATETIME,
					(
						SELECT MAX(LastUpdateDate)
						FROM (VALUES (SC1010.C1_DTLIB1),(SC1010.C1_DTLIB2),(SC1010.C1_DTLIB3),(SC1010.C1_DTLIB4),(SC1010.C1_DTLIB5),(SC1010.C1_DTLIB6),(SC1010.C1_DTLIB7), (SC1010.C1_EMISSAO), (SC1010.C1_ALTDATA)) AS UpdateDate(LastUpdateDate)
					)
		, 112) AS 'DT APROVAÇÃO SC',
		--TEMPO ATÉ APROVAR PROCESSO
		DATEDIFF(DAY,
			CONVERT(DATETIME, IIF(SC1010.C1_ALTDATA>SC1010.C1_EMISSAO, SC1010.C1_ALTDATA, SC1010.C1_EMISSAO), 112),
			CONVERT(
			   DATETIME,
				   (
						SELECT MAX(LastUpdateDate)
						FROM (VALUES (SC1010.C1_DTLIB1),(SC1010.C1_DTLIB2),(SC1010.C1_DTLIB3),(SC1010.C1_DTLIB4),(SC1010.C1_DTLIB5),(SC1010.C1_DTLIB6),(SC1010.C1_DTLIB7), (SC1010.C1_EMISSAO), (SC1010.C1_ALTDATA)) AS UpdateDate(LastUpdateDate)
					)
			)
		) AS 'TEMPO APROVA SC',

	--*************************************************--
	--*** DADOS DE SOLICITAÇÃO E PEDIDOS DE COMPRAS ***--
	--*************************************************--

	SD1010.D1_FORNECE AS 'FORNECEDOR',

	--DADOS DE FORNECEDOR
	CASE WHEN SD1010.D1_FORNECE = '      ' THEN '' ELSE RTRIM(SA2010.A2_NOME)  END AS 'NOME FORNECEDOR',
	SA2010.A2_TIPO AS 'PESSOA JUR\FIS',
	SA2010.A2_CGC AS 'CNPJ\CPF',
	RTRIM(SA2010.A2_NREDUZ) AS 'NOME FANTASIA',

	--DADOS DE PRODUTOS
	SB1010.B1_GRUPO AS 'COD GRUPO',
	RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO',

	--DATAS DO PROCESSO
	Case RTrim(Coalesce(SD1010.D1_EMISSAO,'')) WHEN ''  THEN Null ELSE convert(datetime,SD1010.D1_EMISSAO, 112)END AS 'DT EMISSÃO PN', --DT EMISSÃO DA NF
	Case RTrim(Coalesce(SF1010.F1_DTDIGIT,'')) WHEN ''  THEN Null ELSE convert(datetime,SF1010.F1_DTDIGIT, 112)END AS 'DT DIGITAÇÃO PN', --DT EM QUE OCORREU A CLASSIFICAÇÃO
	Case RTrim(Coalesce(SF1010.F1_DTINCL,'')) WHEN ''  THEN Null ELSE convert(datetime,SF1010.F1_DTINCL, 112)END AS 'DT INCLUSÃO PN',
	Case RTrim(Coalesce(SF1010.F1_DTLANC,'')) WHEN ''  THEN Null ELSE convert(datetime,SF1010.F1_DTLANC, 112)END AS 'DT CLASSIFICAÇÃO PN',  --DT DA CONTABILIZAÇÃO
	Case RTrim(Coalesce(SF1010.F1_RECBMTO,'')) WHEN ''  THEN Null ELSE convert(datetime,SF1010.F1_RECBMTO, 112)END AS 'DT RECEBIMENTO PN', --DT EM QUE O MATERIAL FOI RECEBIDO

	SD1010.D1_CLVL AS 'COD DE OBRA',
	RTRIM(SD1010.D1_CLVL)+' - '+CTH010.CTH_DESC01 AS 'DESC OBRA/PROJETO',
	SD1010.D1_SERIE AS 'SERIE',
	SD1010.D1_LOJA  AS 'LOJA',

	--DADOS DE CABEÇALHO DE PRENOTA
	SF1010.F1_NMUSER AS 'USUÁRIO INCLUIU PRENOTA',
	SF1010.F1_LOGNF AS 'HISTORICO NF',
	SF1010.F1_OBS AS 'OBS. PRE-NOTA',
	SF1010.F1_MOTRET AS 'MOT. RETORNO',
	SF1010.F1_OBSCLA AS 'OBS. CLASSIF',
	SF1010.F1_ESPECIE AS 'ESPEC. DOC',

	CASE
		WHEN (SD1010.D1_CC<>'          ') THEN 'AP DIRETA'
		WHEN (SD1010.D1_CC='          ') THEN 'ESTOQUE'
		ELSE 'ERRO'
	END AS 'TIPO PROCESSO',

    CASE
        WHEN SD1010.D1_LOCAL='  ' THEN 'ERRO'
        WHEN Z01010.Z01_DESC LIKE '% USA-%' THEN 'USADOS'
        WHEN (LEFT(SA2010.A2_CGC,8)='05061494') THEN 'TRANSF ENDICON'
        WHEN SD1010.D1_CONTA = '                    ' THEN 'ATIVO FIXO'
        WHEN (SD1010.D1_CLVL='001') THEN 'MOBILIZACAO'
		WHEN (SD1010.D1_CLVL='004') THEN 'RESSUP PROGR'
        WHEN (SD1010.D1_CLVL='005') THEN 'RESSUP EMERG'
		ELSE 'CUSTEIO'
	END AS 'TIPO PROCESSO 2',



    -->>MOVIMENTOS DE PV<<--
    CASE
        WHEN (LEFT(SA2010.A2_CGC,8)='05061494') THEN --CASO TRANSFERENCIA, CRIAR MENSAGEM DE DETALHE
            CONCAT(
                'DE-PARA: ', CONCAT(SD2010.D2_FILIAL, SD2010.D2_LOCAL, '->', SD1010.D1_FILIAL, SD1010.D1_LOCAL),
                '| PV: ', RTRIM(SC5010.C5_NUM),
                '| USER MOV: ', RTRIM(SC5010.C5_USUINL),
                '| OBS: ', RTRIM(SC5010.C5_MENNOTA)
            )
        ELSE ''
    END AS 'DETALHE PV'

FROM PROTHEUS.dbo.SD1010 SD1010 WITH (NOLOCK)
	LEFT MERGE JOIN PROTHEUS.dbo.Z01010 Z01010 WITH (NOLOCK) ON (Z01010.Z01_FILIAL=SD1010.D1_FILIAL AND Z01010.Z01_COD=SD1010.D1_LOCAL) AND Z01010.D_E_L_E_T_<>'*'
	LEFT MERGE JOIN PROTHEUS.dbo.CT1010 CT1010 WITH (NOLOCK) ON SD1010.D1_CONTA=CT1010.CT1_CONTA AND CT1010.D_E_L_E_T_<>'*'
	LEFT MERGE JOIN PROTHEUS.dbo.CTT010 CTT010 WITH (NOLOCK) ON SD1010.D1_CC=CTT010.CTT_CUSTO AND CTT010.D_E_L_E_T_<>'*'
	LEFT MERGE JOIN PROTHEUS.dbo.CTH010 CTH010 WITH (NOLOCK) ON SD1010.D1_CLVL=CTH010.CTH_CLVL AND CTH010.D_E_L_E_T_<>'*'
	LEFT MERGE JOIN PROTHEUS.dbo.SA2010 SA2010 WITH (NOLOCK) ON SD1010.D1_FORNECE=SA2010.A2_COD AND SD1010.D1_LOJA=SA2010.A2_LOJA AND SA2010.D_E_L_E_T_<>'*'
	LEFT MERGE JOIN PROTHEUS.dbo.SF1010 SF1010 WITH (NOLOCK) ON SD1010.D1_DOC=SF1010.F1_DOC AND SD1010.D1_SERIE=SF1010.F1_SERIE AND SD1010.D1_FORNECE=SF1010.F1_FORNECE AND SD1010.D1_LOJA=SF1010.F1_LOJA AND SF1010.D_E_L_E_T_<>'*'
	LEFT MERGE JOIN PROTHEUS.dbo.SF4010 SF4010 WITH (NOLOCK) ON SF4010.F4_CODIGO=SD1010.D1_TES AND SF4010.D_E_L_E_T_<>'*'
	--CONEXÃO SC E PC
	LEFT MERGE JOIN PROTHEUS.dbo.SC7010 SC7010 WITH (NOLOCK) ON (SD1010.D1_PEDIDO=SC7010.C7_NUM AND SD1010.D1_ITEMPC=SC7010.C7_ITEM) AND SC7010.D_E_L_E_T_<>'*'
	LEFT MERGE JOIN PROTHEUS.dbo.SC1010 SC1010 WITH (NOLOCK) ON (SC7010.C7_NUMSC=SC1010.C1_NUM AND SC7010.C7_ITEMSC=SC1010.C1_ITEM) AND SC1010.D_E_L_E_T_<>'*'
	--CONEXÃO PRODUTOS
	LEFT MERGE JOIN PROTHEUS.dbo.SB1010 SB1010 WITH (NOLOCK) ON SD1010.D1_COD=SB1010.B1_COD AND SB1010.D_E_L_E_T_<>'*'
	LEFT MERGE JOIN PROTHEUS.dbo.SBM010 SBM010 WITH (NOLOCK) ON SB1010.B1_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_<>'*'
	--CONEXÃO DE NOME DE COMPRADOR
	LEFT MERGE JOIN PROTHEUS.dbo.SY1010 SY1010 WITH (NOLOCK) ON SC7010.C7_USER=SY1010.Y1_USER AND SY1010.D_E_L_E_T_<>'*'
    --CONEXÃO COM PV
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
	--DESCONSIDERA DELETADOS
	(SD1010.D_E_L_E_T_<>'*') AND
    (SD1010.D1_TES='   ') --SOMENTE PRENOTAS PENDENTES DE CLASSIFICACAO
