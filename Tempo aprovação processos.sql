WITH APROVACOES AS (
	SELECT
		--IDENTIFICAÇÃO LOCAL
		SC1010.C1_FILIAL AS 'FILIAL', 
		SC1010.C1_LOCAL AS 'ARMAZÉM',
		RTRIM(SC1010.C1_FILIAL+SC1010.C1_LOCAL+' - '+Z01010.Z01_DESC) AS 'DESCRIÇÃO ARMAZÉM',
		
		--IDENTIFICA LOCAL CASO TENHA CENTRO DE CUSTO
		ISNULL(REPLACE(RTRIM(CTT010.CTT_XREGIO),'_',' '),
			CASE
				WHEN SC1010.C1_FILIAL = '02' AND SC1010.C1_LOCAL = '22'	THEN 'IP BELEM'
				WHEN SC1010.C1_FILIAL = '07' AND SC1010.C1_LOCAL = '40'	THEN 'AMPLA'
				WHEN SC1010.C1_FILIAL = '12' AND SC1010.C1_LOCAL = '92'	THEN 'IP SANTAREM'
				WHEN SC1010.C1_FILIAL = '13' AND SC1010.C1_LOCAL = '95'	THEN 'COELBA'
				WHEN SC1010.C1_FILIAL = '09' AND SC1010.C1_LOCAL = '63'	THEN 'COELCE'
				WHEN SC1010.C1_FILIAL = '02' AND SC1010.C1_LOCAL = '11'	THEN 'BENGUI'
				WHEN SC1010.C1_FILIAL = '13' AND SC1010.C1_LOCAL = '03'	THEN 'COELBA'
				WHEN SC1010.C1_FILIAL = '02' AND SC1010.C1_LOCAL = '16'	THEN 'BENGUI'
				WHEN SC1010.C1_FILIAL = '12' AND SC1010.C1_LOCAL = '91'	THEN 'IP SANTAREM'
				WHEN SC1010.C1_FILIAL = '12' AND SC1010.C1_LOCAL = '90'	THEN 'CELPA CENTRO OESTE'
				WHEN SC1010.C1_FILIAL = '02' AND SC1010.C1_LOCAL = '01'	THEN 'BENGUI'
				WHEN SC1010.C1_FILIAL = '02' AND SC1010.C1_LOCAL = '21'	THEN 'IP BELEM'
				WHEN SC1010.C1_FILIAL = '02' AND SC1010.C1_LOCAL = '39'	THEN 'IP BELEM'
				WHEN SC1010.C1_FILIAL = '12' AND SC1010.C1_LOCAL = '94'	THEN 'CELPA OESTE'
				WHEN SC1010.C1_FILIAL = '02' AND SC1010.C1_LOCAL = '25'	THEN 'CELPA NORDESTE'
				WHEN SC1010.C1_FILIAL = '10' AND SC1010.C1_LOCAL = '03'	THEN 'CELG'
				WHEN SC1010.C1_FILIAL = '13' AND SC1010.C1_LOCAL = '96'	THEN 'COELBA'
				WHEN SC1010.C1_FILIAL = '13' AND SC1010.C1_LOCAL = '05'	THEN 'COELBA'
				WHEN SC1010.C1_FILIAL = '02' AND SC1010.C1_LOCAL = '18'	THEN 'CELPA NORDESTE'
				WHEN SC1010.C1_FILIAL = '12' AND SC1010.C1_LOCAL = '89'	THEN 'IP SANTAREM'
				WHEN SC1010.C1_FILIAL = '13' AND SC1010.C1_LOCAL = '04'	THEN 'COELBA'
				WHEN SC1010.C1_FILIAL = '09' AND SC1010.C1_LOCAL = '75'	THEN 'COELCE'
				WHEN SC1010.C1_FILIAL = '09' AND SC1010.C1_LOCAL = '65'	THEN 'COELCE'
				WHEN SC1010.C1_FILIAL = '09' AND SC1010.C1_LOCAL = '82'	THEN 'COELCE'
				WHEN SC1010.C1_FILIAL = '10' AND SC1010.C1_LOCAL = '04'	THEN 'CELG'
				WHEN SC1010.C1_FILIAL = '07' AND SC1010.C1_LOCAL = '43'	THEN 'AMPLA'
				WHEN SC1010.C1_FILIAL = '07' AND SC1010.C1_LOCAL = '53'	THEN 'AMPLA'
				WHEN SC1010.C1_FILIAL = '09' AND SC1010.C1_LOCAL = '59'	THEN 'COELCE'
				ELSE 'ERRO'
			END
		) AS 'REGIONAL',
		
		ISNULL(IIF(
			REPLACE(REPLACE(RTRIM(CTT_XPOLO),'_',' '),'POLO ', '')=REPLACE(RTRIM(CTT010.CTT_XREGIO),'_',' '),
			REPLACE(REPLACE(RTRIM(CTT_XPOLO),'_',' '),'POLO ', ''),
			REPLACE(REPLACE(REPLACE(RTRIM(CTT_XPOLO),'_',' '),'POLO ', ''), REPLACE(RTRIM(CTT010.CTT_XREGIO),'_',' ')+' ', '')
		),'ESTOQUE') AS 'POLO',
		
		--DADOS SC
		SC1010.C1_NUM AS 'NUM SC', 
		SC1010.C1_ITEM AS 'ITENS', 
		SC1010.C1_VTOTAL AS 'VAL TOTAL', 
		RTRIM(SC1010.C1_OBS) AS 'OBSERVAÇÃO',
		RTRIM(SC1010.C1_SOLICIT) AS 'NOME SOLICITANTE SC',
		RTRIM(SY1010.Y1_NOME) AS 'NOME COMPRADOR SC',
		
		--CLASSIFICADORES DO PROCESSO
		CASE
			WHEN SC1010.C1_CC = '          ' THEN 'PARA ARMAZÉM'
			ELSE 'APLICAÇÃO DIRETA'
		END AS 'TIPO DE COMPRA',
		CASE WHEN SC1010.C1_CLVL = '001' THEN 'INVESTIMENTO' WHEN SC1010.C1_CLVL = '004' THEN 'RESSUPRIMENTO' ELSE 'CUSTO' END AS 'INVEST-CUST', 
		
		--CONTAS CLASSIFICADORAS
		CASE WHEN SC1010.C1_CC = '          ' THEN 'PROCESSO PARA ARMAZÉM' ELSE RTRIM(SC1010.C1_CC)+'-'+RTRIM(CTT010.CTT_DESC01) END AS 'DESCRIÇÃO CENTRO DE CUSTO', 
		CASE WHEN SC1010.C1_CONTA = '                    ' THEN 'ATIVO FIXO' ELSE RTRIM(CT1010.CT1_DESC01) END AS 'DESC CONT CONTÁBIL',
		
		--DATAS DO PROCESSO
		Case RTrim(Coalesce(SC1010.C1_EMISSAO,'')) WHEN ''  THEN Null ELSE convert(datetime, SC1010.C1_EMISSAO, 112)END AS 'DT EMISSÃO',
		Case RTrim(Coalesce(SC1010.C1_ALTDATA,'')) WHEN ''  THEN Null ELSE convert(datetime, SC1010.C1_ALTDATA, 112)END AS 'DT ALT',
		CONVERT(DATETIME, IIF(SC1010.C1_ALTDATA>SC1010.C1_EMISSAO, SC1010.C1_ALTDATA, SC1010.C1_EMISSAO), 112) AS 'INICIO PROCESSO',
		Case RTrim(Coalesce(SC1010.C1_DTLIB1,'')) WHEN ''  THEN Null ELSE convert(datetime, SC1010.C1_DTLIB1, 112)END AS 'DT LIBERADO1',
		Case RTrim(Coalesce(SC1010.C1_DTLIB2,'')) WHEN ''  THEN Null ELSE convert(datetime, SC1010.C1_DTLIB2, 112)END AS 'DT LIBERADO2',
		Case RTrim(Coalesce(SC1010.C1_DTLIB3,'')) WHEN ''  THEN Null ELSE convert(datetime, SC1010.C1_DTLIB3, 112)END AS 'DT LIBERADO3',
		Case RTrim(Coalesce(SC1010.C1_DTLIB4,'')) WHEN ''  THEN Null ELSE convert(datetime, SC1010.C1_DTLIB4, 112)END AS 'DT LIBERADO4',
		Case RTrim(Coalesce(SC1010.C1_DTLIB5,'')) WHEN ''  THEN Null ELSE convert(datetime, SC1010.C1_DTLIB5, 112)END AS 'DT LIBERADO5',
		Case RTrim(Coalesce(SC1010.C1_DTLIB6,'')) WHEN ''  THEN Null ELSE convert(datetime, SC1010.C1_DTLIB6, 112)END AS 'DT LIBERADO6',
		Case RTrim(Coalesce(SC1010.C1_DTLIB7,'')) WHEN ''  THEN Null ELSE convert(datetime, SC1010.C1_DTLIB7, 112)END AS 'DT LIBERADO7',
			
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
		
		--APROVADORES
		SC1010.C1_APROV1 AS 'APROVADOR 1', 
		SC1010.C1_APROV2 AS 'APROVADOR 2', 
		SC1010.C1_APROV3 AS 'APROVADOR 3', 
		SC1010.C1_APROV4 AS 'APROVADOR 4', 
		SC1010.C1_APROV5 AS 'APROVADOR 5', 
		SC1010.C1_APROV6 AS 'APROVADOR 6', 
		SC1010.C1_APROV7 AS 'APROVADOR 7',
		
		SC1010.C1_LIBOK1 AS 'APROVACAO 1',
		SC1010.C1_LIBOK2 AS 'APROVACAO 2',
		SC1010.C1_LIBOK3 AS 'APROVACAO 3',
		SC1010.C1_LIBOK4 AS 'APROVACAO 4',
		SC1010.C1_LIBOK5 AS 'APROVACAO 5',
		SC1010.C1_LIBOK6 AS 'APROVACAO 6',
		SC1010.C1_LIBOK7 AS 'APROVACAO 7',
		
		--QUANTIDADE DE APROVADORES
		(
			SELECT COUNT(*)
			FROM (VALUES (SC1010.C1_APROV1),(SC1010.C1_APROV2),(SC1010.C1_APROV3),(SC1010.C1_APROV4),(SC1010.C1_APROV5),(SC1010.C1_APROV6),(SC1010.C1_APROV7)) AS V(COL) 
			WHERE V.COL <> ' ' --IS NOT NULL
		) AS 'QT APROVADORES',
		
		--QUANTIDADE DE APROVAÇÕES
		(
			SELECT COUNT(*)
			FROM (VALUES (SC1010.C1_LIBOK1),(SC1010.C1_LIBOK2),(SC1010.C1_LIBOK3),(SC1010.C1_LIBOK4),(SC1010.C1_LIBOK5),(SC1010.C1_LIBOK6),(SC1010.C1_LIBOK7)) AS V(COL) 
			WHERE V.COL <> ' ' --IS NOT NULL
		) AS 'QT APROVACOES',
		
		--CLASSIFICAÇÃO QUANTO A QUAL LOCAL COMPROU
		CASE
			WHEN (SY1010.Y1_USER IN ('000044','000053','001193','001372','000238'))
				THEN 'COMPRAS'
			WHEN (SY1010.Y1_USER IN ('001041','000629','000069','001417','000148','000852','000896','000655','000224','000190','001036','000444','001481','000797','001067','000048'))
				THEN 'ADM'
			WHEN (SY1010.Y1_USER IN ('000335','000939','000347','000180','000178','000250','000092','000076','000536','000286','000692','000685','000319','000698','000962','000836','000628','001235','000816','000583','000620','000466','000900','000118','001048','001214', '000679', '001519','000216','001353','001362','000892','000815','001212','000554','000485','000663','001136','001042','000262','000937','000364','000567','001281','001391','001337','000246','001433','000894','001540','001328','000316','000993','000370','000376','000807','000306','000301','001506','000208','000571','000917','001562','000720','001329','001468','000435','001368','000283','000401'))
				THEN 'LOCAL'
			WHEN (SY1010.Y1_USER IN ('000535', '000070','000045','000000','000646','001494','001039','000226','001520','001165','001480','001211','000932','000050','000215','001145','000902','001280','000593','001161','001073','000578'))
				THEN 'MATRIZ - OUTROS'
			ELSE 'ERRO: CLASSIFICAR'
		END AS 'DPTO COMPRA',
		
		--CLASSIFICAÇÃO QUANTO A QUAL LOCAL É RESPONSÁVEL PELO PROCESSO
		CASE 
			WHEN SB1010.B1_GRUPO IN ('0780','4006','0716','0051','0050','1026','0229','0096','0211','0012','0013','0014','0052','0053','0054','0090','0091','0092','0093','0094','0095','0098','0099','1021','4004','4005','4010') 
				THEN 'FROTA' 
			WHEN SB1010.B1_GRUPO IN ('1027','0227','0226','0215','0254','0212','0050','0051','0130','0131','0132','0133','0250','0253','0255','0256','0257','4003','4008') 
				THEN 'SUPRIMENTOS' 
			WHEN SB1010.B1_GRUPO IN ('0982','0983','0984','0980','0985','0986','0981','0702','0781','1065','0758','0215','0253','0252','0251','0755','0223','0170','0171','0172','0173','0175','0176','0177','0216','0701','0709','0711','0712','0717','0718','0719','0740','0747','0748','0754','0756','0860','0861','0863','0864','0980','0982','0983','1020','4007','4009') 
				THEN 'ADMINISTRATIVO' 
			ELSE 'GERAL' 
		END AS 'DPTO RESPONSÁVEL',
		
		--CLASSIFICAÇÃO QUANTO AO TIPO DE GASTO
		CASE
			WHEN SC1010.C1_PRODUTO IN ('00130004', '00130002', '00130001') THEN 'FROTA - COMBUSTÍVEL'
			WHEN (SB1010.B1_GRUPO IN ('4004', '4005','4006', '4010') OR SC1010.C1_PRODUTO IN ('00526075','02550337','40030031','02550338','00510017','02550339')) THEN 'FROTA - VEICULOS'
			WHEN (SB1010.B1_GRUPO = '0014' OR BM_TIPGRU='MV') THEN 'FROTA - MATERIAIS VEICULARES'
			WHEN BM_TIPGRU='SV' THEN 'FROTA - SERVIÇOS VEICULARES'
			WHEN SB1010.B1_GRUPO = '1026' THEN 'FROTA - TRANSPORTE DE VEICULOS'
			WHEN SB1010.B1_GRUPO IN ('0982', '0984') THEN 'VIAGENS - REEMBOLSAVEIS'
			WHEN SB1010.B1_GRUPO IN ('0983', '0980', '0985', '0986', '0981') THEN 'VIAGENS - NÃO REEMBOLSAVEIS'
			WHEN SB1010.B1_GRUPO IN ('0740', '0861', '0863', '0864', '0719','1020', '0860') THEN 'UTILIDADES'
			WHEN SC1010.C1_PRODUTO = '10210001' THEN 'FRETES - REEMBOLSAVEIS'
			WHEN SB1010.B1_GRUPO IN ('1028', '1027', '1026') THEN 'FRETES - NÃO REEMBOLSAVEIS'
			WHEN (BM_TIPGRU IN ('SS','SV', 'FR', 'SG') OR (BM_TIPGRU = 'DG' AND LEFT(SB1010.B1_DESC,7)='SERVICO')) THEN 'SERVIÇOS TOMADOS'
			WHEN 
				(
					(SC1010.C1_CONTA = '') OR
					(LEFT(SC1010.C1_CONTA,3)='132')
				) THEN 'INVESTIMENTO - ATIVO FIXO'
			WHEN (SC1010.C1_CC = '' AND ((SC1010.C1_FILIAL='02' AND SC1010.C1_LOCAL IN ('21', '22')) OR (SC1010.C1_FILIAL='12' AND SC1010.C1_LOCAL IN ('91', '92')))) THEN 'ESTOQUE - INSUMOS PARA FATURAMENTO'
			WHEN (SC1010.C1_CC = '' AND SC1010.C1_CLVL = '001') THEN 'ESTOQUE - MOBILIZAÇÕES'
			WHEN (SC1010.C1_CC = '' AND SC1010.C1_CLVL = '004') THEN 'ESTOQUE - RESSUPRIMENTO PROG.'
			WHEN (SC1010.C1_CC = '' AND (SC1010.C1_CLVL <> '001' AND SC1010.C1_CLVL <> '004')) THEN 'ESTOQUE - CONSUMO OPERACIONAL'
			WHEN SC1010.C1_CLVL = '001' THEN 'INVESTIMENTO - MOBILIZAÇÕES'
			WHEN SC1010.C1_CC <> '' AND CTT010.CTT_TPCC = 'O' THEN 'APLICAÇÃO DIRETA - CUSTEIO OPERACIONAL'
			WHEN SC1010.C1_CC <> '' AND CTT010.CTT_TPCC = 'C' THEN 'APLICAÇÃO DIRETA - DESPESAS CORPORATIVAS'
			ELSE 'ERRO: CLASSIFICAR'
		END AS 'TIPO DE GASTO'

	FROM PROTHEUS.dbo.SC1010 SC1010
		LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON (Z01010.Z01_FILIAL = SC1010.C1_FILIAL) AND (Z01010.Z01_COD = SC1010.C1_LOCAL) AND Z01010.D_E_L_E_T_<>'*'
		LEFT JOIN PROTHEUS.dbo.CTT010 CTT010 ON SC1010.C1_CC=CTT010.CTT_CUSTO AND CTT010.D_E_L_E_T_<>'*'
		LEFT JOIN PROTHEUS.dbo.CT1010 CT1010 ON SC1010.C1_CONTA=CT1010.CT1_CONTA AND CT1010.D_E_L_E_T_<>'*'
		LEFT JOIN PROTHEUS.dbo.SY1010 SY1010 ON SC1010.C1_CODCOMP=SY1010.Y1_COD AND SY1010.D_E_L_E_T_<>'*'
		LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SC1010.C1_PRODUTO=SB1010.B1_COD AND SB1010.D_E_L_E_T_<>'*'
		LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SB1010.B1_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_<>'*'
	WHERE
		(SC1010.D_E_L_E_T_<>'*') 
		AND (SC1010.C1_EMISSAO>='20190101' AND SC1010.C1_EMISSAO<=GETDATE())
		--GRUPOS QUE NÃO PERTENCEM À ANÁLISE (GERALMENTE PARTENCENTES AO RH)
		--AND (SB1010.B1_GRUPO NOT IN ('0984', '0824', '0095', '0093', '0096', '1023', '0943', '3061','3058','1214','1221','1061','1220','3003','3001','1200','1219','0710','3002','0720','3004','3050','3006','0703','1024','0700','1218','1203','1211','1205','1202','1204','0752','3007','0820','0823','3005','0743','1206','0174','1022','3060','1213','1215','1208','3000','0825'))
		AND (SC1010.C1_RESIDUO = ' ')
		-- AND (SC1010.C1_QUJE=SC1010.C1_QUANT)
		-- AND (SC1010.C1_FILIAL = '12')
		-- AND (SC1010.C1_LOCAL = '90')
		AND (SC1010.C1_APROV='L') --OR SC1010.C1_APROV='B')
		-- AND (SC1010.C1_CC = '         ')
		-- AND (SY1010.Y1_NOME like '%NILO%' OR SY1010.Y1_NOME like '%SILAS%')
		-- AND SC1010.C1_CLVL <> '001'
		-- AND SY1010.Y1_USER IN ('000044','000053')
	-- ORDER BY
		-- SC1010.C1_NUM, SC1010.C1_ITEM DESC
), AP_AGG AS
(
	SELECT
		AP."FILIAL" AS 'FILIAL',
		AP."ARMAZÉM" AS 'ARMAZÉM',
		AP."DESCRIÇÃO ARMAZÉM" AS 'DESCRIÇÃO ARMAZÉM',
		AP."REGIONAL" AS 'REGIONAL',
		AP."POLO" AS 'POLO',
		AP."NUM SC" AS 'NUM SC',
		COUNT(AP."ITENS") AS 'QT ITENS',
		SUM(AP."VAL TOTAL") AS 'VAL TOTAL',
		MAX(AP."OBSERVAÇÃO") AS 'OBSERVAÇÃO',
		AP."NOME SOLICITANTE SC" AS 'NOME SOLICITANTE SC',
		AP."NOME COMPRADOR SC" AS 'NOME COMPRADOR SC',
		AP."TIPO DE COMPRA" AS 'TIPO DE COMPRA',
		AP."INVEST-CUST" AS 'INVEST-CUST',
		AP."DESCRIÇÃO CENTRO DE CUSTO" AS 'DESCRIÇÃO CENTRO DE CUSTO',
		AP."DT EMISSÃO" AS 'DT EMISSÃO',
		AP."DT ALT" AS 'DT ALT',
		AP."INICIO PROCESSO" AS 'INICIO PROCESSO',
		AP."DT LIBERADO1" AS 'DT LIBERADO1',
		AP."DT LIBERADO2" AS 'DT LIBERADO2',
		AP."DT LIBERADO3" AS 'DT LIBERADO3',
		AP."DT LIBERADO4" AS 'DT LIBERADO4',
		AP."DT LIBERADO5" AS 'DT LIBERADO5',
		AP."DT LIBERADO6" AS 'DT LIBERADO6',
		AP."DT LIBERADO7" AS 'DT LIBERADO7',
		AP."DT APROVAÇÃO SC" AS 'DT APROVAÇÃO SC',
		AP."TEMPO APROVA SC" AS 'TEMPO APROVA SC',
		AP."APROVADOR 1" AS 'APROVADOR 1',
		AP."APROVADOR 2" AS 'APROVADOR 2',
		AP."APROVADOR 3" AS 'APROVADOR 3',
		AP."APROVADOR 4" AS 'APROVADOR 4',
		AP."APROVADOR 5" AS 'APROVADOR 5',
		AP."APROVADOR 6" AS 'APROVADOR 6',
		AP."APROVADOR 7" AS 'APROVADOR 7',
		AP."QT APROVADORES" AS 'QT APROVADORES',
		AP."QT APROVACOES" AS 'QT APROVACOES',
		IIF(AP."APROVACAO 1"='S', DATEDIFF(DAY, AP."INICIO PROCESSO", AP."DT LIBERADO1"), NULL) AS 'TP APROV 1',
		IIF(AP."APROVACAO 2"='S', DATEDIFF(DAY, AP."DT LIBERADO1", AP."DT LIBERADO2"), NULL) AS 'TP APROV 2',
		IIF(AP."APROVACAO 3"='S', DATEDIFF(DAY, AP."DT LIBERADO2", AP."DT LIBERADO3"), NULL) AS 'TP APROV 3',
		IIF(AP."APROVACAO 4"='S', DATEDIFF(DAY, AP."DT LIBERADO3", AP."DT LIBERADO4"), NULL) AS 'TP APROV 4',
		IIF(AP."APROVACAO 5"='S', DATEDIFF(DAY, AP."DT LIBERADO4", AP."DT LIBERADO5"), NULL) AS 'TP APROV 5',
		IIF(AP."APROVACAO 6"='S', DATEDIFF(DAY, AP."DT LIBERADO5", AP."DT LIBERADO6"), NULL) AS 'TP APROV 6',
		IIF(AP."APROVACAO 7"='S', DATEDIFF(DAY, AP."DT LIBERADO6", AP."DT LIBERADO7"), NULL) AS 'TP APROV 7',
		AP."DPTO COMPRA" AS 'DPTO COMPRA',
		AP."TIPO DE GASTO" AS 'TIPO DE GASTO'
	FROM APROVACOES AS AP
	GROUP BY
		AP."FILIAL",
		AP."ARMAZÉM",
		AP."DESCRIÇÃO ARMAZÉM",
		AP."REGIONAL",
		AP."POLO",
		AP."NUM SC",
		AP."NOME SOLICITANTE SC",
		AP."NOME COMPRADOR SC",
		AP."TIPO DE COMPRA",
		AP."INVEST-CUST",
		AP."DESCRIÇÃO CENTRO DE CUSTO",
		AP."DT EMISSÃO",
		AP."DT ALT",
		AP."INICIO PROCESSO",
		AP."DT LIBERADO1",
		AP."DT LIBERADO2",
		AP."DT LIBERADO3",
		AP."DT LIBERADO4",
		AP."DT LIBERADO5",
		AP."DT LIBERADO6",
		AP."DT LIBERADO7",
		AP."DT APROVAÇÃO SC",
		AP."TEMPO APROVA SC",
		AP."APROVADOR 1",
		AP."APROVADOR 2",
		AP."APROVADOR 3",
		AP."APROVADOR 4",
		AP."APROVADOR 5",
		AP."APROVADOR 6",
		AP."APROVADOR 7",
		AP."QT APROVADORES",
		AP."QT APROVACOES",
		IIF(AP."APROVACAO 1"='S', DATEDIFF(DAY, AP."INICIO PROCESSO", AP."DT LIBERADO1"), NULL),
		IIF(AP."APROVACAO 2"='S', DATEDIFF(DAY, AP."DT LIBERADO1", AP."DT LIBERADO2"), NULL),
		IIF(AP."APROVACAO 3"='S', DATEDIFF(DAY, AP."DT LIBERADO2", AP."DT LIBERADO3"), NULL),
		IIF(AP."APROVACAO 4"='S', DATEDIFF(DAY, AP."DT LIBERADO3", AP."DT LIBERADO4"), NULL),
		IIF(AP."APROVACAO 5"='S', DATEDIFF(DAY, AP."DT LIBERADO4", AP."DT LIBERADO5"), NULL),
		IIF(AP."APROVACAO 6"='S', DATEDIFF(DAY, AP."DT LIBERADO5", AP."DT LIBERADO6"), NULL),
		IIF(AP."APROVACAO 7"='S', DATEDIFF(DAY, AP."DT LIBERADO6", AP."DT LIBERADO7"), NULL),
		AP."DPTO COMPRA",
		AP."TIPO DE GASTO"
	--ORDER BY AP."NUM SC" DESC
)

SELECT
	AP_AGG."APROVADOR 1",
	AP_AGG."NUM SC",
	AP_AGG."DT LIBERADO1",
	AP_AGG."TP APROV 1",
	'1-PRIMEIRO' AS 'ESCALA APROVADOR'
FROM AP_AGG
WHERE AP_AGG."DT LIBERADO1" IS NOT NULL

UNION ALL

SELECT
	AP_AGG."APROVADOR 2",
	AP_AGG."NUM SC",
	AP_AGG."DT LIBERADO2",
	AP_AGG."TP APROV 2",
	'2-SEGUNDO' AS 'ESCALA APROVADOR'
FROM AP_AGG
WHERE AP_AGG."DT LIBERADO2" IS NOT NULL

UNION ALL

SELECT
	AP_AGG."APROVADOR 3",
	AP_AGG."NUM SC",
	AP_AGG."DT LIBERADO3",
	AP_AGG."TP APROV 3",
	'3-TERCEIRO' AS 'ESCALA APROVADOR'
FROM AP_AGG
WHERE AP_AGG."DT LIBERADO3" IS NOT NULL

UNION ALL

SELECT
	AP_AGG."APROVADOR 4",
	AP_AGG."NUM SC",
	AP_AGG."DT LIBERADO4",
	AP_AGG."TP APROV 4",
	'4-QUARTO' AS 'ESCALA APROVADOR'
FROM AP_AGG
WHERE AP_AGG."DT LIBERADO4" IS NOT NULL

UNION ALL

SELECT
	AP_AGG."APROVADOR 5",
	AP_AGG."NUM SC",
	AP_AGG."DT LIBERADO5",
	AP_AGG."TP APROV 5",
	'5-QUINTO' AS 'ESCALA APROVADOR'
FROM AP_AGG
WHERE AP_AGG."DT LIBERADO5" IS NOT NULL

UNION ALL

SELECT
	AP_AGG."APROVADOR 6",
	AP_AGG."NUM SC",
	AP_AGG."DT LIBERADO6",
	AP_AGG."TP APROV 6",
	'6-SEXTO' AS 'ESCALA APROVADOR'
FROM AP_AGG
WHERE AP_AGG."DT LIBERADO6" IS NOT NULL

UNION ALL

SELECT
	AP_AGG."APROVADOR 7",
	AP_AGG."NUM SC",
	AP_AGG."DT LIBERADO7",
	AP_AGG."TP APROV 7",
	'7-SETIMO' AS 'ESCALA APROVADOR'
FROM AP_AGG
WHERE AP_AGG."DT LIBERADO7" IS NOT NULL