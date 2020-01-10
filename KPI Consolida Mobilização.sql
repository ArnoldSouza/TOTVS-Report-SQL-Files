/* DECLARAÇÃO INICIAL DE CONFIGURAÇÃO */
SET NOCOUNT ON

/*  DECLARA TABELA TEMPORÁRIA PARA GUARDA DE NUMERO DE SCS  */
DECLARE @VALORES TABLE
(
    VALOR VARCHAR(6)
)

/*  ALOCA NUM DE SCS A SEREM PESQUISADAS  */
--MOBILIZAÇÃO CE1902
INSERT INTO @VALORES VALUES ('302506')
INSERT INTO @VALORES VALUES ('302496')
INSERT INTO @VALORES VALUES ('302513')
INSERT INTO @VALORES VALUES ('302514')
INSERT INTO @VALORES VALUES ('302515')
INSERT INTO @VALORES VALUES ('302516');

/*  FAZ CONSULTA EM SOLICITAÇÃO DE COMPRA  */
WITH SC AS (
    SELECT RTRIM(SC1010.C1_PRODUTO) AS 'CODIGO',
           RTRIM(SC1010.C1_DESCRI)  AS 'DESCRICAO',
           SUM(SC1010.C1_QUANT)     AS 'QTDE_SC'
    FROM PROTHEUS.dbo.SC1010 SC1010 WITH (NOLOCK)
    WHERE (SC1010.D_E_L_E_T_ <> '*')
      AND (SC1010.C1_NUM IN (SELECT VALOR FROM @VALORES))
    GROUP BY RTRIM(SC1010.C1_PRODUTO),
             RTRIM(SC1010.C1_DESCRI)
),
/*  FAZ CONSULTA EM PEDIDO DE COMPRA  */
PEDIDOS AS (
    SELECT RTRIM(SC7010.C7_PRODUTO)             AS 'CODIGO',
           (SC7010.C7_QUANT)                    AS 'QTDE_PC',
           (SC7010.C7_QUJE + SC7010.C7_QTDACLA) AS 'QTDE_PRENOTA',
           (
               SELECT SUM(COMPLEMENTO.C7_QUANT)
               FROM PROTHEUS.dbo.SC7010 COMPLEMENTO WITH (NOLOCK)
               WHERE RTRIM(COMPLEMENTO.C7_STEND) = '06 - ENTREGUE'
                 AND (COMPLEMENTO.D_E_L_E_T_ <> '*')
                 AND (SC7010.C7_PRODUTO = COMPLEMENTO.C7_PRODUTO AND
                      SC7010.C7_NUM = COMPLEMENTO.C7_NUM AND
                      SC7010.C7_ITEM = COMPLEMENTO.C7_ITEM)
           )                                    AS 'QTDE_ENTREGUE_COMPRAS'
    FROM PROTHEUS.dbo.SC7010 SC7010 WITH (NOLOCK)
    WHERE (SC7010.D_E_L_E_T_ <> '*')
      AND (SC7010.C7_NUMSC IN (SELECT VALOR FROM @VALORES))
),
/*  AGRUPA PEDIDO POR CODIGO DE PRODUTO  */
PEDIDOS_GROUP AS (
    SELECT PEDIDOS.CODIGO,
           SUM(PEDIDOS.QTDE_PC)    AS [QTDE_PC],
           SUM(PEDIDOS.QTDE_PRENOTA) AS [QTDE_PRENOTA],
           SUM(PEDIDOS.QTDE_ENTREGUE_COMPRAS) AS [QTDE_ENTREGA_COMPRAS]
    FROM PEDIDOS
    GROUP BY PEDIDOS.CODIGO
)
SELECT
    SC.CODIGO AS 'CODIGO',
    SC.DESCRICAO AS 'DESCRICAO',
    SC.QTDE_SC AS 'QTDE_SC',
    ISNULL(PEDIDOS_GROUP.QTDE_PC, 0) AS 'QTDE_PC',
    ISNULL(PEDIDOS_GROUP.QTDE_PRENOTA, 0) AS 'QTDE_PRENOTA',
    IIF(PEDIDOS_GROUP.QTDE_ENTREGA_COMPRAS>0, PEDIDOS_GROUP.QTDE_ENTREGA_COMPRAS, ISNULL(PEDIDOS_GROUP.QTDE_PRENOTA, 0)) AS 'QTDE_ENTREGA_COMPRAS'
FROM SC
    LEFT JOIN PEDIDOS_GROUP ON PEDIDOS_GROUP.CODIGO=SC.CODIGO
