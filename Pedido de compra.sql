WITH DADOS_PC AS
	(
		SELECT
			SC7010.C7_FILIAL AS 'FILIAL',
			--SC7010.C7_XFILENT AS 'FIL ENTREGA',--**ESTRANHAMENTE TEM UM CAMPO REPETIDO DE FILIAL DE ENTREGA

			--*************************************************--
			--**                   ATENÇÃO                   **--
			--*************************************************--
			--ALTERNATIVA DE BY-PASS DO ERRO. O PROTHEUS NÃO ESTÁ
			--REGISTRANDO CORRETAMENTE A FILIAL E LOCAL ANTERIOR
			CASE 
				WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL
				ELSE SC7010.C7_XLOCENT
			END AS 'LOC ANTERIOR',
			--A AMARRAÇÃO ABAIXO É QUE SERIA A MELHOR ALTERNATIVA
			--SC7010.C7_XFILENT AS 'FIL ANTERIOR',
			--SC7010.C7_XLOCENT AS 'LOC ANTERIOR',
			--*************************************************--
			--**                   ATENÇÃO                   **--
			--*************************************************--

			SC7010.C7_FILENT AS 'FIL ENTREGA', --**ESTRANHAMENTE TEM UM CAMPO REPETIDO DE FILIAL DE ENTREGA
			SC7010.C7_LOCAL AS 'LOC ENTREGA',
			
			--IDENTIFICA LOCAL CASO TENHA CENTRO DE CUSTO
			ISNULL(REPLACE(RTRIM(CTT010.CTT_XREGIO),'_',' '),
				CASE
					WHEN SC7010.C7_FILIAL = '02' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '22'	THEN 'IP BELEM'
					WHEN SC7010.C7_FILIAL = '07' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '40'	THEN 'AMPLA'
					WHEN SC7010.C7_FILIAL = '12' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '92'	THEN 'IP SANTAREM'
					WHEN SC7010.C7_FILIAL = '13' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '95'	THEN 'COELBA'
					WHEN SC7010.C7_FILIAL = '09' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '63'	THEN 'COELCE'
					WHEN SC7010.C7_FILIAL = '02' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '11'	THEN 'BENGUI'
					WHEN SC7010.C7_FILIAL = '13' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '03'	THEN 'COELBA'
					WHEN SC7010.C7_FILIAL = '02' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '16'	THEN 'BENGUI'
					WHEN SC7010.C7_FILIAL = '12' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '91'	THEN 'IP SANTAREM'
					WHEN SC7010.C7_FILIAL = '12' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '90'	THEN 'CELPA CENTRO OESTE'
					WHEN SC7010.C7_FILIAL = '02' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '01'	THEN 'BENGUI'
					WHEN SC7010.C7_FILIAL = '02' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '21'	THEN 'IP BELEM'
					WHEN SC7010.C7_FILIAL = '02' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '39'	THEN 'IP BELEM'
					WHEN SC7010.C7_FILIAL = '12' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '94'	THEN 'CELPA OESTE'
					WHEN SC7010.C7_FILIAL = '02' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '25'	THEN 'CELPA NORDESTE'
					WHEN SC7010.C7_FILIAL = '10' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '03'	THEN 'CELG'
					WHEN SC7010.C7_FILIAL = '13' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '96'	THEN 'COELBA'
					WHEN SC7010.C7_FILIAL = '13' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '05'	THEN 'COELBA'
					WHEN SC7010.C7_FILIAL = '02' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '18'	THEN 'CELPA NORDESTE'
					WHEN SC7010.C7_FILIAL = '12' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '89'	THEN 'IP SANTAREM'
					WHEN SC7010.C7_FILIAL = '13' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '04'	THEN 'COELBA'
					WHEN SC7010.C7_FILIAL = '09' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '75'	THEN 'COELCE'
					WHEN SC7010.C7_FILIAL = '09' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '65'	THEN 'COELCE'
					WHEN SC7010.C7_FILIAL = '09' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '82'	THEN 'COELCE'
					WHEN SC7010.C7_FILIAL = '10' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '04'	THEN 'CELG'
					WHEN SC7010.C7_FILIAL = '07' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '43'	THEN 'AMPLA'
					WHEN SC7010.C7_FILIAL = '07' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '53'	THEN 'AMPLA'
					WHEN SC7010.C7_FILIAL = '09' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '59'	THEN 'COELCE'
					WHEN SC7010.C7_FILIAL = '09' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '40'	THEN 'COELCE'
					WHEN SC1010.C1_FILIAL = '09' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '30'	THEN 'COELCE'
					WHEN SC1010.C1_FILIAL = '07' AND (CASE WHEN SC7010.C7_XLOCENT='' THEN SC1010.C1_LOCAL ELSE SC7010.C7_XLOCENT END) = '55'	THEN 'AMPLA'
					ELSE 'ERRO'
				END
			) AS 'REGIONAL',
			
			ISNULL(IIF(
				REPLACE(REPLACE(RTRIM(CTT_XPOLO),'_',' '),'POLO ', '')=REPLACE(RTRIM(CTT010.CTT_XREGIO),'_',' '),
				REPLACE(REPLACE(RTRIM(CTT_XPOLO),'_',' '),'POLO ', ''),
				REPLACE(REPLACE(REPLACE(RTRIM(CTT_XPOLO),'_',' '),'POLO ', ''), REPLACE(RTRIM(CTT010.CTT_XREGIO),'_',' ')+' ', '')
			),'ESTOQUE') AS 'POLO',
			--SC7010.C7_FILIAL+SC7010.C7_LOCAL+' - '+RTRIM(Z01010.Z01_DESC) AS 'DESCRIÇÃO ARMAZÉM', --**DESATIVADO POR PROBLEMAS REGISTRO CORRETO DE FILIAL E LOCAL DE ORIGEM
			
			-- IDENTIFICA PROCESSO
			SC7010.C7_NUM AS 'NUM PC',
			SC7010.C7_ITEM AS 'ITEM',
			SC7010.C7_NUMSC AS 'NUM SC',
			SC7010.C7_ITEMSC AS 'ITEM SC',	
			
			--DETALHES DE VALOR E PRODUTO
			RTRIM(SC7010.C7_PRODUTO) AS 'CODIGO',
			RTRIM(SC7010.C7_DESCRI) AS 'DESCRIÇÃO',
			SC7010.C7_UM AS 'UND',
			SC7010.C7_QUANT AS 'QTDE',
			SC7010.C7_PRECO AS 'VAL UND',
			SC7010.C7_TOTAL AS 'VAL MERCADORIA',
			--CALCULO DE VALOR DO PEDIDO
			--O CÁLCULO ENGLOBA:
			--        - VALOR DO FRETE
			--        - VALOR DAS DESPESAS
			--        - VALOR DO SEGURO
			--        - VALOR DO IPI
			--        - VALOR ICMS RETIDO/SOLIDÁRIO/SUBSTITUIÇÃO/COMPLEMENTAR
			--        - VALOR DE DESCONTO --(ENTRA SUBTRAINDO DO TOTAL)
			(((SC7010.C7_TOTAL+SC7010.C7_VALIPI+SC7010.C7_ICMCOMP+SC7010.C7_ICMSRET+SC7010.C7_VALSOL+SC7010.C7_VALFRE+SC7010.C7_DESPESA+SC7010.C7_SEGURO)-SC7010.C7_VLDESC)/SC7010.C7_QUANT) AS 'VAL UND REAL',
			((SC7010.C7_TOTAL+SC7010.C7_VALIPI+SC7010.C7_ICMCOMP+SC7010.C7_ICMSRET+SC7010.C7_VALSOL+SC7010.C7_VALFRE+SC7010.C7_DESPESA+SC7010.C7_SEGURO)-SC7010.C7_VLDESC) AS 'TOTAL DO PEDIDO',
			RTRIM(SC7010.C7_OBS) AS 'OBSERVAÇÃO',

			--ACOMPANHAMENTO DE COMPRA/ENTREGA
			SC7010.C7_QUJE+SC7010.C7_QTDACLA AS 'QTDE RECEBIDA',
			(SC7010.C7_QUJE+SC7010.C7_QTDACLA)*SC7010.C7_PRECO AS 'TOTAL RECEBIDO',
			SC7010.C7_QUJE AS 'QTDE ENTREGUE',
			SC7010.C7_QTDACLA AS 'QTDE A CLASSI',
			SC7010.C7_QUANT-(SC7010.C7_QUJE+SC7010.C7_QTDACLA) AS 'QTDE FALTA',
			(SC7010.C7_QUANT-(SC7010.C7_QUJE+SC7010.C7_QTDACLA))*SC7010.C7_PRECO AS 'VALOR FALTA',

			-- SITUAÇÃO DO PROCESSO
			CASE WHEN SC7010.C7_CONAPRO = 'L' THEN 'APROVADO' ELSE 'BLOQUEADO' END AS 'SITUAÇÃO PC',
			CASE 
				WHEN (SC7010.C7_QUJE+SC7010.C7_QTDACLA)=SC7010.C7_QUANT THEN 'RECEBIDO TOTALMENTE'
				WHEN (SC7010.C7_QUJE+SC7010.C7_QTDACLA)=0 THEN 'FALTA RECEBER'
				WHEN (SC7010.C7_QUJE+SC7010.C7_QTDACLA)<SC7010.C7_QUANT AND (SC7010.C7_QUJE+SC7010.C7_QTDACLA)>0 THEN 'RECEBIDO PARCIAL'
				ELSE 'ERRO'
			END AS 'SITUAÇÃO DO PC',
			CASE WHEN SC7010.C7_TPCOMPR=2 THEN 'AP DIRETA' WHEN SC7010.C7_TPCOMPR=1 THEN 'ESTOQUE' ELSE 'ERRO' END AS 'TIPO DE COMPRA',
			CASE WHEN SC7010.C7_ENCER='E' THEN 'ENCERRADO' ELSE 'ABERTO' END AS 'PC ENCERRADO',
			CASE WHEN SC7010.C7_RESIDUO='S' THEN 'SIM' ELSE 'NÃO' END AS 'RESIDUO?',
			RTRIM(SC7010.C7_STEND) AS 'STATUS DO PC',
			
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

			--RESPONSÁVEL PELO PROCESSO
			SC7010.C7_USER AS 'COD COMPRADOR',
			RTRIM(SY1010.Y1_NOME) AS 'NOME COMPRADOR',
			--SC7010.C7_GRUPCOM AS 'GRUP COMPR', --*NÃO UTILIZADO*
			
			--ESPECIFICA FORNECEDOR
			SC7010.C7_FORNECE AS 'FORNECEDOR',
			CASE WHEN SC7010.C7_NOMFOR='                              ' THEN RTRIM(SA2010.A2_NOME) ELSE RTRIM(SC7010.C7_NOMFOR) END AS 'NOME FORNECEDOR',
			
			--CLASSIFICADORES
			SB1010.B1_GRUPO AS 'COD GRUPO',
			RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO',
			RTRIM(SC7010.C7_CC) AS 'CENTRO DE  CUSTO',	
			CASE WHEN SC7010.C7_CC = '' THEN 'PROCESSO PARA ARMAZÉM' ELSE RTRIM(CTT010.CTT_DESC01) END AS 'DESCRIÇÃO CENTRO DE CUSTO', 
			RTRIM(SC7010.C7_CONTA) AS 'CONTA CONTÁBIL',
			CASE WHEN SC7010.C7_CONTA = '' THEN 'ATIVO FIXO' ELSE RTRIM(CT1010.CT1_DESC01) END AS 'DESC CONT CONTÁBIL',
			RTRIM(SC7010.C7_ITEMCTA) AS 'CARRO',
			RTRIM(SC7010.C7_ITEMCTA+' - '+CTD010.CTD_DESC01) AS 'DESC CARRO',
			RTRIM(SC7010.C7_CLVL) AS 'OBRA',
			RTRIM(SC7010.C7_CLVL)+' - '+RTRIM(CTH010.CTH_DESC01) AS 'DESC OBRA/PROJETO',
			RTRIM(SB1010.B1_TIPO+' - '+
			(
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
			
			--CLASSIFICAÇÃO QUANTO A QUAL LOCAL COMPROU
			CASE
				WHEN (SC7010.C7_USER IN ('000044','000053','001193','001372','000238'))
					THEN 'COMPRAS'
				WHEN (SC7010.C7_USER IN ('001041','000629','000069','001417','000148','000852','000896','000655','000224','000190','001036','000444','001481','000797','001067','000048'))
					THEN 'ADM'
				WHEN (SC7010.C7_USER IN ('000335','000939','000347','000180','000178','000250','000092','000076','000536','000286','000692','000685','000319','000698','000962','000836','000628','001235','000816','000583','000620','000466','000900','000118','001048','001214', '000679', '001519','000216','001353','001362','000892','000815','001212','000554','000485','000663','001136','001042','000262','000937','000364','000567','001281','001391','001337','000246','001433','000894','001540','001328','000316','000993','000370','000376','000807','000306','000301','001506','000208','000571','000917','001562','000720','001329','001468','000435','001368','000283','000401'))
					THEN 'LOCAL'
				WHEN (SC7010.C7_USER IN ('000535', '000070','000045','000000','000646','001494','001039','000226','001520','001165','001480','001211','000932','000050','000215','001145','000902','001280','000593','001161','001073','000578','000646','001494','001039','000226','001520','001165','001480','001211','000932','000050','000215','001145','000902','001280','000593','001161','001073','000578'))
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
				WHEN SC7010.C7_PRODUTO IN ('00130004', '00130002', '00130001') THEN 'FROTA - COMBUSTÍVEL'
				WHEN (SB1010.B1_GRUPO IN ('4004', '4005','4006', '4010') OR SC7010.C7_PRODUTO IN ('00526075','02550337','40030031','02550338','00510017','02550339')) THEN 'FROTA - VEICULOS'
				WHEN (SB1010.B1_GRUPO = '0014' OR BM_TIPGRU='MV') THEN 'FROTA - MATERIAIS VEICULARES'
				WHEN BM_TIPGRU='SV' THEN 'FROTA - SERVIÇOS VEICULARES'
				WHEN SB1010.B1_GRUPO = '1026' THEN 'FROTA - TRANSPORTE DE VEICULOS'
				WHEN SB1010.B1_GRUPO IN ('0982', '0984') THEN 'VIAGENS - REEMBOLSAVEIS'
				WHEN SB1010.B1_GRUPO IN ('0983', '0980', '0985', '0986', '0981') THEN 'VIAGENS - NÃO REEMBOLSAVEIS'
				WHEN SB1010.B1_GRUPO IN ('0740', '0861', '0863', '0864', '0719','1020', '0860') THEN 'UTILIDADES'
				WHEN SC7010.C7_PRODUTO = '10210001' THEN 'FRETES - REEMBOLSAVEIS'
				WHEN SB1010.B1_GRUPO IN ('1028', '1027', '1026') THEN 'FRETES - NÃO REEMBOLSAVEIS'
				WHEN (BM_TIPGRU IN ('SS','SV', 'FR', 'SG') OR (BM_TIPGRU = 'DG' AND LEFT(SB1010.B1_DESC,7)='SERVICO')) THEN 'SERVIÇOS TOMADOS'
				WHEN 
					(
						(SC7010.C7_CONTA = '                    ') OR
						(LEFT(SC7010.C7_CONTA,3)='132')
					) THEN 'INVESTIMENTO - ATIVO FIXO'
				WHEN (SC7010.C7_CC = '         ' AND ((SC7010.C7_FILIAL='02' AND SC7010.C7_LOCAL IN ('21', '22')) OR (SC7010.C7_FILIAL='12' AND SC7010.C7_LOCAL IN ('91', '92')))) THEN 'ESTOQUE - INSUMOS PARA FATURAMENTO'
				WHEN (SC7010.C7_CC = '         ' AND SC7010.C7_CLVL = '001') THEN 'ESTOQUE - MOBILIZAÇÕES'
				WHEN (SC7010.C7_CC = '         ' AND SC7010.C7_CLVL <> '001') THEN 'ESTOQUE - CONSUMO OPERACIONAL'
				WHEN SC7010.C7_CLVL = '001' THEN 'INVESTIMENTO - MOBILIZAÇÕES'
				WHEN SC7010.C7_CC <> '         ' AND CTT010.CTT_TPCC = 'O' THEN 'APLICAÇÃO DIRETA - CUSTEIO OPERACIONAL'
				WHEN SC7010.C7_CC <> '         ' AND CTT010.CTT_TPCC = 'C' THEN 'APLICAÇÃO DIRETA - DESPESAS CORPORATIVAS'
				ELSE 'ERRO: CLASSIFICAR'
			END AS 'TIPO DE GASTO',

			--DATAS DO PROCESSO
			Case RTrim(Coalesce(SC7010.C7_EMISSAO,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC7010.C7_EMISSAO, 112)END AS 'DT EMISSÃO PC',
			Case RTrim(Coalesce(SC7010.C7_ALTDATA,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC7010.C7_ALTDATA, 112)END AS 'DT ALTERADO PC',
			Case RTrim(Coalesce(SC7010.C7_DTLIB1,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC7010.C7_DTLIB1, 112)END AS 'DT LIBERADO 1 PC',
			Case RTrim(Coalesce(SC7010.C7_DTLIB2,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC7010.C7_DTLIB2, 112)END AS 'DT LIBERADO 2 PC',
			Case RTrim(Coalesce(SC7010.C7_DTLIB3,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC7010.C7_DTLIB3, 112)END AS 'DT LIBERADO 3 PC',
			Case RTrim(Coalesce(SC7010.C7_DTLIB4,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC7010.C7_DTLIB4, 112)END AS 'DT LIBERADO 4 PC',
			Case RTrim(Coalesce(SC7010.C7_DTLIB5,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC7010.C7_DTLIB5, 112)END AS 'DT LIBERADO 5 PC',
			Case RTrim(Coalesce(SC7010.C7_DTLIB6,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC7010.C7_DTLIB6, 112)END AS 'DT LIBERADO 6 PC',
			Case RTrim(Coalesce(SC7010.C7_DTLIB7,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC7010.C7_DTLIB7, 112)END AS 'DT LIBERADO 7 PC',
			
			--DATAS ALTERNATIVAS
			--ERRO--Case RTrim(Coalesce(SC7010.C7_DATPRF,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC7010.C7_DATPRF, 112)END AS 'DT PREV ENTREGA', --*NÃO UTILIZADO* -> NÃO SE SABE COMO O SISTEMA PREENCHE ESSE DADO
			Case RTrim(Coalesce(SC7010.C7_DTNEGOC,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC7010.C7_DTNEGOC, 112)END AS 'DT PREV FATURA', --É USADO
			--Case RTrim(Coalesce(SC7010.C7_DTLANC,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC7010.C7_DTLANC, 112)END AS 'DT CONTABILIZAÇÃO', --*NÃO UTILIZADO*
			Case RTrim(Coalesce(SC7010.C7_DTENTRA,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC7010.C7_DTENTRA, 112)END AS 'DT ENTRA NF', --É AUTOMÁTICO, DATA DE CONTABILIZAÇÃO DA NF
			--ERRO--Case RTrim(Coalesce(SC7010.C7_DINICOM,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC7010.C7_DINICOM, 112)END AS 'DT P/ INICIO COMPRA' --*NÃO UTILIZADO*
			
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
			
			CASE WHEN SC7010.C7_APROV1='SISTEM' THEN 'AUTOMÁTICA' ELSE 'WORKFLOW' END AS 'TP APROVAÇÃO',

			-- APROVADORES DO PROCESSO
			SC7010.C7_APROV1 AS 'APROVADOR 1',
			SC7010.C7_APROV2 AS 'APROVADOR 2',
			SC7010.C7_APROV3 AS 'APROVADOR 3',
			SC7010.C7_APROV4 AS 'APROVADOR 4',
			SC7010.C7_APROV5 AS 'APROVADOR 5',
			SC7010.C7_APROV6 AS 'APROVADOR 6',
			SC7010.C7_APROV7 AS 'APROVADOR 7',

			--***************************************--
			--*** DADOS DE SOLICITAÇÃO DE COMPRAS ***--
			--***************************************--
			
			--SC: CONEXÃO COM TABELA DE SOLICITAÇÃO DE COMPRA
			RTRIM(SC1010.C1_SOLICIT) AS 'NOME SOLICITANTE SC',
			SC1010.C1_FILIAL AS 'SC: FIL',
			SC1010.C1_LOCAL AS 'SC: LOC',
			SC1010.C1_UM AS 'SC: UND',
			SC1010.C1_QUANT AS 'SC: QTDE',
			SC1010.C1_VLESTIM AS 'SC: VAL UND',
			SC1010.C1_VTOTAL AS 'SC: VAL TOTAL',
			--SC1010.C1_TOTSC AS 'SC: VAL TOTAL SC', --**NÃO É NECESSÁRIO
			Case RTrim(Coalesce(SC1010.C1_DTLIB1,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC1010.C1_DTLIB1, 112)END AS 'SC: DT LIBERADO 1',
			Case RTrim(Coalesce(SC1010.C1_DTLIB2,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC1010.C1_DTLIB2, 112)END AS 'SC: DT LIBERADO 2',
			Case RTrim(Coalesce(SC1010.C1_DTLIB3,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC1010.C1_DTLIB3, 112)END AS 'SC: DT LIBERADO 3',
			Case RTrim(Coalesce(SC1010.C1_DTLIB4,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC1010.C1_DTLIB4, 112)END AS 'SC: DT LIBERADO 4',
			Case RTrim(Coalesce(SC1010.C1_DTLIB5,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC1010.C1_DTLIB5, 112)END AS 'SC: DT LIBERADO 5',
			Case RTrim(Coalesce(SC1010.C1_DTLIB6,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC1010.C1_DTLIB6, 112)END AS 'SC: DT LIBERADO 6',
			Case RTrim(Coalesce(SC1010.C1_DTLIB7,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC1010.C1_DTLIB7, 112)END AS 'SC: DT LIBERADO 7',
			Case RTrim(Coalesce(SC1010.C1_EMISSAO,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC1010.C1_EMISSAO, 112)END AS 'SC: DT EMISSÃO',
			Case RTrim(Coalesce(SC1010.C1_ALTDATA,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC1010.C1_ALTDATA, 112)END AS 'SC: DT ALT',
			--SC: DATA DE APROVAÇÃO
			CONVERT(DATETIME,
				(
					SELECT MAX(LastUpdateDate)
					FROM (VALUES (SC1010.C1_DTLIB1),(SC1010.C1_DTLIB2),(SC1010.C1_DTLIB3),(SC1010.C1_DTLIB4),(SC1010.C1_DTLIB5),(SC1010.C1_DTLIB6),(SC1010.C1_DTLIB7), (SC1010.C1_EMISSAO), (SC1010.C1_ALTDATA)) AS UpdateDate(LastUpdateDate) 
				)
			, 112) AS 'DT APROVAÇÃO SC',
			--SC: TEMPO ATÉ APROVAR PROCESSO
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
			
			--***************************************--
			--*** DADOS DE SOLICITAÇÃO DE COMPRAS ***--
			--***************************************--
			
			--INFOS ADICIONAIS SOBRE PC
			SC7010.C7_HORINCL AS 'HORA INCLU PC',
			LEFT(SC7010.C7_HORINCL, 2) AS 'INTERVALO HORA',
			
			--CONJUNTO DE DADOS DE ALTERAÇÃO DE PC E FILIAL DE DESTINO
			CASE WHEN SC7010.C7_ALTUSR='' THEN 'NÃO' ELSE 'SIM' END AS 'PC ALTERADO?',
			SC7010.C7_ALTUSR AS 'ALT USER',
			RTRIM(SC7010.C7_ALTMOT) AS 'ALT OBS',

			--DADOS FRETE
			CASE
				WHEN SC7010.C7_TPFRETE='C' THEN 'C - CIF'
				WHEN SC7010.C7_TPFRETE='D' THEN 'D - POR CONTA DESTINATÁRIO'
				WHEN SC7010.C7_TPFRETE='F' THEN 'F - FOB'
				WHEN SC7010.C7_TPFRETE='S' THEN 'S - SEM FRETE'
				WHEN SC7010.C7_TPFRETE='T' THEN 'T - POR CONTRA TERCEIROS'
				ELSE 'N - NÃO DECLARADO'
			END AS 'FRETE TIPO',
			--SC7010.C7_FREPPCC AS 'Tipo Frete', --*NÃO UTILIZADO*
			--SC7010.C7_FRETE AS 'Valor do frete combinado',  --*NÃO UTILIZADO* --"Valor do frete combinado"
			SC7010.C7_VALFRE AS 'VAL FRETE',
			
			--DADOS DESPESAS
			--SC7010.C7_VALEMB AS 'Valor da Embalagem', --*NÃO UTILIZADO*
			SC7010.C7_SEGURO AS 'VALOR SEGURO',
			SC7010.C7_DESPESA AS 'VAL DESPESAS',
			
			-- IMPOSTOS
			SC7010.C7_VALIPI AS 'VAL IPI',
			SC7010.C7_VALICM AS 'VAL ICMS',
			SC7010.C7_ICMCOMP AS 'VAL ICMS COMPL',
			SC7010.C7_ICMSRET AS 'VAL ICMS RETIDO',
			SC7010.C7_VALSOL AS 'VAL ICMS SOL',
			--SC7010.C7_BASEICM AS 'BASE ICMS', --*NÃO NECESSÁRIO*
			SC7010.C7_IPI AS 'ALIQ. IPI',
			SC7010.C7_PICM AS 'ALIQ. ICMS',
			--SC7010.C7_BASEIPI AS 'BASE IPI', --*NÃO NECESSÁRIO*
			--SC7010.C7_IPIBRUT AS 'Considera Desconto p/IPI', --*NÃO NECESSÁRIO*

			--CONDIÇÃO DE PAGAMENTO
			SC7010.C7_COND AS 'COND PAG',
			SE4010.E4_COND AS 'COD PAG DETALHE',
			SE4010.E4_DESCRI AS 'DESRIÇÃO PAGAMENTO',
			
			--DESCONTOS: OS DESCONTOS DE 1 A 3 SÃO APLICADOS NO VALOR TOTAL DE COMRRA POR REGISTRO
			SC7010.C7_DESC1 AS 'DESCONTO 1', -- DESCONTO EM PORCENTAGEM (%) EM CASTATA
			SC7010.C7_DESC2 AS 'DESCONTO 2', -- DESCONTO EM PORCENTAGEM (%) EM CASTATA
			SC7010.C7_DESC3 AS 'DESCONTO 3', -- DESCONTO EM PORCENTAGEM (%) EM CASTATA
			SC7010.C7_VLDESC AS 'VAL DESC',
			
			--INFORMAÇÕES VARIADAS
			--SC7010.C7_MSG AS 'MSG PARA PEDIDO', --*NÃO UTILIZADO*
			SC7010.C7_TES AS 'TIPO ENTRADA NF',
			--SC7010.C7_ESTOQUE AS 'ATU ESTOQUE', --*NÃO UTILIZADO*
			
			--COTAÇÕES, CONTRATOS E ORÇAMENTOS
			--SC7010.C7_CODORCA AS 'COD ORÇAMENTO', --*NÃO UTILIZADO*
			--SC7010.C7_CONTRA AS 'NUM CONTRATO', --*NÃO UTILIZADO*
			--SC7010.C7_NUMCOT AS 'NUM COTAÇÃO', --*NÃO UTILIZADO*
			SC7010.C7_CONTATO AS 'CONTATO'
		FROM PROTHEUS.dbo.SC7010 SC7010
			--LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON (Z01010.Z01_FILIAL = SC7010.C7_FILIAL) AND (Z01010.Z01_COD = SC7010.C7_LOCAL) AND Z01010.D_E_L_E_T_<>'*' --**DESATIVADO POR PROBLEMAS REGISTRO CORRETO DE FILIAL E LOCAL DE ORIGEM
			LEFT JOIN PROTHEUS.dbo.CTT010 CTT010 ON SC7010.C7_CC=CTT010.CTT_CUSTO AND CTT010.D_E_L_E_T_<>'*'
			LEFT JOIN PROTHEUS.dbo.CT1010 CT1010 ON SC7010.C7_CONTA=CT1010.CT1_CONTA AND CT1010.D_E_L_E_T_<>'*'
			LEFT JOIN PROTHEUS.dbo.CTD010 CTD010 ON SC7010.C7_ITEMCTA=CTD010.CTD_ITEM AND CTD010.D_E_L_E_T_<>'*'
			LEFT JOIN PROTHEUS.dbo.CTH010 CTH010 ON SC7010.C7_CLVL=CTH010.CTH_CLVL AND CTH010.D_E_L_E_T_<>'*'
			LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SC7010.C7_PRODUTO=SB1010.B1_COD AND SB1010.D_E_L_E_T_<>'*'
			LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SB1010.B1_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_<>'*'
			LEFT JOIN PROTHEUS.dbo.SY1010 SY1010 ON SC7010.C7_USER=SY1010.Y1_USER AND SY1010.D_E_L_E_T_<>'*'
			LEFT JOIN PROTHEUS.dbo.SE4010 SE4010 ON SC7010.C7_COND=SE4010.E4_CODIGO AND SE4010.D_E_L_E_T_<>'*'
			LEFT JOIN PROTHEUS.dbo.SA2010 SA2010 ON SA2010.A2_COD=SC7010.C7_FORNECE AND SA2010.A2_LOJA=SC7010.C7_LOJA AND SA2010.D_E_L_E_T_<>'*'
			--CONEXÃO COM TABELA DE COMPRAS (SC1)
			LEFT JOIN PROTHEUS.dbo.SC1010 SC1010 ON ((SC1010.C1_NUM = SC7010.C7_NUMSC) AND (SC1010.C1_ITEM = SC7010.C7_ITEMSC)) AND SC1010.D_E_L_E_T_<>'*'
		WHERE 
			(SC7010.C7_EMISSAO>='20180101' AND SC7010.C7_EMISSAO<=GETDATE()) AND -- RESTRINGE INTERVALO DE TEMPO
			(SC7010.D_E_L_E_T_<>'*') AND --DESCONSIDERA DELETADOS
			--(SC7010.C7_NUMSC IN ('275157','278955','280073','280077','280078'))
			--GRUPOS QUE NÃO PERTENCEM À ANÁLISE (GERALMENTE PARTENCENTES AO RH)
			(SB1010.B1_GRUPO NOT IN ('0710','0093','0095','0096','1211','3000','3001','3002','3003','3004','3005','3006','3007','3050','3058','3060','3061')) AND
		--	(SC7010.C7_FORNECE IN ('949082', '949486'))
		 	(SC7010.C7_CONAPRO = 'L') AND --PC APROVADOS
		 	(SC7010.C7_QUJE+SC7010.C7_QTDACLA)<SC7010.C7_QUANT --SOMENTE MATERIAL PENDENTE
		--  (SC7010.C7_RESIDUO<>' ') AND --NÃO ELIMINADO POR RESÍDUO
		-- 	(SC7010.C7_CC = '         ') AND --CENTRO DE CUSTO 
		--  (SC7010.C7_FILIAL='12') AND --FIXA FILIAL 
		--  (SC7010.C7_LOCAL = '90') AND  --FIXA ARMAZÉM
		--  (SC7010.C7_CLVL<>'001') AND --DESCONSIDERA MOBILIZAÇÕES
		-- 	(SC7010.C7_USER IN ('000044','000053')) --RESTRINGE COMPRADORES
	)
/*
COMPLEMENTAÇÃO DE INFORMAÇÕES

ESTA ETAPA CONTEM ALGUNS ARTIFÍCIOS DE BYPASS DE UM ERRO DE AMARAÇÃO DA DESCRIÇÃO DE ARMAZÉM QUE ESTÁ ACONTECENDO
*/
SELECT
	ISNULL(
		TB_PC."FILIAL"+TB_PC."LOC ANTERIOR"+' - '+RTRIM(Z01010_ANTES.Z01_DESC),
		TB_PC."FIL ENTREGA"+TB_PC."LOC ENTREGA"+' - '+RTRIM(Z01010_DEPOIS.Z01_DESC)
	) AS 'DESCRIÇÃO ARMAZÉM',
	CASE 
		WHEN ((TB_PC."FILIAL"<>TB_PC."FIL ENTREGA") OR (TB_PC."LOC ANTERIOR"<>TB_PC."LOC ENTREGA"))THEN 'ALTERADA'
		ELSE 'ORIGINAL'
	END AS 'ALTERAÇÃO DESTINO',
	CASE 
		WHEN TB_PC."DT APROVAÇÃO SC"='      ' THEN NULL
		ELSE (IIF(TB_PC."DT ALTERADO PC">TB_PC."DT EMISSÃO PC", TB_PC."DT ALTERADO PC", TB_PC."DT EMISSÃO PC") - TB_PC."DT APROVAÇÃO SC")
	END AS 'TEMPO ATÉ COMPRA',
	TB_PC.*
FROM DADOS_PC AS TB_PC
	LEFT JOIN PROTHEUS.dbo.Z01010 Z01010_ANTES ON (Z01010_ANTES.Z01_FILIAL = TB_PC."FILIAL") AND (Z01010_ANTES.Z01_COD = TB_PC."LOC ANTERIOR") AND Z01010_ANTES.D_E_L_E_T_<>'*'
	LEFT JOIN PROTHEUS.dbo.Z01010 Z01010_DEPOIS ON (Z01010_DEPOIS.Z01_FILIAL = TB_PC."FIL ENTREGA") AND (Z01010_DEPOIS.Z01_COD = TB_PC."LOC ENTREGA") AND Z01010_DEPOIS.D_E_L_E_T_<>'*'
ORDER BY 
	TB_PC."DT EMISSÃO PC",
	TB_PC."NUM PC",
	TB_PC."ITEM" DESC