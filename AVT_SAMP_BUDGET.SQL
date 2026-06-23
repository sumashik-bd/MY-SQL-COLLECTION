DROP VIEW PBMS_AVT.AVT_SAMP_BUDGET_VW;

/* Formatted on 11-Jun-26 11:31:05 AM (QP5 v5.115.810.9015) */
CREATE OR REPLACE FORCE VIEW PBMS_AVT.AVT_SAMP_BUDGET_VW
(
SLNO, CATEGORY, JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC, TOT, PARCEN
)
AS;
   SELECT   3 SLNO, CATEGORY, JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC, TOT, PARCEN
     FROM   (  SELECT   CATEGORY,
                        ROUND (SUM (NVL (JAN_SAMP_VAL, 0))) JAN,
                        ROUND (SUM (NVL (FEB_SAMP_VAL, 0))) FEB,
                        ROUND (SUM (NVL (MAR_SAMP_VAL, 0))) MAR,
                        ROUND (SUM (NVL (APR_SAMP_VAL, 0))) APR,
                        ROUND (SUM (NVL (MAY_SAMP_VAL, 0))) MAY,
                        ROUND (SUM (NVL (JUN_SAMP_VAL, 0))) JUN,
                        ROUND (SUM (NVL (JUL_SAMP_VAL, 0))) JUL,
                        ROUND (SUM (NVL (AUG_SAMP_VAL, 0))) AUG,
                        ROUND (SUM (NVL (SEP_SAMP_VAL, 0))) SEP,
                        ROUND (SUM (NVL (OCT_SAMP_VAL, 0))) OCT,
                        ROUND (SUM (NVL (NOV_SAMP_VAL, 0))) NOV,
                        ROUND (SUM (NVL (DEC_SAMP_VAL, 0))) DEC,
                        ROUND (SUM (NVL (TOT_SAMP_VAL, 0))) TOT,
                        (ROUND (ROUND (SUM (NVL (TOT_SAMP_VAL, 0)))/ (SELECT   TOT FROM AVT_SALES_FORECAST_BUD_VW),2)* 100)PARCEN
                 FROM   (SELECT   DECODE (A.PROM_TYPE,'HN',B.FF_DESC || ' (' || A.CATEGORY || ')',
                                                   'HM',B.FF_DESC || ' (' || A.CATEGORY || ')',
                                                   'IN',B.FF_DESC || ' (' || A.CATEGORY || ')',
                                                   'PC',B.FF_DESC || ' (' || A.CATEGORY || ')',
                                                   A.CATEGORY)
                                  CATEGORY,
                                  A.P_DESC,
                                  A.PACK_SIZE,
                                  NVL (A.EXPOSURE, 0) EXPOSURE,
                                  A.FF_TYPE,
                                  B.FF_SLNO,
                                  A.JAN_SAMP,
                                  A.FEB_SAMP,
                                  A.MAR_SAMP,
                                  A.APR_SAMP,
                                  A.MAY_SAMP,
                                  A.JUN_SAMP,
                                  A.JUL_SAMP,
                                  A.AUG_SAMP,
                                  A.SEP_SAMP,
                                  A.OCT_SAMP,
                                  A.NOV_SAMP,
                                  A.DEC_SAMP,
                                  A.TOT_SAMP,
                                  --= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
                                 A.JAN_SAMP_VAL, A.FEB_SAMP_VAL, A.MAR_SAMP_VAL, A.APR_SAMP_VAL, A.MAY_SAMP_VAL, A.JUN_SAMP_VAL, A.JUL_SAMP_VAL, A.AUG_SAMP_VAL, A.SEP_SAMP_VAL, A.OCT_SAMP_VAL, A.NOV_SAMP_VAL, A.DEC_SAMP_VAL, A.TOT_SAMP_VAL
                           --= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
                           FROM   (SELECT   A.CATEGORY,A.PROM_TYPE,A.P_DESC,A.PACK_SIZE, B.EXPOSURE, A.SLNO, A.FF_TYPE, A.JAN_SAMP, A.FEB_SAMP, A.MAR_SAMP, A.APR_SAMP, A.MAY_SAMP, A.JUN_SAMP, A.JUL_SAMP, A.AUG_SAMP, A.SEP_SAMP, A.OCT_SAMP, A.NOV_SAMP, A.DEC_SAMP,
                                              A.JAN_SAMP
                                            + A.FEB_SAMP
                                            + A.MAR_SAMP
                                            + A.APR_SAMP
                                            + A.MAY_SAMP
                                            + A.JUN_SAMP
                                            + A.JUL_SAMP
                                            + A.AUG_SAMP
                                            + A.SEP_SAMP
                                            + A.OCT_SAMP
                                            + A.NOV_SAMP
                                            + A.DEC_SAMP
                                               TOT_SAMP,
                                            --= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
                                            A.JAN_SAMP_VAL,
                                            A.FEB_SAMP_VAL,
                                            A.MAR_SAMP_VAL,
                                            A.APR_SAMP_VAL,
                                            A.MAY_SAMP_VAL,
                                            A.JUN_SAMP_VAL,
                                            A.JUL_SAMP_VAL,
                                            A.AUG_SAMP_VAL,
                                            A.SEP_SAMP_VAL,
                                            A.OCT_SAMP_VAL,
                                            A.NOV_SAMP_VAL,
                                            A.DEC_SAMP_VAL,
                                              A.JAN_SAMP_VAL
                                            + A.FEB_SAMP_VAL
                                            + A.MAR_SAMP_VAL
                                            + A.APR_SAMP_VAL
                                            + A.MAY_SAMP_VAL
                                            + A.JUN_SAMP_VAL
                                            + A.JUL_SAMP_VAL
                                            + A.AUG_SAMP_VAL
                                            + A.SEP_SAMP_VAL
                                            + A.OCT_SAMP_VAL
                                            + A.NOV_SAMP_VAL
                                            + A.DEC_SAMP_VAL
                                               TOT_SAMP_VAL
                                     --= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
                                     FROM   (  SELECT   A.P_N_CODE,
                                                        A.P_DESC,
                                                        A.PROM_TYPE,
                                                        A.CATEGORY,
                                                        A.PACK_SIZE,
                                                        A.SLNO,
                                                        A.FF_TYPE,
                                                        SUM(NVL(JAN_SAMP, 0)) AS JAN_SAMP,
                                                        SUM(NVL(FEB_SAMP, 0)) AS FEB_SAMP,
                                                        SUM(NVL(MAR_SAMP, 0)) AS MAR_SAMP,
                                                        SUM(NVL(APR_SAMP, 0)) AS APR_SAMP,
                                                        SUM(NVL(MAY_SAMP, 0)) AS MAY_SAMP,
                                                        SUM(NVL(JUN_SAMP, 0)) AS JUN_SAMP,
                                                        SUM(NVL(JUL_SAMP, 0)) AS JUL_SAMP,
                                                        SUM(NVL(AUG_SAMP, 0)) AS AUG_SAMP,
                                                        SUM(NVL(SEP_SAMP, 0)) AS SEP_SAMP,
                                                        SUM(NVL(OCT_SAMP, 0)) AS OCT_SAMP,
                                                        SUM(NVL(NOV_SAMP, 0)) AS NOV_SAMP,
                                                        SUM(NVL(DEC_SAMP, 0)) AS DEC_SAMP,
                                                        --= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
                                                        SUM(NVL(JAN_SAMP_VAL, 0)) AS JAN_SAMP_VAL,
                                                        SUM(NVL(FEB_SAMP_VAL, 0)) AS FEB_SAMP_VAL,
                                                        SUM(NVL(MAR_SAMP_VAL, 0)) AS MAR_SAMP_VAL,
                                                        SUM(NVL(APR_SAMP_VAL, 0)) AS APR_SAMP_VAL,
                                                        SUM(NVL(MAY_SAMP_VAL, 0)) AS MAY_SAMP_VAL,
                                                        SUM(NVL(JUN_SAMP_VAL, 0)) AS JUN_SAMP_VAL,
                                                        SUM(NVL(JUL_SAMP_VAL, 0)) AS JUL_SAMP_VAL,
                                                        SUM(NVL(AUG_SAMP_VAL, 0)) AS AUG_SAMP_VAL,
                                                        SUM(NVL(SEP_SAMP_VAL, 0)) AS SEP_SAMP_VAL,
                                                        SUM(NVL(OCT_SAMP_VAL, 0)) AS OCT_SAMP_VAL,
                                                        SUM(NVL(NOV_SAMP_VAL, 0)) AS NOV_SAMP_VAL,
                                                        SUM(NVL(DEC_SAMP_VAL, 0)) AS DEC_SAMP_VAL
                                                 --= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
                                                 FROM   (SELECT   A.P_N_CODE,
                                                                  A.P_DESC,
                                                                  A.PROM_TYPE,
                                                                  A.CATEGORY,
                                                                  A.PACK_SIZE,
                                                                  A.SLNO,
                                                                  A.FF_TYPE,
                                                                    DECODE(TO_CHAR(A.MNYR, 'MM'), '01', A.QNTY, 0) AS JAN_SAMP,
                                                                    DECODE(TO_CHAR(A.MNYR, 'MM'), '02', A.QNTY, 0) AS FEB_SAMP,
                                                                    DECODE(TO_CHAR(A.MNYR, 'MM'), '03', A.QNTY, 0) AS MAR_SAMP,
                                                                    DECODE(TO_CHAR(A.MNYR, 'MM'), '04', A.QNTY, 0) AS APR_SAMP,
                                                                    DECODE(TO_CHAR(A.MNYR, 'MM'), '05', A.QNTY, 0) AS MAY_SAMP,
                                                                    DECODE(TO_CHAR(A.MNYR, 'MM'), '06', A.QNTY, 0) AS JUN_SAMP,
                                                                    DECODE(TO_CHAR(A.MNYR, 'MM'), '07', A.QNTY, 0) AS JUL_SAMP,
                                                                    DECODE(TO_CHAR(A.MNYR, 'MM'), '08', A.QNTY, 0) AS AUG_SAMP,
                                                                    DECODE(TO_CHAR(A.MNYR, 'MM'), '09', A.QNTY, 0) AS SEP_SAMP,
                                                                    DECODE(TO_CHAR(A.MNYR, 'MM'), '10', A.QNTY, 0) AS OCT_SAMP,
                                                                    DECODE(TO_CHAR(A.MNYR, 'MM'), '11', A.QNTY, 0) AS NOV_SAMP,
                                                                    DECODE(TO_CHAR(A.MNYR, 'MM'), '12', A.QNTY, 0) AS DEC_SAMP,
                                                                  --= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
                                                                 DECODE(TO_CHAR(A.MNYR,'MM'),'01',A.QNTY*A.TOT_SAMP_COST,0) AS JAN_SAMP_VAL,
                                                                 DECODE(TO_CHAR(A.MNYR,'MM'),'02',A.QNTY*A.TOT_SAMP_COST,0) AS FEB_SAMP_VAL,
                                                                 DECODE(TO_CHAR(A.MNYR,'MM'),'03',A.QNTY*A.TOT_SAMP_COST,0) AS MAR_SAMP_VAL,
                                                                 DECODE(TO_CHAR(A.MNYR,'MM'),'04',A.QNTY*A.TOT_SAMP_COST,0) AS APR_SAMP_VAL,
                                                                 DECODE(TO_CHAR(A.MNYR,'MM'),'05',A.QNTY*A.TOT_SAMP_COST,0) AS MAY_SAMP_VAL,
                                                                 DECODE(TO_CHAR(A.MNYR,'MM'),'06',A.QNTY*A.TOT_SAMP_COST,0) AS JUN_SAMP_VAL,
                                                                 DECODE(TO_CHAR(A.MNYR,'MM'),'07',A.QNTY*A.TOT_SAMP_COST,0) AS JUL_SAMP_VAL,
                                                                 DECODE(TO_CHAR(A.MNYR,'MM'),'08',A.QNTY*A.TOT_SAMP_COST,0) AS AUG_SAMP_VAL,
                                                                 DECODE(TO_CHAR(A.MNYR,'MM'),'09',A.QNTY*A.TOT_SAMP_COST,0) AS SEP_SAMP_VAL,
                                                                 DECODE(TO_CHAR(A.MNYR,'MM'),'10',A.QNTY*A.TOT_SAMP_COST,0) AS OCT_SAMP_VAL,
                                                                 DECODE(TO_CHAR(A.MNYR,'MM'),'11',A.QNTY*A.TOT_SAMP_COST,0) AS NOV_SAMP_VAL,
                                                                 DECODE(TO_CHAR(A.MNYR,'MM'),'12',A.QNTY*A.TOT_SAMP_COST,0) AS DEC_SAMP_VAL
                                                                  
                                                           FROM   (SELECT   TRUNC (A.MNYR,'MON')MNYR,
                                                                            D.TYPE_DESC CATEGORY,
                                                                            B.P_N_CODE,
                                                                            A.PROM_TYPE,
                                                                            B.P_DESC,
                                                                            B.PACK1
                                                                            || 'X'
                                                                            || B.PACK2
                                                                               PACK_SIZE,
                                                                            A.QNTY,
                                                                            D.SLNO,
                                                                            'G' FF_TYPE,
                                                                            F.TOT_SAMP_COST
                                                                     FROM   PBMS_AVT.MON_PROM_BUDGET_TOT_AGRO A,
                                                                            SAM_PRODUCT B,
                                                                            SAMP_PLAN_TYPE D,
                                                                            PRODUCT E,
                                                                            (SELECT   TRUNC (A.MNYR,'MON')MNYR,A.P_N_CODE,A.SAMP_PACK_COST+ A.SAMP_PACK_VAT TOT_SAMP_COST
                                                                               FROM   PBMS_AVT.PROD_WISE_SAMP_COST_TP_HIST A,
                                                                                      PRODUCT B
                                                                              WHERE   A.P_CODE =  B.P_CODE
                                                                                      AND TO_CHAR (A.MNYR,'YYYY') ='2026'
                                                                             UNION ALL
                                                                             SELECT   TRUNC (B.MNYR,'MON')MNYR,A.P_N_CODE,A.SAMP_PACK_COST+ A.SAMP_PACK_VAT TOT_SAMP_COST
                                                                               FROM   PBMS_AVT.PROD_WISE_SAMP_COST_TP_HIST A,
                                                                                      (SELECT   MON MNYR
                                                                                         FROM   DT_MON
                                                                                        WHERE   MON >TRUNC (SYSDATE,'MON')
                                                                                                AND TO_CHAR (MON,'YYYY') ='2026')B,
                                                                                      PRODUCT C
                                                                              WHERE   A.P_CODE =C.P_CODE
                                                                                      AND TRUNC (A.MNYR,'MON') =TRUNC (SYSDATE,'MON'))
                                                                            F
                                                                    WHERE   NVL (QNTY,0) > 0
                                                                            AND A.PROM_CODE = B.P_N_CODE
                                                                            AND A.PROM_TYPE =D.TYPE_CODE
                                                                            AND SUBSTR (A.PROM_CODE,1,4) =E.P_CODE
                                                                            AND TO_CHAR (A.MNYR,'YYYY') ='2026'
                                                                            AND A.MNYR =F.MNYR(+)
                                                                            AND A.PROM_CODE =F.P_N_CODE(+))
                                                                  A) A
                                             GROUP BY   A.P_N_CODE,A.P_DESC,A.PROM_TYPE,A.CATEGORY,A.PACK_SIZE,A.SLNO,A.FF_TYPE) A,
                                            (  SELECT   PROM_TYPE, PROM_CODE P_N_CODE,
                                                        COUNT ( * ) EXPOSURE
                                                 FROM   PBMS_AVT.MON_PROM_BUDGET_TOT_AGRO A
                                                WHERE   NVL (QNTY, 0) > 0 
                                                 AND TO_CHAR (A.MNYR,'YYYY') ='2026'
                                             GROUP BY   PROM_TYPE, PROM_CODE) B
                                    WHERE   A.PROM_TYPE = B.PROM_TYPE(+)
                                            AND A.P_N_CODE = B.P_N_CODE(+)) A,
                                  (SELECT   FF_TYPE,
                                            TYPE_DESC FF_DESC,
                                            SLNO FF_SLNO
                                     FROM   SAMP_PLAN_TYPE
                                    WHERE   FF_TYPE IS NOT NULL) B
                          WHERE   A.FF_TYPE = B.FF_TYPE)
             GROUP BY   CATEGORY)
   --= = = = = = = = = = = = = = =
   UNION ALL
   --Special Sample
   SELECT   3.1 SLNO, CATEGORY, JAN, FEB, MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC, TOT , ROUND (NVL (TOT, 0) / (SELECT   TOT FROM AVT_SALES_FORECAST_BUD_VW),2) PARCEN
     FROM   (  SELECT   CATEGORY,
                        ROUND (SUM (NVL (JAN, 0))) JAN,
                        ROUND (SUM (NVL (FEB, 0))) FEB,
                        ROUND (SUM (NVL (MAR, 0))) MAR,
                        ROUND (SUM (NVL (APR, 0))) APR,
                        ROUND (SUM (NVL (MAY, 0))) MAY,
                        ROUND (SUM (NVL (JUN, 0))) JUN,
                        ROUND (SUM (NVL (JUL, 0))) JUL,
                        ROUND (SUM (NVL (AUG, 0))) AUG,
                        ROUND (SUM (NVL (SEP, 0))) SEP,
                        ROUND (SUM (NVL (OCT, 0))) OCT,
                        ROUND (SUM (NVL (NOV, 0))) NOV,
                        ROUND (SUM (NVL (DEC, 0))) DEC,
                          ROUND (SUM (NVL (JAN, 0)))
                        + ROUND (SUM (NVL (FEB, 0)))
                        + ROUND (SUM (NVL (MAR, 0)))
                        + ROUND (SUM (NVL (APR, 0)))
                        + ROUND (SUM (NVL (MAY, 0)))
                        + ROUND (SUM (NVL (JUN, 0)))
                        + ROUND (SUM (NVL (JUL, 0)))
                        + ROUND (SUM (NVL (AUG, 0)))
                        + ROUND (SUM (NVL (SEP, 0)))
                        + ROUND (SUM (NVL (OCT, 0)))
                        + ROUND (SUM (NVL (NOV, 0)))
                        + ROUND (SUM (NVL (DEC, 0)))
                           TOT
                 FROM   (SELECT   'Special Sample' CATEGORY,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '01', AMT, 0)JAN,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '02', AMT, 0)FEB,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '03', AMT, 0)MAR,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '04', AMT, 0)APR,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '05', AMT, 0)MAY,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '06', AMT, 0)JUN,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '07', AMT, 0)JUL,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '08', AMT, 0)AUG,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '09', AMT, 0)SEP,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '10', AMT, 0)OCT,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '11', AMT, 0)NOV,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '12', AMT, 0)DEC
                           FROM   (SELECT   MON MNYR, AMT
                                     FROM   DT_MON,
                                            (SELECT   ROUND (AMT / 12) AMT
                                               FROM   CMP_NON_BRAND_BUDGET
                                              WHERE   SERIAL = 24)
                                    WHERE   TRUNC (MON, 'YEAR') =
                                               TRUNC (SYSDATE, 'YEAR')))
             GROUP BY   CATEGORY)
   --= = = = = = = = = = = = = = =
   UNION ALL
   --Institue Sample
   SELECT   3.2 SLNO, CATEGORY,JAN,FEB,MAR, APR, MAY, JUN, JUL, AUG, SEP, OCT, NOV, DEC, TOT,
            ROUND (
               NVL (TOT, 0) / (SELECT   TOT FROM AVT_SALES_FORECAST_BUD_VW),
               2
            )
               PARCEN
     FROM   (  SELECT   CATEGORY,
                        ROUND (SUM (NVL (JAN, 0))) JAN,
                        ROUND (SUM (NVL (FEB, 0))) FEB,
                        ROUND (SUM (NVL (MAR, 0))) MAR,
                        ROUND (SUM (NVL (APR, 0))) APR,
                        ROUND (SUM (NVL (MAY, 0))) MAY,
                        ROUND (SUM (NVL (JUN, 0))) JUN,
                        ROUND (SUM (NVL (JUL, 0))) JUL,
                        ROUND (SUM (NVL (AUG, 0))) AUG,
                        ROUND (SUM (NVL (SEP, 0))) SEP,
                        ROUND (SUM (NVL (OCT, 0))) OCT,
                        ROUND (SUM (NVL (NOV, 0))) NOV,
                        ROUND (SUM (NVL (DEC, 0))) DEC,
                          ROUND (SUM (NVL (JAN, 0)))
                        + ROUND (SUM (NVL (FEB, 0)))
                        + ROUND (SUM (NVL (MAR, 0)))
                        + ROUND (SUM (NVL (APR, 0)))
                        + ROUND (SUM (NVL (MAY, 0)))
                        + ROUND (SUM (NVL (JUN, 0)))
                        + ROUND (SUM (NVL (JUL, 0)))
                        + ROUND (SUM (NVL (AUG, 0)))
                        + ROUND (SUM (NVL (SEP, 0)))
                        + ROUND (SUM (NVL (OCT, 0)))
                        + ROUND (SUM (NVL (NOV, 0)))
                        + ROUND (SUM (NVL (DEC, 0)))
                           TOT
                 FROM   (SELECT   'Institue Sample' CATEGORY,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '01', AMT, 0)JAN,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '02', AMT, 0)FEB,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '03', AMT, 0)MAR,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '04', AMT, 0)APR,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '05', AMT, 0)MAY,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '06', AMT, 0)JUN,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '07', AMT, 0)JUL,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '08', AMT, 0)AUG,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '09', AMT, 0)SEP,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '10', AMT, 0)OCT,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '11', AMT, 0)NOV,
                                  DECODE (TO_CHAR (MNYR, 'MM'), '12', AMT, 0)DEC
                           FROM   (SELECT   MON MNYR, AMT
                                     FROM   DT_MON,
                                            (SELECT   ROUND (AMT / 12) AMT
                                               FROM   CMP_NON_BRAND_BUDGET
                                              WHERE   SERIAL = 25)
                                    WHERE   TRUNC (MON, 'YEAR') =
                                               TRUNC (SYSDATE, 'YEAR')))
             GROUP BY   CATEGORY);


