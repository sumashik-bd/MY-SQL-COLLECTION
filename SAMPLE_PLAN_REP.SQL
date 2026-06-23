SELECT A.P_N_CODE, A.P_DESC, SUM(NVL(TOT_SAMP_COST,0)) TOT_SAMP_COST,A.PROM_TYPE, A.CATEGORY, A.PACK_SIZE, A.SLNO, A.FF_TYPE,
       SUM(NVL(JAN_SAMP,0)) JAN_SAMP,
       SUM(NVL(FEB_SAMP,0)) FEB_SAMP,
       SUM(NVL(MAR_SAMP,0)) MAR_SAMP,
       SUM(NVL(APR_SAMP,0)) APR_SAMP,
       SUM(NVL(MAY_SAMP,0)) MAY_SAMP,
       SUM(NVL(JUN_SAMP,0)) JUN_SAMP,
       SUM(NVL(JUL_SAMP,0)) JUL_SAMP,
       SUM(NVL(AUG_SAMP,0)) AUG_SAMP,
       SUM(NVL(SEP_SAMP,0)) SEP_SAMP,
       SUM(NVL(OCT_SAMP,0)) OCT_SAMP,
       SUM(NVL(NOV_SAMP,0)) NOV_SAMP,
       SUM(NVL(DEC_SAMP,0)) DEC_SAMP
       --= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

       --= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
FROM(
SELECT A.P_N_CODE, A.P_DESC,A.TOT_SAMP_COST, A.PROM_TYPE, A.CATEGORY, A.PACK_SIZE, A.SLNO, A.FF_TYPE,
       DECODE(TO_CHAR(A.MNYR,'MM'),'01', A.QNTY, 0) JAN_SAMP,
       DECODE(TO_CHAR(A.MNYR,'MM'),'02', A.QNTY, 0) FEB_SAMP,
       DECODE(TO_CHAR(A.MNYR,'MM'),'03', A.QNTY, 0) MAR_SAMP,
       DECODE(TO_CHAR(A.MNYR,'MM'),'04', A.QNTY, 0) APR_SAMP,
       DECODE(TO_CHAR(A.MNYR,'MM'),'05', A.QNTY, 0) MAY_SAMP,
       DECODE(TO_CHAR(A.MNYR,'MM'),'06', A.QNTY, 0) JUN_SAMP,
       DECODE(TO_CHAR(A.MNYR,'MM'),'07', A.QNTY, 0) JUL_SAMP,
       DECODE(TO_CHAR(A.MNYR,'MM'),'08', A.QNTY, 0) AUG_SAMP,
       DECODE(TO_CHAR(A.MNYR,'MM'),'09', A.QNTY, 0) SEP_SAMP,
       DECODE(TO_CHAR(A.MNYR,'MM'),'10', A.QNTY, 0) OCT_SAMP,
       DECODE(TO_CHAR(A.MNYR,'MM'),'11', A.QNTY, 0) NOV_SAMP,
       DECODE(TO_CHAR(A.MNYR,'MM'),'12', A.QNTY, 0) DEC_SAMP     
       --= = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

FROM(
SELECT TRUNC(A.MNYR,'MON') MNYR, D.TYPE_DESC CATEGORY, B.P_N_CODE, A.PROM_TYPE, B.P_DESC, B.PACK1||'X'||B.PACK2 PACK_SIZE, A.QNTY, D.SLNO, E.PROD_GRP FF_TYPE, NVL(F.TOT_SAMP_COST,0) TOT_SAMP_COST
FROM PBMS_OPL.MON_PROM_PLAN_TOT A, SAM_PRODUCT B, SAMP_PLAN_TYPE D, PRODUCT E, ( SELECT TRUNC(A.MNYR,'MON') MNYR, A.P_N_CODE, A.TOT_SAMP_COST
                                                                                 FROM PBMS_OPL.PROD_WISE_SAMP_COST_COGS_HIST A, PRODUCT B
                                                                                 WHERE A.P_CODE               = B.P_CODE
                                                                                 AND   B.REG_ID_DAFN          = '025'
                                                                                 AND    A.MNYR          =     '01-JUL-2025'
                                                                               ) F
WHERE NVL(QNTY,0)>0
AND   E.REG_ID_DAFN = '025'
AND   A.PROM_CODE = B.P_N_CODE
AND   A.PROM_TYPE = D.TYPE_CODE 
AND   SUBSTR(A.PROM_CODE,1,4) = E.P_CODE
AND   TO_CHAR(A.MNYR,'YYYY') = :VYEAR
AND   A.MNYR      = F.MNYR(+)
AND   A.PROM_CODE = F.P_N_CODE(+)
UNION ALL
SELECT TRUNC(A.MNYR,'MON') MNYR, D.TYPE_DESC CATEGORY, B.P_N_CODE, A.PROM_TYPE, B.P_DESC, B.PACK1||'X'||B.PACK2 PACK_SIZE, A.QNTY, D.SLNO, E.PROD_GRP FF_TYPE, F.TOT_SAMP_COST
FROM PBMS_OPL.MON_PROM_PLAN_TOT A, PBMS_OHNL.SAM_PRODUCT@OHL B, SAMP_PLAN_TYPE D, PRODUCT E, ( 
                                                                                               SELECT TRUNC(A.MNYR,'MON') MNYR, A.P_N_CODE, A.TOT_SAMP_COST
                                                                                               FROM PBMS_OHNL.PROD_WISE_SAMP_COST_COGS_HIST@OHL A, PRODUCT B
                                                                                               WHERE A.P_CODE               = B.P_CODE
                                                                                               AND   B.REG_ID_DAFN          = '033'
                                                                                               AND    A.MNYR          =       '01-JUL-2025'
                                                                                             ) F
WHERE NVL(QNTY,0)>0
AND   E.REG_ID_DAFN = '033'
AND   A.PROM_CODE = B.P_N_CODE
AND   A.PROM_TYPE = D.TYPE_CODE
AND   SUBSTR(A.PROM_CODE,1,4) = E.P_CODE
AND   TO_CHAR(A.MNYR,'YYYY') = :VYEAR
AND   A.MNYR      = F.MNYR(+)
AND   A.PROM_CODE = F.P_N_CODE(+)

) A
) A
GROUP BY A.P_N_CODE, A.P_DESC,A.PROM_TYPE, A.CATEGORY, A.PACK_SIZE, A.SLNO, A.FF_TYPE
ORDER BY P_DESC;




------------------------TEAM WISE SAMPLE PLAN REPORT--------------------------------------------
-------------------------------------------------------------------------------------------------
SELECT TO_CHAR(TRUNC(A.MNYR,'YEAR'),'YYYY')YR, A.PROM_CODE,TYPE_DESC, C.P_DESC,PACK1||'X'||PACK2 PACK_SIZE, PACK, TOT_SAMP_COST COGS, SUM(QNTY)QNTY, SUM(QNTY)*TOT_SAMP_COST TOT_SAMP_COST
FROM MON_PROM_PLAN_TOT A, SAMP_PLAN_TYPE B , SAM_PRODUCT C,(SELECT P_N_CODE, P_CODE,TOT_SAMP_COST
                                                                    FROM 
                                                                    PROD_WISE_SAMP_COST_COGS_HIST
                                                                    WHERE MNYR          =       (SELECT MAX(MNYR) FROM PROD_WISE_SAMP_COST_COGS_HIST)) D
WHERE A.PROM_TYPE=B.TYPE_CODE
AND A.PROM_CODE=C.P_N_CODE
AND A.PROM_CODE =D.P_N_CODE
AND TRUNC(A.MNYR,'YEAR')='01-JAN-2025'
AND C.P_CODE IN (SELECT P_CODE FROM PRODUCT WHERE TEAM_GRP='V')
AND A.PROM_TYPE IN ('ES','IN','HM','PC')
GROUP BY TRUNC(A.MNYR,'YEAR'), A.PROM_CODE,TYPE_DESC, C.P_DESC, PACK1||'X'||PACK2, PACK,TOT_SAMP_COST
ORDER BY TYPE_DESC,P_DESC;

-------=====================================================================================
SELECT TO_CHAR(TRUNC(A.MNYR,'MON'),'MON-YYYY')YR, A.PROM_CODE,TYPE_DESC, C.P_DESC,PACK1||'X'||PACK2 PACK_SIZE, PACK, TOT_SAMP_COST COGS, SUM(QNTY)QNTY, SUM(QNTY)*TOT_SAMP_COST TOT_SAMP_COST
FROM MON_PROM_PLAN_TOT A, SAMP_PLAN_TYPE B , SAM_PRODUCT C,(SELECT P_N_CODE, P_CODE,TOT_SAMP_COST
                                                                    FROM 
                                                                    PROD_WISE_SAMP_COST_COGS_HIST
                                                                    WHERE MNYR          =       (SELECT MAX(MNYR) FROM PROD_WISE_SAMP_COST_COGS_HIST)) D
WHERE A.PROM_TYPE=B.TYPE_CODE
AND A.PROM_CODE=C.P_N_CODE
AND A.PROM_CODE =D.P_N_CODE
AND TRUNC(A.MNYR,'MON')='01-MAR-2026'
AND C.P_CODE IN (SELECT P_CODE FROM PRODUCT WHERE TEAM_GRP='U')
AND A.PROM_TYPE IN ('GC','IN','HM','PC')
GROUP BY TRUNC(A.MNYR,'MON'), A.PROM_CODE,TYPE_DESC, C.P_DESC, PACK1||'X'||PACK2, PACK,TOT_SAMP_COST
ORDER BY TYPE_DESC,P_DESC;
