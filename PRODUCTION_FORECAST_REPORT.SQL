
SELECT A.MNYR, A.P_CODE, B.P_DESC, B.PACK_SIZE1||'X'||B.PACK_SIZE2 PACK,PROD_STAT, SUM(NVL(A.T_QNTY_FINAL,0)) PROD_FORECAST,DECODE(NVL(B.PROD_GRP,'G'), 'G', 'GEN-A', 'T', 'GEN-B','U','GEN-C', 'I', 'SPE-E', 'C', 'SPE-D', 'V', 'SPE-F') TEAM 
FROM ERP_OPL.ROLLING_FORECAST A, PRODUCT B, BRAND C
WHERE A.P_CODE     = B.P_CODE
AND   B.BRAND_CODE = C.BRAND_CODE
AND   TRUNC(A.MNYR,'MON')  BETWEEN '01-JAN-2024' AND '01-DEC-2025'
AND   NVL(A.T_QNTY_SALE,0)>0
AND   B.PROD_GRP IN('G','T','U','I','C','V')
GROUP BY A.MNYR, A.P_CODE, B.P_DESC, B.PACK_SIZE1||'X'||B.PACK_SIZE2, PROD_STAT,DECODE(NVL(B.PROD_GRP,'G'), 'G', 'GEN-A', 'T', 'GEN-B','U','GEN-C', 'I', 'SPE-E', 'C', 'SPE-D', 'V', 'SPE-F')
ORDER BY A.MNYR, B.P_DESC;

-----------------------------PRODUCTION FOREACE REPORT 
SELECT *
FROM
(
    SELECT  A.P_CODE,
            B.P_DESC,
            B.PACK_SIZE1 || 'X' || B.PACK_SIZE2 PACK,
            B.PROD_STAT,

            TO_CHAR(A.MNYR,'MON') || '_' || 
            TO_CHAR(A.MNYR,'YYYY') PERIOD,

            SUM(NVL(A.T_QNTY_FINAL,0)) PROD_FORECAST,

            DECODE(NVL(B.PROD_GRP,'G'),
                   'G', 'GEN-A',
                   'T', 'GEN-B',
                   'U', 'GEN-C',
                   'I', 'SPE-E',
                   'C', 'SPE-D',
                   'V', 'SPE-F') TEAM

    FROM ERP_OPL.ROLLING_FORECAST A,
         PRODUCT B,
         BRAND C
    WHERE A.P_CODE = B.P_CODE
    AND   B.BRAND_CODE = C.BRAND_CODE
    AND   TRUNC(A.MNYR,'MON')
              BETWEEN TO_DATE('01-JAN-2024','DD-MON-YYYY')
                  AND TO_DATE('01-DEC-2025','DD-MON-YYYY')
    AND   NVL(A.T_QNTY_SALE,0) > 0
    AND   B.PROD_GRP IN ('G','T','U','I','C','V')

    GROUP BY
            A.P_CODE,
            B.P_DESC,
            B.PACK_SIZE1 || 'X' || B.PACK_SIZE2,
            B.PROD_STAT,

            TO_CHAR(A.MNYR,'MON') || '_' ||
            TO_CHAR(A.MNYR,'YYYY'),

            DECODE(NVL(B.PROD_GRP,'G'),
                   'G', 'GEN-A',
                   'T', 'GEN-B',
                   'U', 'GEN-C',
                   'I', 'SPE-E',
                   'C', 'SPE-D',
                   'V', 'SPE-F')
)
PIVOT
(
    SUM(PROD_FORECAST)
    FOR PERIOD IN
    (
        'JAN_2024' AS JAN_2024,
        'FEB_2024' AS FEB_2024,
        'MAR_2024' AS MAR_2024,
        'APR_2024' AS APR_2024,
        'MAY_2024' AS MAY_2024,
        'JUN_2024' AS JUN_2024,
        'JUL_2024' AS JUL_2024,
        'AUG_2024' AS AUG_2024,
        'SEP_2024' AS SEP_2024,
        'OCT_2024' AS OCT_2024,
        'NOV_2024' AS NOV_2024,
        'DEC_2024' AS DEC_2024,

        'JAN_2025' AS JAN_2025,
        'FEB_2025' AS FEB_2025,
        'MAR_2025' AS MAR_2025,
        'APR_2025' AS APR_2025,
        'MAY_2025' AS MAY_2025,
        'JUN_2025' AS JUN_2025,
        'JUL_2025' AS JUL_2025,
        'AUG_2025' AS AUG_2025,
        'SEP_2025' AS SEP_2025,
        'OCT_2025' AS OCT_2025,
        'NOV_2025' AS NOV_2025,
        'DEC_2025' AS DEC_2025
    )
)
ORDER BY P_DESC;