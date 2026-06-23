
--CONN BMIS_OPL/BMISOPL2B9999@PRS86

--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 

-- 1 sales foreast
-- 1 sales foreast

SELECT A.BRAND_CODE, A.BRAND_NAME, A.P_CODE, A.P_DESC, A.PACK,
       A.COMM_TP,
       A.BUDQNTY_2026,
       A.BUDVAL_2026
FROM(
SELECT C.BRAND_CODE, C.BRAND_NAME, A.P_CODE, B.P_DESC, B.PACK_SIZE1||'X'||B.PACK_SIZE2 PACK,
       B.COMM_TP,
       A.BUDQNTY_2026,
       ROUND(NVL(A.BUDQNTY_2026,0)*NVL(B.COMM_TP,0)) BUDVAL_2026
FROM(
SELECT A.P_CODE,
       SUM(NVL(BUDQNTY_2026,0)) BUDQNTY_2026
FROM(
      SELECT A.P_CODE, SUM(NVL(T_QNTY_SALE,0)) BUDQNTY_2026
      FROM ERP_OPL.ROLLING_FORECAST@TRNS A
      WHERE TRUNC(MNYR,'YEAR') = '01-JAN-2026'
      AND   NVL(T_QNTY_SALE,0)>0
      GROUP BY A.P_CODE
    ) A
GROUP BY A.P_CODE
) A, PRODUCT B, BRAND C
WHERE A.P_CODE     = B.P_CODE
AND   B.BRAND_CODE = C.BRAND_CODE
) A
WHERE (NVL(A.BUDQNTY_2026,0)+NVL(A.BUDVAL_2026,0))>0
ORDER BY A.P_DESC;


--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

-- 2 sample  foreast
-- 2 sample  foreast

--SELECT SUM(NVL(SAMPLE_BUDGET_2026,0)) FROM(
SELECT C.BRAND_CODE, C.BRAND_NAME, A.P_CODE, B.P_DESC, B.PACK_SIZE1||'X'||B.PACK_SIZE2 PACK, ROUND(SUM(NVL(BUDGET_2026,0))) SAMPLE_BUDGET_2026
FROM(
SELECT B.P_CODE, SUM(NVL(A.QNTY,0)*NVL(B.SAMP_RATE,0)) BUDGET_2026
FROM PBMS_OPL.MON_PROM_PLAN_TOT@TRNS A, ( SELECT MNYR, P_N_CODE, P_CODE, TOT_SAMP_COST SAMP_RATE
                                          FROM PBMS_OPL.PROD_WISE_SAMP_COST_COGS_HIST@TRNS A
                                          WHERE (P_N_CODE, MNYR) IN (SELECT P_N_CODE, MAX(MNYR) MNYR FROM PBMS_OPL.PROD_WISE_SAMP_COST_COGS_HIST@TRNS B WHERE NVL(B.TOT_SAMP_COST,0)>0 GROUP BY P_N_CODE)
                                          AND   P_N_CODE NOT IN(SELECT P_N_CODE FROM PBMS_OHNL.PROD_WISE_SAMP_COST_COGS_HIST@OHL)
                                          UNION ALL
                                          SELECT MNYR, P_N_CODE, P_CODE, TOT_SAMP_COST SAMP_RATE
                                          FROM PBMS_OHNL.PROD_WISE_SAMP_COST_COGS_HIST@OHL A
                                          WHERE (P_N_CODE, MNYR) IN (SELECT P_N_CODE, MAX(MNYR) MNYR FROM PBMS_OHNL.PROD_WISE_SAMP_COST_COGS_HIST@OHL B WHERE NVL(B.TOT_SAMP_COST,0)>0 GROUP BY P_N_CODE)
                                        ) B
WHERE A.PROM_CODE          = B.P_N_CODE(+)
AND   NVL(A.QNTY,0)       >0
AND   TRUNC(A.MNYR,'YEAR') = '01-JAN-2026'
GROUP BY B.P_CODE
) A, PRODUCT B, BRAND C
WHERE A.P_CODE     = B.P_CODE
AND   B.BRAND_CODE = C.BRAND_CODE
GROUP BY C.BRAND_CODE, C.BRAND_NAME, A.P_CODE, B.P_DESC, B.PACK_SIZE1||'X'||B.PACK_SIZE2
ORDER BY B.P_DESC
--)


--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

-- 3 ppm  foreast
-- 3 ppm  foreast


--SELECT SUM(NVL(PPM_BUDGET_2026,0)) FROM(
SELECT A.BRAND_CODE, B.BRAND_NAME, ROUND(SUM(NVL(PPM_BUDGET_2026,0))) PPM_BUDGET_2026
FROM(
--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
SELECT BRAND_CODE, SUM(NVL(TOT1,0)) PPM_BUDGET_2026
FROM(
SELECT TO_CHAR(MNYR,'YYYY') YR, A.BRAND_CODE, A.PROM_TYPE, NVL(QNTY,0)*DECODE(NVL(J.INTER_STAT,'N'), 'Y', J.FINAL_RATE, A.RATE) TOT1
FROM PBMS_OPL.PPM_ROLLING_FORECAST@TRNS A, PBMS_OPL.SAMP_PLAN_TYPE@TRNS B, ( SELECT A.PPM_CODE, A.REQ_NO, A.PPM_DESC, NVL(B.FINAL_RATE,0) FINAL_RATE, NVL(INTER_STAT,'N') INTER_STAT
                                                                             FROM( SELECT DISTINCT A.PPM_CODE, A.REQ_NO, B.PPM_DESC
                                                                                   FROM PBMS_OPL.PPM_REQ_ITEM@TRNS A, PBMS_OPL.PPM_INVENTORY_ITEM@TRNS B
                                                                                   WHERE A.PPM_CODE = B.PPM_CODE
                                                                                 ) A,
                                                                                 ( SELECT PPM_CODE, MAX(APRV_UNIT_RATE) FINAL_RATE, 'Y' INTER_STAT
                                                                                   FROM PBMS_OPL.PPM_QUAT_RCV_DTL@TRNS
                                                                                   WHERE NVL(APRV_UNIT_RATE,0)>0
                                                                                   GROUP BY PPM_CODE
                                                                                 ) B
                                                                             WHERE A.PPM_CODE = B.PPM_CODE(+)
                                                                             UNION ALL
                                                                             --============== HERBAL=======================
                                                                             --============== HERBAL=======================
                                                                             SELECT A.PPM_CODE, A.REQ_NO, A.PPM_DESC, NVL(B.FINAL_RATE,0) FINAL_RATE, NVL(INTER_STAT,'N') INTER_STAT
                                                                             FROM( SELECT DISTINCT A.PPM_CODE, A.REQ_NO, B.PPM_DESC
                                                                                   FROM PBMS_OHNL.PPM_REQ_ITEM@OHL A, PBMS_OHNL.PPM_INVENTORY_ITEM@OHL B
                                                                                   WHERE A.PPM_CODE = B.PPM_CODE
                                                                                 ) A,
                                                                                 ( SELECT PPM_CODE, MAX(APRV_UNIT_RATE) FINAL_RATE, 'Y' INTER_STAT
                                                                                   FROM PBMS_OHNL.PPM_QUAT_RCV_DTL@OHL
                                                                                   WHERE NVL(APRV_UNIT_RATE,0)>0
                                                                                   GROUP BY PPM_CODE
                                                                                 ) B
                                                                             WHERE A.PPM_CODE = B.PPM_CODE(+)
                                                                           ) J
WHERE A.PROM_TYPE = B.TYPE_CODE
AND   A.PPM_CODE  = J.PPM_CODE(+)
AND   TRUNC(A.MNYR,'YEAR') = '01-JAN-2026'
)
GROUP BY BRAND_CODE
) A, OPL.BRAND@TRNS B
WHERE A.BRAND_CODE = B.BRAND_CODE
GROUP BY A.BRAND_CODE, B.BRAND_NAME
ORDER BY B.BRAND_NAME
--)


--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

-- 4 gift foreast
-- 4 gift foreast

GN
TI
GC
HM
HN
IN
GA
DA
ES
PC

AE = Achieve & Earm
CM = Card Campaign
PX = PC Expenses
RX = Rx Campaign
SC = Special Campaign


--SELECT SUM(NVL(GIFT_BUDGET_2026,0)) FROM(
SELECT A.BRAND_CODE, B.BRAND_NAME, ROUND(SUM(NVL(GIFT_BUDGET_2026,0))) GIFT_BUDGET_2026
FROM(
--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
SELECT BRAND_CODE, SUM(NVL(TOT1,0)) GIFT_BUDGET_2026
FROM(
SELECT TO_CHAR(MNYR,'YYYY') YR, A.BRAND_CODE, A.PROM_TYPE, NVL(QNTY,0)*DECODE(NVL(J.INTER_STAT,'N'), 'Y', J.FINAL_RATE, A.RATE) TOT1
FROM PBMS_OPL.GIFT_ROLLING_FORECAST@TRNS A, PBMS_OPL.SAMP_PLAN_TYPE@TRNS B, ( SELECT A.PPM_CODE, A.REQ_NO, A.PPM_DESC, NVL(B.FINAL_RATE,0) FINAL_RATE, NVL(INTER_STAT,'N') INTER_STAT
                                                                              FROM( SELECT DISTINCT A.PPM_CODE, A.REQ_NO, B.PPM_DESC
                                                                                    FROM PBMS_OPL.PPM_REQ_ITEM@TRNS A, PBMS_OPL.PPM_INVENTORY_ITEM@TRNS B
                                                                                    WHERE A.PPM_CODE = B.PPM_CODE
                                                                                  ) A,
                                                                                  ( SELECT PPM_CODE, MAX(APRV_UNIT_RATE) FINAL_RATE, 'Y' INTER_STAT
                                                                                    FROM PBMS_OPL.PPM_QUAT_RCV_DTL@TRNS
                                                                                    WHERE NVL(APRV_UNIT_RATE,0)>0
                                                                                    GROUP BY PPM_CODE
                                                                                  ) B
                                                                              WHERE A.PPM_CODE = B.PPM_CODE(+)
                                                                              UNION ALL
                                                                             --============== HERBAL=======================
                                                                             --============== HERBAL=======================
                                                                              SELECT A.PPM_CODE, A.REQ_NO, A.PPM_DESC, NVL(B.FINAL_RATE,0) FINAL_RATE, NVL(INTER_STAT,'N') INTER_STAT
                                                                              FROM( SELECT DISTINCT A.PPM_CODE, A.REQ_NO, B.PPM_DESC
                                                                                    FROM PBMS_OHNL.PPM_REQ_ITEM@OHL A, PBMS_OHNL.PPM_INVENTORY_ITEM@OHL B
                                                                                    WHERE A.PPM_CODE = B.PPM_CODE
                                                                                  ) A,
                                                                                  ( SELECT PPM_CODE, MAX(APRV_UNIT_RATE) FINAL_RATE, 'Y' INTER_STAT
                                                                                    FROM PBMS_OHNL.PPM_QUAT_RCV_DTL@OHL
                                                                                    WHERE NVL(APRV_UNIT_RATE,0)>0
                                                                                    GROUP BY PPM_CODE
                                                                                  ) B
                                                                              WHERE A.PPM_CODE = B.PPM_CODE(+)
                                                                            ) J
WHERE A.PROM_TYPE = B.TYPE_CODE
AND   A.PPM_CODE  = J.PPM_CODE(+)
AND   A.PROM_TYPE NOT IN('AE','CM','PX','RX','SC')
AND   TRUNC(A.MNYR,'YEAR') = '01-JAN-2026'
)
GROUP BY BRAND_CODE
) A, OPL.BRAND@TRNS B
WHERE A.BRAND_CODE = B.BRAND_CODE
GROUP BY A.BRAND_CODE, B.BRAND_NAME
ORDER BY B.BRAND_NAME
--)


--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

--AE = Achieve & Earm


--SELECT SUM(NVL(ACHIEVE_EARM_BUDGET_2025,0)) FROM(
SELECT A.BRAND_CODE, A.BRAND_NAME, SUM(NVL(BUDGET_2026,0)) ACHIEVE_EARM_BUDGET_2026
FROM(
--= = = = = = = = = = = = = = = = = = = = = = = = ACHIEVE & EARM BUDGET
--= = = = = = = = = = = = = = = = = = = = = = = = ACHIEVE & EARM BUDGET
SELECT A.BRAND_CODE, B.BRAND_NAME, SUM(NVL(A.TOT1,0)) BUDGET_2026
FROM(
SELECT TO_CHAR(MNYR,'YYYY') YR, A.BRAND_CODE, A.PROM_TYPE, NVL(QNTY,0)*NVL(A.RATE,0) TOT1
FROM PBMS_OPL.GIFT_ROLLING_FORECAST@TRNS A, PBMS_OPL.SAMP_PLAN_TYPE@TRNS B
WHERE A.PROM_TYPE = B.TYPE_CODE
AND   A.PROM_TYPE = 'AE'
AND   TRUNC(A.MNYR,'YEAR') = '01-JAN-2026'
) A, BRAND B
WHERE A.BRAND_CODE = B.BRAND_CODE
GROUP BY A.BRAND_CODE, B.BRAND_NAME
) A
GROUP BY A.BRAND_CODE, A.BRAND_NAME
ORDER BY BRAND_NAME
--)



--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

--CM = Card Campaign


--SELECT SUM(NVL(CARD_CAMPAIGN_BUDGET_2025,0)) FROM(
SELECT A.BRAND_CODE, A.BRAND_NAME, SUM(NVL(BUDGET_2026,0)) CARD_CAMPAIGN_BUDGET_2026
FROM(
--= = = = = = = = = = = = = = = = = = = = = = = = CARD CAMPAIGN BUDGET
--= = = = = = = = = = = = = = = = = = = = = = = = CARD CAMPAIGN BUDGET
SELECT A.BRAND_CODE, B.BRAND_NAME, SUM(NVL(A.TOT1,0)) BUDGET_2026
FROM(
SELECT TO_CHAR(MNYR,'YYYY') YR, A.BRAND_CODE, A.PROM_TYPE, NVL(QNTY,0)*NVL(A.RATE,0) TOT1
FROM PBMS_OPL.GIFT_ROLLING_FORECAST@TRNS A, PBMS_OPL.SAMP_PLAN_TYPE@TRNS B
WHERE A.PROM_TYPE = B.TYPE_CODE
AND   A.PROM_TYPE = 'CM'
AND   TRUNC(A.MNYR,'YEAR') = '01-JAN-2026'
) A, BRAND B
WHERE A.BRAND_CODE = B.BRAND_CODE
GROUP BY A.BRAND_CODE, B.BRAND_NAME
) A
GROUP BY A.BRAND_CODE, A.BRAND_NAME
ORDER BY BRAND_NAME
--)



--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

--PX = PC CASH BUDGET


--SELECT SUM(NVL(PC_CASH_BUDGET_2025,0)) FROM(
SELECT A.BRAND_CODE, A.BRAND_NAME, SUM(NVL(BUDGET_2026,0)) PC_CASH_BUDGET_2026
FROM(
--= = = = = = = = = = = = = = = = = = = = = = = = PC  CASH BUDGET
--= = = = = = = = = = = = = = = = = = = = = = = = PC  CASH BUDGET
SELECT A.BRAND_CODE, B.BRAND_NAME, SUM(NVL(A.TOT1,0)) BUDGET_2026
FROM(
SELECT TO_CHAR(MNYR,'YYYY') YR, A.BRAND_CODE, A.PROM_TYPE, NVL(QNTY,0)*NVL(A.RATE,0) TOT1
FROM PBMS_OPL.GIFT_ROLLING_FORECAST@TRNS A, PBMS_OPL.SAMP_PLAN_TYPE@TRNS B
WHERE A.PROM_TYPE = B.TYPE_CODE
AND   A.PROM_TYPE = 'PX'
AND   TRUNC(A.MNYR,'YEAR') = '01-JAN-2026'
) A, BRAND B
WHERE A.BRAND_CODE = B.BRAND_CODE
GROUP BY A.BRAND_CODE, B.BRAND_NAME
) A
GROUP BY A.BRAND_CODE, A.BRAND_NAME
ORDER BY BRAND_NAME
--)


--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

-- rx campaign budget
-- rx campaign budget

 
--SELECT SUM(NVL(RX_CAMPAIGN_BUDGET_2025,0)) FROM(
SELECT A.BRAND_CODE, A.BRAND_NAME, SUM(NVL(BUDGET_2026,0)) RX_CAMPAIGN_BUDGET_2026
FROM(
--= = = = = = = = = = = = = = = = = = = = = = = = RX BUDGET
--= = = = = = = = = = = = = = = = = = = = = = = = RX BUDGET
SELECT A.BRAND_CODE, B.BRAND_NAME, SUM(NVL(A.TOT1,0)) BUDGET_2026
FROM(
SELECT TO_CHAR(MNYR,'YYYY') YR, A.BRAND_CODE, A.PROM_TYPE, NVL(QNTY,0)*NVL(A.RATE,0) TOT1
FROM PBMS_OPL.GIFT_ROLLING_FORECAST@TRNS A, PBMS_OPL.SAMP_PLAN_TYPE@TRNS B
WHERE A.PROM_TYPE = B.TYPE_CODE
AND   A.PROM_TYPE = 'RX'
AND   TRUNC(A.MNYR,'YEAR') = '01-JAN-2026'
) A, BRAND B
WHERE A.BRAND_CODE = B.BRAND_CODE
GROUP BY A.BRAND_CODE, B.BRAND_NAME
) A
GROUP BY A.BRAND_CODE, A.BRAND_NAME
ORDER BY BRAND_NAME
--)


--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
 
-- SC = Special Campaign


--SELECT SUM(NVL(SPECIAL_CAMPAIGN_BUDGET_2025,0)) FROM(
SELECT A.MNYR, A.BRAND_CODE, A.BRAND_NAME, A.CAMPAIGN_CATEGORY, SUM(NVL(BUDGET_2026,0)) SPECIAL_CAMPAIGN_BUDGET_2026
FROM(
--= = = = = = = = = = = = = = = = = = = = = = = = SPECIAL CAMPAIGN BUDGET
--= = = = = = = = = = = = = = = = = = = = = = = = SPECIAL CAMPAIGN BUDGET
SELECT A.MNYR, A.BRAND_CODE, B.BRAND_NAME, A.CAMPAIGN_CATEGORY, SUM(NVL(A.TOT1,0)) BUDGET_2026
FROM(
SELECT MNYR, A.BRAND_CODE, A.PROM_TYPE, C.PPM_S_DESC CAMPAIGN_CATEGORY, NVL(QNTY,0)*NVL(A.RATE,0) TOT1
FROM PBMS_OPL.GIFT_ROLLING_FORECAST@TRNS A, PBMS_OPL.SAMP_PLAN_TYPE@TRNS B, PBMS_OPL.PPM_SUB_TYPE@TRNS C
WHERE A.PROM_TYPE = B.TYPE_CODE
AND   A.PPM_M_CODE= C.PPM_M_CODE
AND   A.PPM_S_CODE= C.PPM_S_CODE
AND   A.PROM_TYPE = 'SC'
AND   TRUNC(A.MNYR,'YEAR') = '01-JAN-2026'
) A, BRAND B
WHERE A.BRAND_CODE = B.BRAND_CODE
GROUP BY A.MNYR, A.BRAND_CODE, B.BRAND_NAME, A.CAMPAIGN_CATEGORY
) A
GROUP BY A.MNYR, A.BRAND_CODE, A.BRAND_NAME, A.CAMPAIGN_CATEGORY
ORDER BY A.MNYR, A.BRAND_NAME, A.CAMPAIGN_CATEGORY
--)

--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = 
--= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =