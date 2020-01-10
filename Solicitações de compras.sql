SELECT
	--IDENTIFICAÇÃO LOCAL
	SC1010.C1_FILIAL AS 'FILIAL',
	SC1010.C1_LOCAL AS 'ARMAZÉM',
	RTRIM(CONCAT(SC1010.C1_FILIAL, SC1010.C1_LOCAL, ' - ', Z01010.Z01_DESC)) AS 'DESCRIÇÃO ARMAZÉM',

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
			WHEN SC1010.C1_FILIAL = '09' AND SC1010.C1_LOCAL = '40'	THEN 'COELCE'
			WHEN SC1010.C1_FILIAL = '09' AND SC1010.C1_LOCAL = '30'	THEN 'COELCE'
			WHEN SC1010.C1_FILIAL = '07' AND SC1010.C1_LOCAL = '55'	THEN 'AMPLA'
		    WHEN SC1010.C1_FILIAL = '07' AND SC1010.C1_LOCAL = '56'	THEN 'AMPLA'
		    WHEN SC1010.C1_FILIAL = '02' AND SC1010.C1_LOCAL = '50'	THEN 'BENGUI'
		    WHEN SC1010.C1_FILIAL = '02' AND SC1010.C1_LOCAL = '52'	THEN 'IP BELEM'
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
	SC1010.C1_ITEM AS 'ITEM',
	SC1010.C1_PRODUTO AS 'CODIGO',
	RTRIM(SC1010.C1_DESCRI) AS 'DESCRIÇÃO',
	SC1010.C1_UM AS 'UND',
	SC1010.C1_QUANT AS 'QTDE',
	SC1010.C1_QTDORIG as 'QTD ORIGINAL',
	SC1010.C1_VLESTIM AS 'VAL UND',
	SC1010.C1_VTOTAL AS 'VAL TOTAL',
	RTRIM(SC1010.C1_OBS) AS 'OBSERVAÇÃO',
	SC1010.C1_USER AS 'COD SOLICITANTE SC',
	RTRIM(SC1010.C1_SOLICIT) AS 'NOME SOLICITANTE SC',
	SC1010.C1_CODCOMP AS 'COD COMPRADOR SC',
	RTRIM(SY1010.Y1_NOME) AS 'NOME COMPRADOR SC',
	SC1010.C1_HORINCL AS 'HORA INCLUSÃO',
	LEFT(SC1010.C1_HORINCL, 2) AS 'INTERVALO HORA',
	SC1010.C1_QUJE2 AS 'QT SEG PED',
	SC1010.C1_VUNIT AS 'PRC UNITARIO',
	SC1010.C1_PRECO AS 'PRC UND',

	--CONDIÇÃO DA COMPRA
	--SC1010.C1_TOTSC AS 'VAL TOTAL SC', --**NÃO NECESSÁRIO**
	SC1010.C1_QUJE AS 'QTDE EM PC',
	SC1010.C1_QUJE*SC1010.C1_VLESTIM AS 'VAL ATENDIDO',
	(SC1010.C1_QUANT-SC1010.C1_QUJE) AS 'QTDE FALTA',
	(SC1010.C1_QUANT-SC1010.C1_QUJE)*SC1010.C1_VLESTIM AS 'VAL FALTA',
	SC1010.C1_PEDIDO AS 'NUM PC',
	SC1010.C1_ITEMPED AS 'ITEM PC',

	--INFORMAÇÃO FORNECEDOR SUGERIDO
	SC1010.C1_FORNECE AS 'FORNECEDOR INDICADO',
	SC1010.C1_LOJA AS 'LOJA',
	RTRIM(SA2010.A2_NOME) AS 'NOME FORNECEDOR INDICADO',

	--CLASSIFICADORES DO PROCESSO
	CASE
		WHEN SC1010.C1_QUJE=0 THEN 'FALTA'
		WHEN SC1010.C1_QUJE<SC1010.C1_QUANT THEN 'PARCIAL'
		WHEN SC1010.C1_QUJE=SC1010.C1_QUANT THEN 'COMPRADO'
		ELSE 'ERRO'
	END AS 'SITUAÇÃO PROCESSO',
	CASE
		WHEN SC1010.C1_CC = '          ' THEN 'PARA ARMAZÉM'
		ELSE 'APLICAÇÃO DIRETA'
	END AS 'TIPO DE COMPRA',
	CASE WHEN SC1010.C1_CLVL = '001      ' THEN 'INVESTIMENTO' ELSE 'CUSTO' END AS 'INVEST-CUST',
	CASE WHEN SC1010.C1_TPCOMPR='2' THEN 'APLICAÇÃO DIRETA' WHEN SC1010.C1_TPCOMPR='1' THEN 'ESTOQUE' END AS 'TIPO DE COMPRA 2',
	CASE WHEN SC1010.C1_RESIDUO = ' ' THEN 'NÃO' ELSE 'SIM'  END AS 'ELIMINADO POR RESÍDUO?',
	CASE WHEN SC1010.C1_APROV = 'B' THEN 'BLOQUEADA' WHEN SC1010.C1_APROV = 'L' THEN 'LIBERADA' ELSE 'REJEITADA'  END AS 'SC APROVADA?',

	--CONTAS CLASSIFICADORAS
	RTRIM((
		SELECT SX5010.X5_DESCRI
		FROM PROTHEUS.dbo.SX5010 SX5010
		WHERE X5_TABELA='02' AND SX5010.X5_CHAVE=SB1010.B1_TIPO
	)) AS 'DESCRIÇÃO TIPO DO PRODUTO',
	RTRIM(BM_TIPGRU+' - '+
	(
		SELECT SX5010.X5_DESCRI
		FROM PROTHEUS.dbo.SX5010 SX5010
		WHERE X5_TABELA='V0' AND SX5010.X5_CHAVE=BM_TIPGRU
	)) AS 'DESCRIÇÃO TIPO DE GRUPO',
	SB1010.B1_GRUPO AS 'COD GRUPO',
	RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO',
	SC1010.C1_CC AS 'CENTRO DE CUSTO',
	CASE WHEN SC1010.C1_CC = '          ' THEN 'PROCESSO PARA ARMAZÉM' ELSE RTRIM(CTT010.CTT_DESC01) END AS 'DESCRIÇÃO CENTRO DE CUSTO',
	SC1010.C1_CONTA AS 'CONTA CONTÁBIL',
	CASE WHEN SC1010.C1_CONTA = '                    ' THEN 'ATIVO FIXO' ELSE RTRIM(CT1010.CT1_DESC01) END AS 'DESC CONT CONTÁBIL',
	SC1010.C1_ITEMCTA AS 'CARRO',
	RTRIM(SC1010.C1_ITEMCTA+' - '+CTD010.CTD_DESC01) AS 'DESC CARRO',
	RTRIM(SC1010.C1_CLVL) AS 'OBRA/PROJETO',
	CASE
		WHEN RTRIM(SC1010.C1_CLVL) = '001' THEN 'MOBILIZAÇÃO'
		WHEN RTRIM(SC1010.C1_CLVL) = '002' THEN 'DESMOBILIZAÇÃO'
		WHEN RTRIM(SC1010.C1_CLVL) = '003' THEN 'REEMBOLSO'
		WHEN RTRIM(SC1010.C1_CLVL) = '004' THEN 'RESSUP PROG'
		WHEN RTRIM(SC1010.C1_CLVL) = '005' THEN 'RESSUP EMERG'
		ELSE 'OUTROS'
	END AS 'TIPO OBRA',
	RTRIM(SC1010.C1_CLVL)+' - '+RTRIM(CTH010.CTH_DESC01) AS 'DESC OBRA/PROJETO',

	--APROVADORES
	SC1010.C1_APROV1 AS 'APROVADOR 1',
	SC1010.C1_APROV2 AS 'APROVADOR 2',
	SC1010.C1_APROV3 AS 'APROVADOR 3',
	SC1010.C1_APROV4 AS 'APROVADOR 4',
	SC1010.C1_APROV5 AS 'APROVADOR 5',
	SC1010.C1_APROV6 AS 'APROVADOR 6',
	SC1010.C1_APROV7 AS 'APROVADOR 7',

	--CONTROLE DE ALTERAÇÃO
	RTRIM(SC1010.C1_ALTMOT) AS 'MOT ALT',
	RTRIM(SC1010.C1_MOTIVO) AS 'MOTIVO DE REJEIÇÃO',
	SC1010.C1_FILENT AS 'FILIAL DE ENTREGA',
	RTRIM(SC1010.C1_MOTRET) AS 'MOT DEV COMP',
	Case RTrim(Coalesce(SC1010.C1_DTDEVIT,'')) WHEN ''  THEN Null ELSE convert(datetime, SC1010.C1_DTDEVIT, 112)END AS 'DT DEV ITEM',

	--DATAS DO PROCESSO
	Case RTrim(Coalesce(SC1010.C1_DATPRF,'')) WHEN ''  THEN Null ELSE convert(datetime, SC1010.C1_DATPRF, 112)END AS 'DT NECESSIDADE',
	Case RTrim(Coalesce(SC1010.C1_DTLIB1,'')) WHEN ''  THEN Null ELSE convert(datetime, SC1010.C1_DTLIB1, 112)END AS 'DT LIBERADO1',
	Case RTrim(Coalesce(SC1010.C1_DTLIB2,'')) WHEN ''  THEN Null ELSE convert(datetime, SC1010.C1_DTLIB2, 112)END AS 'DT LIBERADO2',
	Case RTrim(Coalesce(SC1010.C1_DTLIB3,'')) WHEN ''  THEN Null ELSE convert(datetime, SC1010.C1_DTLIB3, 112)END AS 'DT LIBERADO3',
	Case RTrim(Coalesce(SC1010.C1_DTLIB4,'')) WHEN ''  THEN Null ELSE convert(datetime, SC1010.C1_DTLIB4, 112)END AS 'DT LIBERADO4',
	Case RTrim(Coalesce(SC1010.C1_DTLIB5,'')) WHEN ''  THEN Null ELSE convert(datetime, SC1010.C1_DTLIB5, 112)END AS 'DT LIBERADO5',
	Case RTrim(Coalesce(SC1010.C1_DTLIB6,'')) WHEN ''  THEN Null ELSE convert(datetime, SC1010.C1_DTLIB6, 112)END AS 'DT LIBERADO6',
	Case RTrim(Coalesce(SC1010.C1_DTLIB7,'')) WHEN ''  THEN Null ELSE convert(datetime, SC1010.C1_DTLIB7, 112)END AS 'DT LIBERADO7',
	Case RTrim(Coalesce(SC1010.C1_EMISSAO,'')) WHEN ''  THEN Null ELSE convert(datetime, SC1010.C1_EMISSAO, 112)END AS 'DT EMISSÃO',
	Case RTrim(Coalesce(SC1010.C1_ALTDATA,'')) WHEN ''  THEN Null ELSE convert(datetime, SC1010.C1_ALTDATA, 112)END AS 'DT ALT',

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

	--GETDATE()

	--MARCADORES DE APROVAÇÃO DO PROCESSO
	SC1010.C1_LIBOK1 AS 'LIBERADO 1',
	SC1010.C1_LIBOK2 AS 'LIBERADO 2',
	SC1010.C1_LIBOK3 AS 'LIBERADO 3',
	SC1010.C1_LIBOK4 AS 'LIBERADO 4',
	SC1010.C1_LIBOK5 AS 'LIBERADO 5',
	SC1010.C1_LIBOK6 AS 'LIBERADO 6',
	SC1010.C1_LIBOK7 AS 'LIBERADO 7',

	--CONEXÃO COM TABELA DE PC
	--CASE WHEN SC7010.C7_USER='000044' THEN 'SILAS' WHEN SC7010.C7_USER='000053' THEN 'NILO' ELSE 'OUTROS' END AS 'COMPRADOR DO PC',

	--CLASSIFICAÇÃO QUANTO A QUAL LOCAL COMPROU
	CASE
		WHEN (SY1010.Y1_USER IN ('000309','000044','000053','001193','001372','000238'))
			THEN 'COMPRAS'
		WHEN (SY1010.Y1_USER IN ('001041','000629','000069','001417','000148','000852','000896','000655','000224','000190','001036','000444','001481','000797','001067','000048'))
			THEN 'ADM'
		WHEN (SY1010.Y1_USER IN ('000769','000670','000335','000939','000347','000180','000178','000250','000092','000076','000536','000286','000692','000685','000319','000698','000962','000836','000628','001235','000816','000583','000620','000466','000900','000118','001048','001214', '000679', '001519','000216','001353','001362','000892','000815','001212','000554','000485','000663','001136','001042','000262','000937','000364','000567','001281','001391','001337','000246','001433','000894','001540','001328','000316','000993','000370','000376','000807','000306','000301','001506','000208','000571','000917','001562','000720','001329','001468','000435','001368','000283','000401'))
			THEN 'LOCAL'
		WHEN (SY1010.Y1_USER IN ('001485','001146','000767','000535', '000070','000045','000000','000646','001494','001039','000226','001520','001165','001480','001211','000932','000050','000215','001145','000902','001280','000593','001161','001073','000578'))
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
		WHEN (SC1010.C1_CC = '' AND SC1010.C1_CLVL <> '001') THEN 'ESTOQUE - CONSUMO OPERACIONAL'
		WHEN SC1010.C1_CLVL = '001' THEN 'INVESTIMENTO - MOBILIZAÇÕES'
		WHEN SC1010.C1_CC <> '' AND CTT010.CTT_TPCC = 'O' THEN 'APLICAÇÃO DIRETA - CUSTEIO OPERACIONAL'
		WHEN SC1010.C1_CC <> '' AND CTT010.CTT_TPCC = 'C' THEN 'APLICAÇÃO DIRETA - DESPESAS CORPORATIVAS'
		ELSE 'ERRO: CLASSIFICAR'
	END AS 'TIPO DE GASTO'

FROM PROTHEUS.dbo.SC1010 SC1010 WITH (NOLOCK)
	LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 WITH (NOLOCK) ON (Z01010.Z01_FILIAL = SC1010.C1_FILIAL) AND (Z01010.Z01_COD = SC1010.C1_LOCAL) AND Z01010.D_E_L_E_T_<>'*'
	LEFT JOIN PROTHEUS.dbo.CTT010 CTT010 WITH (NOLOCK) ON SC1010.C1_CC=CTT010.CTT_CUSTO AND CTT010.D_E_L_E_T_<>'*'
	LEFT JOIN PROTHEUS.dbo.CT1010 CT1010 WITH (NOLOCK) ON SC1010.C1_CONTA=CT1010.CT1_CONTA AND CT1010.D_E_L_E_T_<>'*'
	LEFT JOIN PROTHEUS.dbo.CTH010 CTH010 WITH (NOLOCK) ON SC1010.C1_CLVL=CTH010.CTH_CLVL AND CTH010.D_E_L_E_T_<>'*'
	LEFT JOIN PROTHEUS.dbo.CTD010 CTD010 WITH (NOLOCK) ON SC1010.C1_ITEMCTA=CTD010.CTD_ITEM AND CTD010.D_E_L_E_T_<>'*'
	LEFT JOIN PROTHEUS.dbo.SY1010 SY1010 WITH (NOLOCK) ON SC1010.C1_CODCOMP=SY1010.Y1_COD AND SY1010.D_E_L_E_T_<>'*'
	LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 WITH (NOLOCK) ON SC1010.C1_PRODUTO=SB1010.B1_COD AND SB1010.D_E_L_E_T_<>'*'
	LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 WITH (NOLOCK) ON SB1010.B1_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_<>'*'
	LEFT JOIN PROTHEUS.dbo.SA2010 SA2010 WITH (NOLOCK) ON SA2010.A2_COD=SC1010.C1_FORNECE AND SA2010.A2_LOJA=SC1010.C1_LOJA AND SA2010.D_E_L_E_T_<>'*'
	--LEFT JOIN PROTHEUS.dbo.SC7010 SC7010 WITH (NOLOCK) ON (SC1010.C1_PEDIDO=SC7010.C7_NUM AND SC1010.C1_ITEMPED=SC7010.C7_ITEM) AND SC7010.D_E_L_E_T_<>'*'

WHERE
	(SC1010.D_E_L_E_T_<>'*')
	AND (SC1010.C1_EMISSAO>='20190101' AND SC1010.C1_EMISSAO<=GETDATE())
	--GRUPOS QUE NÃO PERTENCEM À ANÁLISE (GERALMENTE PARTENCENTES AO RH)
	AND (SB1010.B1_GRUPO NOT IN ('0710','0093','0095','0096','1211','3000','3001','3002','3003','3004','3005','3006','3007','3050','3058','3060','3061'))
-- 	AND (SC1010.C1_RESIDUO = ' ')
 	AND (SC1010.C1_QUJE<SC1010.C1_QUANT)
	-- AND (SC1010.C1_FILIAL = '12')
	-- AND (SC1010.C1_LOCAL = '90')
	-- AND (SC1010.C1_APROV='L') --OR SC1010.C1_APROV='B')
	AND (SC1010.C1_CC = '         ') --PARA ESTOQUE
	-- AND (SY1010.Y1_NOME like '%NILO%' OR SY1010.Y1_NOME like '%SILAS%')
	-- AND SC1010.C1_CLVL <> '001'
ORDER BY
	SC1010.C1_NUM, SC1010.C1_ITEM DESC
