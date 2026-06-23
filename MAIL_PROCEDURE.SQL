CREATE OR REPLACE PROCEDURE PBMS_OPL.BILL_MAIL_TO_MSD_GM_PRO
IS
    L_HTML        CLOB;
    VAR_CC        CLOB;
    VAR_FROM      VARCHAR2(3000) := 'mit@opsonin.net';
    VAR_SUBJECT   VARCHAR2(3000);
    V_FIX         CLOB;
    CC_MAIL       VARCHAR2(4000);
    VAR_HEAD      CLOB;
    VAR_TAB_TXT   CLOB;
    VAR_TAB_ROWS  CLOB;
    VAR_TAB_ROWS1 CLOB;
    V_NO          NUMBER;
    V_ERROR       CLOB;

    CURSOR C1_MAIN IS
            SELECT E_MAIL FROM(
            SELECT DISTINCT 'gms@opsonin.net' E_MAIL
            FROM DUAL
            UNION ALL
            SELECT DISTINCT 'jalam.opl@opsonin.net' E_MAIL
            FROM DUAL
            );

BEGIN

    /* Get CC Mail List */
    SELECT LISTAGG(E_MAIL, ',') WITHIN GROUP (ORDER BY SL, EMP_CODE, E_MAIL) || ',mit@opsonin.net,anowar@opsonin.net'
    INTO CC_MAIL
    FROM (
            SELECT 1 SL,
                   A.EMP_CODE,
                   EMAIL_OPSONIN E_MAIL
            FROM PMIS_EMP_ALL_V A,
                 PMIS_EMP_OTHERS B
            WHERE A.EMP_CODE = B.EMP_CODE
              AND DEPT_CODE = '00024'
              AND JOB_GRADE_CODE IN ('M-7','M-6','M-5')
              AND JOB_CATEGORY IN(1,2)
              AND EMAIL_OPSONIN IS NOT NULL

            UNION ALL

            SELECT 2 SL,
                   A.EMP_CODE,
                   EMAIL_OPSONIN E_MAIL
            FROM PMIS_EMP_ALL_V A,
                 PMIS_EMP_OTHERS B
            WHERE A.EMP_CODE = B.EMP_CODE
              AND DEPT_CODE = '00024'
              AND JOB_GRADE_CODE IN ('M-10','M-9','M-8')
              AND EMAIL_OPSONIN IS NOT NULL
              AND JOB_CATEGORY IN(1,2)

            UNION ALL

            SELECT 3 SL,
                   A.EMP_CODE,
                   EMAIL_OPSONIN E_MAIL
            FROM PMIS_EMP_ALL_V A,
                 PMIS_EMP_OTHERS B
            WHERE A.EMP_CODE = B.EMP_CODE
              AND DEPT_CODE = '00024'
              AND JOB_GRADE_CODE IN ('M-11','M-12','M-13','M-14','M-15')
              AND EMAIL_OPSONIN IS NOT NULL
              AND JOB_CATEGORY IN(2)
         );

    VAR_CC := CC_MAIL;

    FOR REC_M IN C1_MAIN LOOP

        L_HTML :=
               '<HTML>
                  <HEAD>
                     <TITLE>UNTITLED DOCUMENT</TITLE>
                  </HEAD>';

        VAR_HEAD :=
               '<BODY>
                  <p><b>Dear Sir,</b><br />
                  <p>Please be informed that your proposed Scientific Seminar/CME/Intern Reception/Doctor''s Day Outing/Stall and Day Celebration Program''s Approved Bill for adjustment has been sent to your depot as following -</p>';

        VAR_TAB_TXT :=
               '<TABLE WIDTH="100%" BORDER="1" CELLPADDING="0" CELLSPACING="0">

                <TR>
                    <TD COLSPAN="10" ALIGN="CENTER" BGCOLOR="#CC99FF">
                        MSD Programs Bill Adjustment Details
                    </TD>
                </TR>

                <TR ALIGN="CENTER" BGCOLOR="#666666" STYLE="COLOR:#FFFF00">
                    <TD>Slno</TD>
                    <TD>Requisition Slno</TD>
                    <TD>Bill Slno</TD>
                    <TD>Meeting Date</TD>
                    <TD>Institute Name</TD>
                    <TD>Region</TD>
                    <TD>Depot Name</TD>
                    <TD>Approved Amount</TD>
                    <TD>Bill Amount</TD>
                    <TD>Over Expense/Remaining Balance</TD>
                </TR>';

        V_NO := 0;

        DECLARE

            CURSOR C1 IS
                SELECT MSD_SLNO,
                       BILL_SLNO,
                       FOR_MON,
                       INST_CODE,
                       INST_DESC,
                       VENUE,
                       PROPOSE_MPO,
                       DEPOT_CODE,
                       DEPOT_DESC,
                       RM_CODE,
                       REGION,
                       TO_CHAR(REQ_AMT,'99,99,99,999') REQ_AMT,
                       TO_CHAR(BILL_AMT,'99,99,99,999') BILL_AMT,
                       BALANCE_STATUS
                FROM MSD_BILL_MAIL_VW
                ORDER BY RM_CODE;

        BEGIN

            VAR_TAB_ROWS := NULL;

            FOR REC IN C1 LOOP

                V_NO := V_NO + 1;

                VAR_TAB_ROWS :=
                    VAR_TAB_ROWS ||
                    '<TR ALIGN="CENTER">
                        <TD>'||V_NO||'</TD>
                        <TD><B>'||REC.MSD_SLNO||'</B></TD>
                        <TD><B>'||REC.BILL_SLNO||'</B></TD>
                        <TD>'||REC.FOR_MON||'</TD>
                        <TD STYLE="TEXT-ALIGN:LEFT">'||REC.INST_DESC||'</TD>
                        <TD>'||REC.REGION||'</TD>
                        <TD>'||REC.DEPOT_DESC||'</TD>
                        <TD><B>'||REC.REQ_AMT||'</B></TD>
                        <TD><B>'||REC.BILL_AMT||'</B></TD>
                        <TD><B>'||REC.BALANCE_STATUS||'</B></TD>
                     </TR>';

            END LOOP;

        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;

        BEGIN

            VAR_TAB_TXT := VAR_TAB_TXT || VAR_TAB_ROWS || '</TABLE><BR />';

            L_HTML := L_HTML || VAR_HEAD || VAR_TAB_TXT;

            L_HTML :=
                L_HTML ||
                '<b><p>
                Thanks and Regards,<br /><br />
                Md. Ilias Talukder<br />
                Sr. Executive, Sales Management<br />
                Opsonin Pharma Limited<br />
                Corporate Headquaters<br />
                30 New Eskaton Road, Dhaka-1000<br />
                T: 02-48311900, 02-55142000, Ext. 1810<br />
                Cell : 01730034429
                </p></b></BODY></HTML>';

            IF REC_M.E_MAIL IS NOT NULL THEN

                SEND_MAIL_HTML_LP(
                    P_TO       => REC_M.E_MAIL,
                    P_CC       => VAR_CC,
                    P_FROM     => VAR_FROM,
                    P_SUBJECT  => 'Regarding MSD Programs Approved Bill for Adjustment Notification to Depot',
                    P_TEXT_MSG => NULL,
                    P_HTML_MSG => L_HTML
                );

            END IF;

        EXCEPTION
            WHEN OTHERS THEN
                NULL;
        END;

        L_HTML := NULL;
        VAR_SUBJECT := NULL;

    END LOOP;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE(SQLERRM);
END;
/
