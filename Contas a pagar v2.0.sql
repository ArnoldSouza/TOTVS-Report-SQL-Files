SELECT TOP 1000
    --GRUPOS CLASSIFICADORES
    RTRIM(SE2010.E2_NATUREZ) AS 'NATUREZA',
    RTRIM(SED010.ED_DESCRIC) AS 'DESC NATUREZA',

    --INDICA O MODULO QUE DEU ORIGEM NO PROTHEUS
	RTRIM(SE2010.E2_ORIGEM) AS 'ORIGEM',
    CASE
        WHEN RTRIM(SE2010.E2_ORIGEM)='CADSZV' THEN 'FOLHA' --GESTAO DE PESSOAL (FOLHA)
        WHEN RTRIM(SE2010.E2_ORIGEM)='INTENDIC' THEN 'FOLHA' --GESTAO DE PESSOAL (PENSAO ALIMENTICIA)
        WHEN RTRIM(SE2010.E2_ORIGEM)='MATA100' THEN 'COMPRAS' --ORINDO DO MODULO DE ESTOQUE/COMPRAS
        WHEN RTRIM(SE2010.E2_ORIGEM)='FINA050' THEN 'FIN MANUAL' --LANÇAMENTOS DIRETO PELO CONTAS A PAGAR
        WHEN RTRIM(SE2010.E2_ORIGEM)='FINA290' THEN 'FIN FATURAS' --PROCEDIMENTO EFETUADO DE FORMA MANUAL VIA ROTINA FATURAS A PAGAR
        WHEN RTRIM(SE2010.E2_ORIGEM)='MATA460' THEN 'FATURAMENTO' --CRIADO PARA PAGAR IMPOSTOS NA ROTINA DE EMISSAO DE NFS-SAIDA
        ELSE 'ERRO - CLASSIFICAR'
    END AS 'CLASSE ORIGEM',

    --DADOS DO DOCUMENTO
    RTRIM(SE2010.E2_FILORIG) AS 'FILIAL ORIG',
    RTRIM(SE2010.E2_TIPO) AS 'TIPO DOC',
    CASE
        WHEN RTRIM(SE2010.E2_TIPO)='BOL' THEN 'BOLETO'
        WHEN RTRIM(SE2010.E2_TIPO)='CH' THEN 'CHEQUE'
        WHEN RTRIM(SE2010.E2_TIPO)='FA' THEN 'FATURA'
        WHEN RTRIM(SE2010.E2_TIPO)='FOL' THEN 'FOLHA'
        WHEN RTRIM(SE2010.E2_TIPO)='FT' THEN 'FATURA'
        WHEN RTRIM(SE2010.E2_TIPO)='INS' THEN 'INSS'
        WHEN RTRIM(SE2010.E2_TIPO)='ISS' THEN 'ISS'
        WHEN RTRIM(SE2010.E2_TIPO)='NDF' THEN 'NDF'
        WHEN RTRIM(SE2010.E2_TIPO)='NF' THEN 'NF'
        WHEN RTRIM(SE2010.E2_TIPO)='PA' THEN 'P.A.'
        WHEN RTRIM(SE2010.E2_TIPO)='RC' THEN 'RECIBO'
        WHEN RTRIM(SE2010.E2_TIPO)='TF' THEN 'TARIFA'
        WHEN RTRIM(SE2010.E2_TIPO)='TX' THEN 'TAXA'
        ELSE 'ERRO - CLASSIFICAR'
    END AS 'CLASSE DOC',
    RTRIM(SE2010.E2_NUM) AS 'TITULO (DOC)',
    RTRIM(SE2010.E2_PARCELA) AS 'PARCELA',
    RTRIM(SE2010.E2_PREFIXO) AS 'PREFIXO NF',
    RTRIM(SE2010.E2_NUMBOR) AS 'NUM BORDERO',

    --BLOCO CUSTOMIZADO DE INDICADORES RELAÇÃO FATURA X TÍTULO
    IIF(SE2010.E2_FLAGFAT='S' OR RTRIM(SE2010.E2_FATURA)='NOTFAT', 'FATURA', 'TITULO') AS 'TIPO LANCAMENTO',
    CASE
        WHEN RTRIM(SE2010.E2_FATURA)='NOTFAT' THEN 'FATURA-DOCUMENTO'
        WHEN SE2010.E2_FLAGFAT='S' THEN 'FATURA-COMPONENTE'
        WHEN SE2010.E2_FLAGFAT<>'S' THEN 'TITULO-DOCUMENTO'
        ELSE 'ERRO - CLASSIFICAR'
    END AS 'CLASSE LANCAMENTO',
    CASE
        WHEN RTRIM(SE2010.E2_FATURA)='NOTFAT' THEN CHAR(149)+'FAT('+RTRIM(SE2010.E2_NUM)+')' --CASO FATURA
        WHEN SE2010.E2_FLAGFAT='S' THEN CHAR(151)+'FAT('+RTRIM(SE2010.E2_FATURA)+')'+CHAR(187)+'TIT('+RTRIM(SE2010.E2_NUM)+')' --CASO COMPONENTES DE FATURA
        WHEN SE2010.E2_FLAGFAT<>'S' THEN '>TIT('+RTRIM(SE2010.E2_NUM)+')' --CASO TITULO'
        ELSE 'ERRO - CLASSIFICAR'
    END AS 'RELACAO DOCS',
    CASE
        WHEN (
            SE2010.E2_FLAGFAT='S' AND --É UM COMPONENTE DE FATURA
            RTRIM(SE2010.E2_NUMBOR) = '' AND --NAO TEM BORDERO
            SE2010.E2_SALDO=0 AND --SALDO ZERADO
            SE2010.E2_VALLIQ>0 AND --VALOR BAIXADO
            RTRIM(SE2010.E2_BAIXA)<>'' --TEM DATA DE BAIXA
        ) THEN 'BAIXADO POR FATURA'
        WHEN (
            SE2010.E2_FLAGFAT<>'S' AND --NÃO É UM COMPONENTE DE FATURA
            RTRIM(SE2010.E2_NUMBOR) <> '' AND --TEM BORDERO
            SE2010.E2_SALDO=0 AND --SALDO ZERADO
            SE2010.E2_VALLIQ>0 AND --VALOR BAIXADO
            RTRIM(SE2010.E2_BAIXA)<>'' --TEM DATA DE BAIXA
        ) THEN 'PAGO'
        WHEN (
            SE2010.E2_FLAGFAT<>'S' AND --NÃO É UM COMPONENTE DE FATURA
            RTRIM(SE2010.E2_NUMBOR) = '' AND --NAO TEM BORDERO
            SE2010.E2_SALDO>0 AND --SALDO ZERADO
            SE2010.E2_VALLIQ=0 AND --VALOR BAIXADO
            RTRIM(SE2010.E2_BAIXA)='' --NAO TEM DATA DE BAIXA
        ) THEN 'PENDENTE'
        ELSE 'ERRO - CLASSIFICAR'
    END AS 'PAGAMENTO',

    --INFORMAÇÕES DE FATURA
    SE2010.E2_FATPREF AS 'PREFIXO FATURA',
    RTRIM(SE2010.E2_FATURA) AS 'NUM FATURA',
    --SE2010.E2_TITPAI AS 'TITULO PAI',
    IIF(SE2010.E2_FLAGFAT='S', 'SIM', 'NÃO') AS 'FATURA',

    --IDENTIFICAÇÃO DO FORNECEDOR
    RTRIM(SA2010.A2_CGC) AS 'CNPJ\CPF',
    CASE LEN(RTRIM(SA2010.A2_CGC))
        WHEN 0 THEN 'SEM COD'
        WHEN 11 THEN 'CPF'
        WHEN 14 THEN 'CNPJ'
        ELSE 'ERRO-CLASSIFICAR'
    END AS 'TP FOR',
    SE2010.E2_FORNECE AS 'COD FORN',
    RTRIM(SA2010.A2_NREDUZ) AS 'NOME FANTASIA',
    RTRIM(SA2010.A2_NOME) AS 'RAZAO SOCIAL',
    SE2010.E2_LOJA AS 'LOJA',

    --VALORES DO TITULO
    SE2010.E2_VALOR AS 'VALOR TITULO',
    --SE2010.E2_VLCRUZ AS 'VALOR',
    --SE2010.E2_DESCONT AS 'DESCONTO',
    --SE2010.E2_JUROS AS 'JUROS',
    SE2010.E2_ACRESC AS 'ACRESCIMO',
    SE2010.E2_DECRESC AS 'DECRESCIMENTO',
    SE2010.E2_SALDO AS 'SALDO',
    SE2010.E2_VALLIQ AS 'VAL LIQ BAIX',
    --SE2010.E2_SDDECRE AS 'SALDO DECRESCIMO',

    --BLOCO DE DATAS
    IIF(RTRIM(COALESCE(SE2010.E2_VENCREA, '')) = '', NULL, CONVERT(DATETIME, SE2010.E2_VENCREA, 112)) AS 'DT VENCIMENTO REAL', --QUANDO EU TENHO QUE PAGAR
    IIF(RTRIM(COALESCE(SE2010.E2_BAIXA, '')) = '', NULL, CONVERT(DATETIME, SE2010.E2_BAIXA, 112)) AS 'DT BAIXA', --QUANDO O PAGAMENTO ACONTECEU
    IIF(RTRIM(COALESCE(SE2010.E2_EMIS1, '')) = '', NULL, CONVERT(DATETIME, SE2010.E2_EMIS1, 112)) AS 'DT CONTABILIZAÇÃO', --DATA EM QUE O TITULO CAIU NO FINANCEIRO
    --IIF(RTRIM(COALESCE(SE2010.E2_VENCORI, '')) = '', NULL, CONVERT(DATETIME, SE2010.E2_VENCORI, 112)) AS 'DT VENCIMENTO ORIGINAL',
    --IIF(RTRIM(COALESCE(SE2010.E2_DTBORDE, '')) = '', NULL, CONVERT(DATETIME, SE2010.E2_DTBORDE, 112)) AS 'DT BORDERO',
    --IIF(RTRIM(COALESCE(SE2010.E2_DATAAGE, '')) = '', NULL, CONVERT(DATETIME, SE2010.E2_DATAAGE, 112)) AS 'DT AGEND',
    --IIF(RTRIM(COALESCE(SE2010.E2_MOVIMEN, '')) = '', NULL, CONVERT(DATETIME, SE2010.E2_MOVIMEN, 112)) AS 'DT ULT MOVIMENT',
    IIF(RTRIM(COALESCE(SE2010.E2_EMISSAO, '')) = '', NULL, CONVERT(DATETIME, SE2010.E2_EMISSAO, 112)) AS 'DT EMISSAO TIT', -- DT DE EMISSAO DO TITULO
    --IIF(RTRIM(COALESCE(SE2010.E2_VENCTO, '')) = '', NULL, CONVERT(DATETIME, SE2010.E2_VENCTO, 112)) AS 'DT VENCIMENTO',

    --OBSERVAÇÕES SOBRE O LANÇAMENTO
    RTRIM(SE2010.E2_HIST) AS 'HISTORICO',
    RTRIM(SE2010.E2_DETHIST) AS 'DETALHE HISTORICO',

    --SE2010.E2_LA AS 'IDENT LANC',
    --SE2010.E2_IDCNAB AS 'ID CNAB',
    --SE2010.E2_STATLIB AS 'LIBERADO',
    --SE2010.E2_TEMDOCS AS 'POSSUI DOCS',

    --ESSES CLASSIFICADORES SAO UTILIZADOS SOMENTE POR LANCAMENTO MANUAL FINANCEIRO FINA050
    RTRIM(SE2010.E2_CCD) AS 'C CUSTO DEB',
    RTRIM(SE2010.E2_CONTAD) AS 'CONTA CONTABIL',

    --IDENTIFICACAO DO USUARIO QUE PROVOCOU O LANCAMENTO NO CONTAS A PAGAR
    RTRIM(SE2010.E2_USERID) AS 'USUARIO ID',
    RTRIM(USUARIOS.NOME) AS 'USUARIO NOME',
    RTRIM(SE2010.E2_INFCOMP) AS 'INFO COMPLEMENTAR'
FROM PROTHEUS.dbo.SE2010 SE2010
    LEFT JOIN PROTHEUS.dbo.SA2010 SA2010 WITH (NOLOCK) ON SE2010.E2_FORNECE=SA2010.A2_COD AND SE2010.E2_LOJA=SA2010.A2_LOJA AND SA2010.D_E_L_E_T_<>'*' --CADASTRO DE FORNECEDOR
    LEFT JOIN USUARIOS WITH (NOLOCK) ON USUARIOS.USERID=SE2010.E2_USERID --CADASTRO DE USUARIOS DO PROTHEUS
    LEFT JOIN PROTHEUS.dbo.SED010 SED010 WITH (NOLOCK) ON SE2010.E2_NATUREZ=SED010.ED_CODIGO AND SA2010.D_E_L_E_T_<>'*' --CADASTRO DE NATUREZAS
--     LEFT JOIN PROTHEUS.dbo.SD1010 SD1010 WITH (NOLOCK) ON --CADASTRO DE PRE-NOTAS
--         SE2010.E2_FILORIG = SD1010.D1_FILIAL AND
--         SE2010.E2_NUM = SD1010.D1_DOC AND
--         SE2010.E2_FORNECE = SD1010.D1_FORNECE AND
--         SE2010.E2_LOJA = SD1010.D1_LOJA AND
--         SE2010.E2_PREFIXO = SD1010.D1_SERIE AND
--         SD1010.D_E_L_E_T_<>'*'
--             LEFT JOIN PROTHEUS.dbo.SC7010 SC7010 WITH (NOLOCK) ON --CADASTRO DE PEDIDOS DE COMPRAS
--                 SD1010.D1_FILIAL = SC7010.C7_FILIAL AND
--                 SD1010.D1_PEDIDO = SC7010.C7_NUM AND
--                 SD1010.D1_ITEMPC = SC7010.C7_ITEM AND
--                 SD1010.D1_FORNECE = SC7010.C7_FORNECE AND
--                 SD1010.D1_LOJA = SC7010.C7_LOJA AND
--                 SC7010.D_E_L_E_T_<>'*'
--                     LEFT JOIN PROTHEUS.dbo.SC1010 SC1010 WITH (NOLOCK) ON --CADASTRO DE SOLICITACOES DE COMPRA
--                         SC7010.C7_NUMSC = SC1010.C1_NUM AND
--                         SC7010.C7_ITEMSC = SC1010.C1_ITEM AND
--                         SC7010.C7_FILIAL = SC1010.C1_FILIAL AND
--                         SC1010.D_E_L_E_T_<>'*'
WHERE
    SE2010.D_E_L_E_T_<>'*' AND --RETIRA LINHAS DELETADAS
    RTRIM(SE2010.E2_ORIGEM) NOT IN ('CADSZV', 'INTENDIC','MATA460') AND --RETIRA MODULOS NAO DESEJADOS
    LEFT(SE2010.E2_EMIS1, 4) >='2020'

    --POSSIVEIS EXEMPLOS DE FATURAS: 1391677 --PAGAMENTO EM ATRASO CONVERTIDO EM FATURA
    --POSSIVEIS EXEMPLOS DE FATURAS: 14255254
--     AND (
--         RTRIM(SE2010.E2_NUM)='3436564' OR
--         RTRIM(SE2010.E2_FATURA)='3436564'
--     )

    --DUVIDAS: O TITULO 000197430 TEM BORDERO MAS NAO TEM VAL LIQ BAIXADO



--     AND RTRIM(SE2010.E2_ORIGEM)='MATA460'
--     SE2010.E2_SALDO>0 AND
--       SE2010.E2_TIPO <> 'PA'


--**TITULOS QUE SOFRERAM FATURA**
-- AND SE2.E2_TIPO <> 'TX'
-- AND SE2FAT.E2_FATURA <> ''
-- AND LEFT(SE2.E2_ORIGEM, 4) <> 'MATA'


--**TITULOS QUE NAO SOFRERAM FATURA**
-- AND (SE2.E2_FATURA = '' OR SE2.E2_FATURA = 'NOTFAT')
-- AND LEFT(SE2.E2_ORIGEM, 4) = 'MATA'


--**TITULOS DIRETO NO FINANCEIRO QUE NAO SOFRERAM FATURA**
-- AND E2_FATURA = ''
-- AND (LEFT(SE2.E2_ORIGEM, 4) <> ('MATA') AND SE2.E2_ORIGEM NOT IN ('FINA565','FINA290'))


--**TITULOS DIRETO NO FINANCEIRO QUE SOFRERAM FATURA**
-- AND (SE2FAT.E2_FATURA = 'NOTFAT' OR SE2FAT.E2_FATURA = '')
-- AND SE2FAT.E2_ORIGEM IN ('FINA290','FINA565')
-- AND SUBSTRING(SE2.E2_ORIGEM, 1, 4) <> 'MATA'

ORDER BY
    SE2010.R_E_C_N_O_ DESC --ORGANIZA POR ULTIMAS ENTRADAS

--???EXISTEM LANÇAMENTOS NO CONTAS A PAGAR SEM COD DE FORNECEDOR
--SE2010.E2_FORNECE = ''

--???O QUE É UM REGISTRO SEM ORIGEM?
--SE2010.E2_ORIGEM = ''