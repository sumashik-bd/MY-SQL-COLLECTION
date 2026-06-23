-- FUNCTION CALL

function CF_WORDFormula return Char is
ctrl varchar2(300);
begin
  select spel_out(:SumTOTAL_TKPerReport)||'Only' into ctrl from dual;
  return ctrl;
end;

-- FUNCTION BODY ---

DROP FUNCTION GL_DEVOY.SPEL_OUT;

CREATE OR REPLACE FUNCTION GL_DEVOY.spel_out(a_number number) return char is
type numtab is table of
varchar2(30)
index by binary_integer;
number_chart numtab;
 crore number;
lakh number;
thou number;
hund number;
 doubl number;
sing number;
deci number;
text varchar2(1000);
begin
 --The Table
number_chart(1):='One';
number_chart(2):='Two';
number_chart(3):='Three';
number_chart(4):='Four';
number_chart(5):='Five';
number_chart(6):='Six';
number_chart(7):='Seven';
number_chart(8):='Eight';
number_chart(9):='Nine';
number_chart(10):='Ten';
number_chart(11):='Eleven';
number_chart(12):='Twelve';
number_chart(13):='Thirteen';
number_chart(14):='Fourteen';
number_chart(15):='Fifteen';
number_chart(16):='Sixteen';
number_chart(17):='Seventeen';
number_chart(18):='Eighteen';
number_chart(19):='Nineteen';
number_chart(20):='Twenty';
number_chart(30):='Thirty';
number_chart(40):='Forty';
number_chart(50):='Fifty';
number_chart(60):='Sixty';
number_chart(70):='Seventy';
number_chart(80):='Eighty';
number_chart(90):='Ninety';
crore:=floor(a_number/10000000);
lakh:=floor((a_number-trunc(a_number,-7))/100000);
thou:=floor((a_number-trunc(a_number,-5))/1000);
hund:=floor((a_number-trunc(a_number,-3))/100);
doubl:=trunc(a_number-trunc(a_number,-2),0);
sing:=trunc(a_number-trunc(a_number,-1),0);
deci:=(a_number-trunc(a_number,0))*100;
if crore<>0 then
 text:=spel_out(crore)||' '||'Crore ';
end if;
if lakh <>0 then
 if (lakh<=20)  or  (lakh mod 10=0) then
  text:=text||number_chart(lakh)||' Lac ';
 else
  text:=text||number_chart(trunc(lakh,-1))||'-'||number_chart(trunc(lakh,0)-trunc(lakh,-1))||' Lac ';
     end if;
end if;
if thou <>0 then
 if (thou<=20)  or  (thou mod 10=0) then
  text:=text||number_chart(thou)||' Thousand ';
 else
  text:=text||number_chart(trunc(thou,-1))||'-'||number_chart(trunc(thou,0)-trunc(thou,-1))||' Thousand ';
     end if;
end if;
if hund <>0 then
 if (hund<=20)  or  (hund mod 10=0) then
  text:=text||number_chart(hund)||' Hundred ';
 else
  text:=text||number_chart(trunc(hund,-1))||'-'||number_chart(trunc(hund,0)-trunc(hund,-1))||' Hundred ';
     end if;
end if;
if doubl <>0 then
 if (doubl<=20)  or  (doubl mod 10=0) then
  text:=text||number_chart(doubl)||' ';
 else
  text:=text||number_chart(trunc(doubl,-1))||'-'||number_chart(trunc(doubl,0)-trunc(doubl,-1))||' ';
     end if;
end if;
if deci <>0 then
 if (deci<=20)  or  (deci mod 10=0) then
  text:=text||' With '||number_chart(deci)||' Paisa ';
 else
  text:=text||' With '||number_chart(trunc(deci,-1))||'-'||number_chart(trunc(deci,0)-trunc(deci,-1))||' Paisa ';
     end if;
end if;
 return(text);
end spel_out;
/


DROP FUNCTION GL_DEVOY.F_IP;

CREATE OR REPLACE FUNCTION GL_DEVOY.F_IP RETURN VARCHAR2 IS
  BEGIN
    RETURN SYS_CONTEXT('USERENV', 'IP_ADDRESS');
   END;
/


DROP FUNCTION GL_DEVOY.FNC_WORD;

CREATE OR REPLACE FUNCTION GL_DEVOY.FNC_WORD (LNTH NUMBER ,FULL_TXT VARCHAR2) RETURN CHAR
IS
V_FULL_TXT  VARCHAR2(1000);
V_TXT2      VARCHAR2(1000);
V_TXT_LN    NUMBER(10);
V1          NUMBER := 1;
V2          NUMBER ;
V_LENGTH    NUMBER :=0;
V_COMP      NUMBER :=0;
V_RTN_TXT   VARCHAR2(1000);
V_TXT       VARCHAR2(1000);
V_CHK_WORD  NUMBER := 0;
BEGIN
    V_COMP := LNTH ;
    BEGIN
        SELECT RTRIM(LTRIM(FULL_TXT)),TXT_LN INTO V_FULL_TXT,V_TXT_LN FROM
        (SELECT (FULL_TXT) FULL_TXT ,TO_NUMBER(LENGTH(FULL_TXT)) TXT_LN FROM DUAL);
    EXCEPTION
        WHEN OTHERS THEN
        NULL;
    END ;
    V_TXT2 := V_FULL_TXT ;
    FOR REC IN 1..V_TXT_LN LOOP
       SELECT INSTR(RTRIM(LTRIM(V_FULL_TXT)),' ') INTO V2 FROM DUAL ;
          IF V_FULL_TXT IS NOT NULL AND V2 = 0 THEN
               V2  :=  LENGTH(V_FULL_TXT) ;    
             V_CHK_WORD := 1; 
          END IF;
          V_TXT := SUBSTR(RTRIM(LTRIM(V_FULL_TXT)),1,V2) ;
          V1  :=  LENGTH(V_TXT) ;    
         IF V_COMP >= V1 AND V_FULL_TXT IS NOT NULL THEN
               V_RTN_TXT := RTRIM(LTRIM(V_RTN_TXT))||' '||V_TXT ;
         ELSE
           EXIT ;
         END IF;
           V_COMP     := V_COMP - V1 ;
           V_LENGTH   := V_LENGTH + V1;
           V_FULL_TXT := SUBSTR(RTRIM(LTRIM(V_TXT2)),V_LENGTH) ;    
         IF V_CHK_WORD > 0  THEN    
           V_FULL_TXT := NULL;
         END IF;                            
    END LOOP ;
 RETURN RTRIM(LTRIM(V_RTN_TXT));
EXCEPTION
WHEN OTHERS THEN
RETURN '';
END;
/


DROP FUNCTION GL_DEVOY.FNC_STRIPPER;

CREATE OR REPLACE FUNCTION GL_DEVOY.fnc_stripper (p_string VARCHAR2 ) RETURN VARCHAR2
IS
v_current_element NUMBER;   -- # of elements in string being processed
v_char_length NUMBER;   -- length of parameter
v_ret_val VARCHAR2 (2000);   -- return value
v_current_char VARCHAR2 (1);   -- the character being processed
BEGIN
  v_char_length := LENGTH (p_string);
   v_current_element := 1;
   LOOP
     EXIT WHEN v_current_element > v_char_length;
         v_current_char := SUBSTR (p_string, v_current_element, 1);
    IF    TRANSLATE (v_current_char, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.#,-_', '~~~~~~~~~~') != '~'
        OR v_current_char = '~'
      THEN
         v_ret_val := v_ret_val || v_current_char;
      END IF;
         v_current_element := v_current_element + 1;
   END LOOP;   -- every character in the string
   RETURN (v_ret_val);
EXCEPTION
WHEN OTHERS THEN
RETURN ' ';
END;
/


DROP FUNCTION GL_DEVOY.FNC_INTEREST_CAL;

CREATE OR REPLACE FUNCTION GL_DEVOY.FNC_INTEREST_CAL(INV_VAL NUMBER,INTER_RATE NUMBER DEFAULT 12.5,V_DAY NUMBER)
RETURN NUMBER IS

    V_INTER_VAL NUMBER(20,5);

BEGIN

     SELECT ((INV_VAL*(INTER_RATE/100))/360)*V_DAY INTO V_INTER_VAL FROM DUAL;
     RETURN V_INTER_VAL;

EXCEPTION
    WHEN OTHERS THEN
        RETURN 0;

END;
/


DROP FUNCTION GL_DEVOY.DC_FUNC;

CREATE OR REPLACE FUNCTION GL_DEVOY.DC_FUNC(sysdat date) RETURN char IS
dd varchar2(2);
mm varchar2(2);
yyyy varchar2(4);
hh varchar2(4);
mi varchar2(2);
ss varchar2(2);
BEGIN
  select 
       to_number(to_char(sysdat,'dd'))+30 dd, 
       lpad(to_number(to_char(sysdat,'mm'))+to_number(to_char(sysdat,'dd')),2,0) mm,
       lpad(to_number(to_char(sysdat,'yyyy'))+to_number(to_char(sysdat,'mm')),4,0) yyyy, 
       lpad(to_number(to_char(sysdat,'hh24'))+to_number(to_char(sysdat,'yyyy')),4,0) hh,
       lpad(to_number(to_char(sysdat,'mi'))+to_number(to_char(sysdat,'hh24')),2,0) mi, 
       lpad(to_number(to_char(sysdat,'ss'))+to_number(to_char(sysdat,'mi')),2,0) ss
       into dd,mm,yyyy,hh,mi,ss
      from dual;
      return (dd||mm||yyyy||hh||mi||ss);
exception
    when others then
    return ' ';
END;
/

DROP FUNCTION TDMS_OPL.TSPC;

CREATE OR REPLACE FUNCTION TDMS_OPL.TSPC (TNAME VARCHAR2)
RETURN NUMBER IS
N NUMBER;
BEGIN
 SELECT SUM(BYTES)/(1024*1024) INTO N  FROM USER_SEGMENTS
 WHERE SEGMENT_NAME= TNAME;
  RETURN (N);
  EXCEPTION
   WHEN OTHERS THEN
  RETURN (0);
END;
/


DROP FUNCTION TDMS_OPL.SACMO_INT_FNC_SLNO;

CREATE OR REPLACE FUNCTION TDMS_OPL.SACMO_INT_FNC_SLNO RETURN NUMBER
IS
VSLNO NUMBER:=0;
BEGIN
SELECT SACMO_INT_ALLO_SEQ.NEXTVAL INTO VSLNO FROM DUAL;
RETURN (VSLNO);
EXCEPTION
WHEN OTHERS THEN
RETURN NULL;
END;
/


DROP FUNCTION TDMS_OPL.REC_CNT_UPD;

CREATE OR REPLACE FUNCTION TDMS_OPL.REC_CNT_UPD (V_P_CODE VARCHAR2)
RETURN NUMBER IS
X NUMBER :=0;
BEGIN
 SELECT COUNT(DISTINCT P_CODE) INTO X
 FROM  MON_MPO_PROD_MKT_TAR_DONE
 WHERE P_CODE =V_P_CODE;
   RETURN (X);
  EXCEPTION
   WHEN OTHERS THEN
  RETURN (0);
END;
/


DROP FUNCTION TDMS_OPL.REC_CNT;

CREATE OR REPLACE FUNCTION TDMS_OPL.REC_CNT (V_DATE DATE,V_MPO_CODE VARCHAR2,V_P_CODE VARCHAR2)
RETURN NUMBER IS
X NUMBER :=0;
BEGIN
 SELECT COUNT(*) INTO X
 FROM  MON_MPO_PROD_MKT_TAR
 WHERE TRUNC(MNYR,'MON') =TRUNC(V_DATE,'MON')
 AND MPO_CODE =V_MPO_CODE AND P_CODE =V_P_CODE;
   RETURN (X);
  EXCEPTION
   WHEN OTHERS THEN
  RETURN (0);
END;
/


DROP FUNCTION TDMS_OPL.ISCHARACTER;

CREATE OR REPLACE FUNCTION TDMS_OPL.ISCHARACTER(PSTR IN VARCHAR2) RETURN BOOLEAN IS 
VSTR VARCHAR2(10) := ' abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ' ; 
BEGIN 
-- 
-- LOOP FROM START TO END OF THE PASSED STRING 
-- 
FOR I IN 1..LENGTH(PSTR) LOOP 
-- 
-- CHECK WETHER ALL THE CHARACTER LIE BETWEEM ('A' AND 'Z' OR 'A' AND 'Z' OR 'SPACE CHARACTER') 
-- 
IF INSTR(VSTR, SUBSTR(PSTR, I, 1)) = 0 THEN 
RETURN FALSE ; 
EXIT ; 
END IF ; -- IF INSTR(VSTR, SUBSTR(PSTR, I, 1)) = 0 
END LOOP ; -- END OF FOR LOOP 
-- 
RETURN TRUE ; 
END ;
/


DROP FUNCTION TDMS_OPL.INST_ADD_FUNC;

CREATE OR REPLACE FUNCTION TDMS_OPL.INST_ADD_FUNC (VINST VARCHAR2) RETURN VARCHAR2
IS
VINST_ADD VARCHAR2(500);
BEGIN
SELECT RTRIM(LTRIM(DECODE(A.ROOM_NO,NULL,NULL,'Room No : '||A.ROOM_NO||' ,')||' '||
DECODE(INITCAP(A.HOUSE_NAME),NULL,NULL,INITCAP(A.HOUSE_NAME)||' ,')||' '||
DECODE(A.HOLDING_NO,NULL,NULL,'Holding No : '||A.HOLDING_NO||' ,')||' '||
DECODE(A.RD_NO_NAME,NULL,NULL,'Road No/Name : '||INITCAP(A.RD_NO_NAME)||' ,')||' '||
DECODE(A.BLOCK_NO,NULL,NULL,'Block : '||A.BLOCK_NO||' ,')||' '||
DECODE(A.SECTION,NULL,NULL,'Section : '||A.SECTION||' ,')||' '||
DECODE(INITCAP(A.LAND_MARK),NULL,NULL,INITCAP(A.LAND_MARK)||' ,')||' '||
DECODE(INITCAP(C.AREA_DESC),NULL,NULL,'Area/Moholla : '||INITCAP(C.AREA_DESC)||' ,')||' '||
DECODE(INITCAP(D.THANA_DESC),NULL,NULL,'Thana : '||INITCAP(D.THANA_DESC)||' ,')||' '||
DECODE(INITCAP(E.DIST_DESC),NULL,NULL,'Dist.: '||INITCAP(E.DIST_DESC))||' '||DECODE(A.POSTCODE_NO,NULL,NULL,'- '||A.POSTCODE_NO))) INST_ADD
INTO VINST_ADD
FROM DOC_INSTITUTE A, AREA C, THANA D, DISTRICT E
WHERE A.AREA_CODE = C.AREA_CODE(+)
AND   C.THANA_CODE = D.THANA_CODE(+)
AND   D.DIST_CODE = E.DIST_CODE(+)
AND   A.INST_CODE = VINST;
RETURN VINST_ADD;
EXCEPTION
WHEN OTHERS THEN
RETURN ' ';
END;
/


DROP FUNCTION TDMS_OPL.HMO_INT_FNC_SLNO;

CREATE OR REPLACE FUNCTION TDMS_OPL.HMO_INT_FNC_SLNO RETURN NUMBER
IS
VSLNO NUMBER:=0;
BEGIN
SELECT HMO_INT_ALLO_SEQ.NEXTVAL INTO VSLNO FROM DUAL;
RETURN (VSLNO);
EXCEPTION
WHEN OTHERS THEN
RETURN NULL;
END;
/


DROP FUNCTION TDMS_OPL.HMO_ADD_FUNC;

CREATE OR REPLACE FUNCTION TDMS_OPL.HMO_ADD_FUNC (VINST VARCHAR2) RETURN VARCHAR2
IS
VINST_ADD VARCHAR2(500);
BEGIN
SELECT RTRIM(LTRIM(DECODE(A.ROOM_NO,NULL,NULL,A.ROOM_NO||' ,')||' '||
DECODE(initcap(A.HOUSE_NAME),NULL,NULL,initcap(A.HOUSE_NAME)||' ,')||' '||
DECODE(A.HOLDING_NO,NULL,NULL,A.HOLDING_NO||' ,')||' '||
DECODE(A.RD_NO_NAME,NULL,NULL,INITCAP(A.RD_NO_NAME)||' ,')||' '||
DECODE(A.BLOCK_NO,NULL,NULL,A.BLOCK_NO||' ,')||' '||
DECODE(A.SECTION,NULL,NULL,A.SECTION||' ,')||' '||
DECODE(initcap(A.LAND_MARK),NULL,NULL,initcap(A.LAND_MARK)||' ,')||' '||
DECODE(initcap(C.AREA_DESC),NULL,NULL,initcap(C.AREA_DESC)||' ,')||' '||
DECODE(initcap(D.THANA_DESC),NULL,NULL,initcap(D.THANA_DESC)||' ,')||' '||
DECODE(initcap(E.DIST_DESC),NULL,NULL,initcap(E.DIST_DESC))||' '||DECODE(A.POSTCODE_NO,NULL,NULL,'- '||A.POSTCODE_NO))) INST_ADD
INTO VINST_ADD
FROM HMO_MASTER b, DOC_INSTITUTE A, AREA C, THANA D, DISTRICT E
WHERE B.PRAC_INST_CODE = a.INST_CODE
AND   A.AREA_CODE = C.AREA_CODE(+)
AND   C.THANA_CODE = D.THANA_CODE(+)
AND   D.DIST_CODE = E.DIST_CODE(+)
AND   a.INST_CODE = VINST;
RETURN VINST_ADD;
EXCEPTION
WHEN OTHERS THEN
RETURN ' ';
END;
/


DROP FUNCTION TDMS_OPL.FUNC_STRIPPER_TPO;

CREATE OR REPLACE FUNCTION TDMS_OPL.func_stripper_tpo (p_string VARCHAR2 ) RETURN VARCHAR2
IS
v_current_element NUMBER;   -- # of elements in string being processed
v_char_length NUMBER;   -- length of parameter
v_ret_val VARCHAR2 (2000);   -- return value
v_current_char VARCHAR2 (1);   -- the character being processed
BEGIN
  v_char_length := LENGTH (p_string);
   v_current_element := 1;
   LOOP
     EXIT WHEN v_current_element > v_char_length;
         v_current_char := SUBSTR (p_string, v_current_element, 1);
    IF    TRANSLATE (v_current_char,NULL, 'T. P. O') != 'T.P.O'
        OR v_current_char = 'T.P.O'
      THEN
         v_ret_val := v_ret_val || v_current_char;
      END IF;
         v_current_element := v_current_element + 1;
   END LOOP;   -- every character in the string
   RETURN (v_ret_val);
EXCEPTION
WHEN OTHERS THEN
RETURN ' ';
END;
/


DROP FUNCTION TDMS_OPL.FN_DOC_ADDRESS3;

CREATE OR REPLACE FUNCTION TDMS_OPL.FN_DOC_ADDRESS3 (V_DOC_CODE IN VARCHAR2) RETURN CHAR  RESULT_CACHE  IS
V_DOC VARCHAR2(4000);
BEGIN
  DECLARE
    CURSOR C1 IS

select  doc_addres from  
(  
    
SELECT  DECODE(g.CUst_name,NULL,NULL,g.CUst_name||', ')|| 
   
   DECODE(A.CUst_name,NULL,NULL,a.CUst_name||', ')||   
  
  DECODE(F.INST_DESC,NULL,NULL,F.INST_DESC||', ')||
  DECODE(A.ROOM_NO,NULL,NULL,A.ROOM_NO||', ')||
    DECODE(INITCAP(A.HOUSE_NAME),NULL,NULL,INITCAP(A.HOUSE_NAME)||', ')||
    DECODE(A.HOLDING_NO,NULL,NULL,A.HOLDING_NO||', ')||
    DECODE(A.ROAD_NO,NULL,NULL,'Rd.-'||A.ROAD_NO||',')||
    DECODE(INITCAP(A.ROAD),NULL,NULL,INITCAP(A.ROAD)||',')||
    DECODE(A.BLOCK_NO,NULL,NULL,'Blk- '||A.BLOCK_NO||',')||
    DECODE(A.SECTION,NULL,NULL,'Sec-'||A.SECTION||',')||
    
    DECODE(INITCAP(A.LAND_MARK),NULL,NULL,'['||INITCAP(A.LAND_MARK)||'] ,')||
    DECODE(A.Bazar,NULL,NULL,A.Bazar)||' , '||
    DECODE(INITCAP(C.AREA_DESC),NULL,NULL,INITCAP(C.AREA_DESC)||' ,')||
    DECODE(INITCAP(D.THANA_DESC),NULL,NULL,INITCAP(D.THANA_DESC)||',')||
    DECODE(INITCAP(E.DIST_DESC),NULL,NULL,INITCAP(E.DIST_DESC))||','||DECODE(A.POSTCODE_NO,NULL,NULL,'- '||A.POSTCODE_NO) doc_addres
     
  FROM DOC_MASTER A, AREA C, THANA D, DISTRICT E, DOC_INSTITUTE F,CUST_FULL g
  WHERE a.DEL_STAT='A'
  AND   A.INST_CODE = F.INST_CODE(+)
  AND   A.AREA_CODE  = C.AREA_CODE(+)
  AND   C.THANA_CODE = D.THANA_CODE(+)
  AND   D.DIST_CODE  = E.DIST_CODE(+)
   AND   a.CUST_CODE = g.CUST_CODE(+)
  AND   TO_NUMBER(A.DOC_CODE) =TO_NUMBER(v_doc_code));
  BEGIN
  FOR REC IN C1 LOOP
        IF V_DOC IS NULL THEN
           V_DOC:=REC.DOC_ADDRES;
        ELSE
           V_DOC:=V_DOC||','||REC.DOC_ADDRES;
        END IF;
  END LOOP;
RETURN V_DOC;
END;
END;
/


DROP FUNCTION TDMS_OPL.FN_DOC_ADDRESS2;

CREATE OR REPLACE FUNCTION TDMS_OPL.FN_DOC_ADDRESS2 (V_DOC_CODE IN VARCHAR2) RETURN CHAR  RESULT_CACHE  IS
V_DOC VARCHAR2(4000);
BEGIN
  DECLARE
    CURSOR C1 IS

select doc_addres from  
(SELECT  DECODE(A.CUst_name,NULL,NULL,a.CUst_name||' ,')||   
  
  DECODE(F.INST_DESC,NULL,NULL,F.INST_DESC||' ,')||' '||
  DECODE(A.ROOM_NO,NULL,NULL,A.ROOM_NO||' ,')||' '||
    DECODE(INITCAP(A.HOUSE_NAME),NULL,NULL,INITCAP(A.HOUSE_NAME)||' ,')||' '||
    DECODE(A.HOLDING_NO,NULL,NULL,A.HOLDING_NO||' ,')||' '||
    DECODE(A.ROAD_NO,NULL,NULL,'Rd.-'||A.ROAD_NO||' ,')||' '||
    DECODE(INITCAP(A.ROAD),NULL,NULL,INITCAP(A.ROAD)||' ,')||' '||
    DECODE(A.BLOCK_NO,NULL,NULL,'Blk- '||A.BLOCK_NO||' ,')||' '||
    DECODE(A.SECTION,NULL,NULL,'Sec-'||A.SECTION||' ,')||' '||
    DECODE(INITCAP(A.LAND_MARK),NULL,NULL,'['||INITCAP(A.LAND_MARK)||'] ,')||' '||
    DECODE(INITCAP(C.AREA_DESC),NULL,NULL,INITCAP(C.AREA_DESC)||' ,')||' '||
    DECODE(INITCAP(D.THANA_DESC),NULL,NULL,INITCAP(D.THANA_DESC)||' ,')||' '||
    DECODE(INITCAP(E.DIST_DESC),NULL,NULL,INITCAP(E.DIST_DESC))||' '||DECODE(A.POSTCODE_NO,NULL,NULL,'- '||A.POSTCODE_NO) doc_addres
     
  FROM DOC_MASTER A, AREA C, THANA D, DISTRICT E, DOC_INSTITUTE F
  WHERE DEL_STAT='A'
  AND   A.INST_CODE = F.INST_CODE(+)
  AND   A.AREA_CODE  = C.AREA_CODE(+)
  AND   C.THANA_CODE = D.THANA_CODE(+)
  AND   D.DIST_CODE  = E.DIST_CODE(+)
  AND   TO_NUMBER(A.DOC_CODE) =TO_NUMBER('0000124791'));
  BEGIN
  FOR REC IN C1 LOOP
        IF V_DOC IS NULL THEN
           V_DOC:=REC.DOC_ADDRES;
        ELSE
           V_DOC:=V_DOC||','||REC.DOC_ADDRES;
        END IF;
  END LOOP;
RETURN V_DOC;
END;
END;
/


DROP FUNCTION TDMS_OPL.FNC_STRIPPER;

CREATE OR REPLACE FUNCTION TDMS_OPL.fnc_stripper (p_string VARCHAR2 ) RETURN VARCHAR2
IS
v_current_element NUMBER;   -- # of elements in string being processed
v_char_length NUMBER;   -- length of parameter
v_ret_val VARCHAR2 (2000);   -- return value
v_current_char VARCHAR2 (1);   -- the character being processed
BEGIN
  v_char_length := LENGTH (p_string);
   v_current_element := 1;
   LOOP
     EXIT WHEN v_current_element > v_char_length;
         v_current_char := SUBSTR (p_string, v_current_element, 1);
    IF    TRANSLATE (v_current_char, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.#,-_', '~~~~~~~~~~') != '~'
        OR v_current_char = '~'
      THEN
         v_ret_val := v_ret_val || v_current_char;
      END IF;
         v_current_element := v_current_element + 1;
   END LOOP;   -- every character in the string
   RETURN (v_ret_val);
EXCEPTION
WHEN OTHERS THEN
RETURN ' ';
END;
/


DROP FUNCTION TDMS_OPL.FNC_PK;

CREATE OR REPLACE FUNCTION TDMS_OPL.FNC_PK RETURN NUMBER
IS
VSLNO NUMBER:=0;
BEGIN
SELECT DOC_PROM_ALLOC_SEQ.NEXTVAL INTO VSLNO FROM DUAL;
RETURN (VSLNO);
EXCEPTION
WHEN OTHERS THEN
RETURN NULL;
END;
/


DROP FUNCTION TDMS_OPL.FNC_CHAR;

CREATE OR REPLACE FUNCTION TDMS_OPL.FNC_CHAR(P_NAME VARCHAR2) RETURN VARCHAR2
IS
V_NAME  VARCHAR2(10);
V_P_NAME VARCHAR2(1000);
V_NAME1 VARCHAR2(100);
V_NAME2 VARCHAR2(100);
V_NAME3 VARCHAR2(100);
V_NAME4 VARCHAR2(100);
BEGIN
SELECT NAME1,NAME2 ,NAME3 INTO V_NAME1,V_NAME2,V_NAME3 FROM
( SELECT FNAME2,NAME1,NAME2 ,RTRIM(LTRIM(SUBSTR(FNAME2,LENGTH(NAME2)+1,LENGTH(FNAME2)))) NAME3 ,LENGTH(NAME2),LENGTH(FNAME2)FROM 
  (
    SELECT (RTRIM(LTRIM(FNAME2))) FNAME2,NAME1,SUBSTR((RTRIM(LTRIM(FNAME2))),1,DECODE(INSTR((RTRIM(LTRIM(FNAME2))),' '),0,LENGTH(FNAME2),INSTR((RTRIM(LTRIM(FNAME2))),' '))) NAME2
    FROM
    (SELECT FNAME1,NVL(NAME1,FNAME1) NAME1,SUBSTR(FNAME1,LENGTH(NAME1),TOTL) FNAME2
     FROM
        (select LENGTH(FNC_STRIPPER(UPPER(P_NAME))) TOTL,FNC_STRIPPER(UPPER(P_NAME)) FNAME1,INSTR(FNC_STRIPPER(UPPER(P_NAME)),' ')
            L1,SUBSTR(FNC_STRIPPER(UPPER(P_NAME)),1,INSTR(FNC_STRIPPER(UPPER(P_NAME)),' ')) NAME1
            FROM DUAL
        )        
    )
  )
);
 V_NAME := SUBSTR(V_NAME1,1,1)||NVL(SUBSTR(V_NAME2,1,1),SUBSTR(V_NAME1,2,2))||NVL(SUBSTR(V_NAME3,1,1),SUBSTR(V_NAME2,2,1));
 RETURN(V_NAME);
 EXCEPTION
 WHEN OTHERS THEN
 RETURN ' ';
 END ;
/


DROP FUNCTION TDMS_OPL.FNC_CC_PK;

CREATE OR REPLACE FUNCTION TDMS_OPL.FNC_CC_PK RETURN NUMBER
IS
VSLNO NUMBER:=0;
BEGIN
  SELECT DOC_PROM_ALLOC_CC_SEQ.NEXTVAL INTO VSLNO FROM DUAL;
  RETURN (VSLNO);
EXCEPTION
 WHEN OTHERS THEN
 RETURN NULL;
END;
/


DROP FUNCTION TDMS_OPL.DOC_QUA_FUNC;

CREATE OR REPLACE FUNCTION TDMS_OPL.DOC_QUA_FUNC (VDOC VARCHAR2) RETURN CHAR IS
  CURSOR C1 IS
  SELECT a.QUA_DESC
  FROM DOC_QUALIFICATION a, DOC_QUA b
  WHERE a.QUA_CODE = b.QUA_CODE
  AND   TO_NUMBER(b.DOC_CODE) =TO_NUMBER(VDOC)
  ORDER BY QUA_DESC;
 CTRL NUMBER :=0;
 V_DEGREE VARCHAR2(500);
 BEGIN
 FOR REC IN C1 LOOP
  CTRL :=CTRL+1;
  IF CTRL=1 THEN
   V_DEGREE :=REC.QUA_DESC;
  ELSE
   V_DEGREE := V_DEGREE||', '||REC.QUA_DESC;
  END IF;
 END LOOP;
 RETURN V_DEGREE;
END;
/


DROP FUNCTION TDMS_OPL.DOC_NAME_STRIPPER_FUNC;

CREATE OR REPLACE FUNCTION TDMS_OPL.DOC_NAME_STRIPPER_FUNC (p_string VARCHAR2 ) RETURN VARCHAR2
IS
v_current_element NUMBER;   -- # of elements in string being processed
v_char_length NUMBER;   -- length of parameter
v_ret_val VARCHAR2 (2000);   -- return value
v_current_char VARCHAR2 (1);   -- the character being processed
BEGIN
  v_char_length := LENGTH (p_string);
   v_current_element := 1;
   LOOP
     EXIT WHEN v_current_element > v_char_length;
         v_current_char := SUBSTR (p_string, v_current_element, 1);
    IF    TRANSLATE (v_current_char, ' .#,-_', '~~~~~~~~~~') != '~'
        OR v_current_char = '~'
      THEN
         v_ret_val := v_ret_val || v_current_char;
      END IF;
         v_current_element := v_current_element + 1;
   END LOOP;   -- every character in the string
   RETURN (v_ret_val);
EXCEPTION
WHEN OTHERS THEN
RETURN ' ';
END;
/


DROP FUNCTION TDMS_OPL.DOC_NAME_FILTER;

CREATE OR REPLACE FUNCTION TDMS_OPL.DOC_NAME_FILTER(V_NAME VARCHAR2) RETURN VARCHAR2 IS
 X VARCHAR2(500);
    BEGIN   
    SELECT REPLACE(V_NAME,'MD.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'MD,','') INTO X FROM DUAL;
    SELECT REPLACE(X,'MOHD.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'NUR-E-','') INTO X FROM DUAL;
    SELECT REPLACE(X,'-E-','') INTO X FROM DUAL;
    SELECT REPLACE(X,'KH.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'(MRS)','') INTO X FROM DUAL;
    SELECT REPLACE(X,'( MRS )','') INTO X FROM DUAL;
    SELECT REPLACE(X,'SK.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'MST.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'MST ','') INTO X FROM DUAL;
    SELECT REPLACE(X,'- E','') INTO X FROM DUAL;
    SELECT REPLACE(X,'- UL','') INTO X FROM DUAL;
    SELECT REPLACE(X,'-UL-','') INTO X FROM DUAL;
    SELECT REPLACE(X,'-UL','') INTO X FROM DUAL;
    SELECT REPLACE(X,'A.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'B.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'C.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'D.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'E.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'F.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'G.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'H.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'I.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'J.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'K.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'L.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'M.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'N.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'O.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'P.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'Q.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'R.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'S.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'T.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'U.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'V.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'W.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'X.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'Y.','') INTO X FROM DUAL;
    SELECT REPLACE(X,'Z.','') INTO X FROM DUAL;
    SELECT REPLACE(X,' A ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' B ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' C ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' D ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' E ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' F ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' G ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' H ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' I ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' J ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' K ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' L ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' M ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' N ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' O ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' P ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' Q ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' R ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' S ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' T ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' U ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' V ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' W ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' X ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' Y ','') INTO X FROM DUAL;
    SELECT REPLACE(X,' Z ','') INTO X FROM DUAL;
    SELECT REPLACE(X,',','') INTO X FROM DUAL;
    SELECT REPLACE(X,'  ',' ') INTO X FROM DUAL;
    SELECT LTRIM(RTRIM(X)) INTO X FROM DUAL;
    RETURN X;
    EXCEPTION
WHEN OTHERS THEN
RETURN NULL;
END;
/


DROP FUNCTION TDMS_OPL.DOC_DESIG_FUNC;

CREATE OR REPLACE FUNCTION TDMS_OPL.DOC_DESIG_FUNC(VDOC VARCHAR2) RETURN CHAR IS
 CURSOR C1 IS
  SELECT a.DOC_DG_DESC DESIG_DESC
  FROM DOC_DESIG a, DOC_DESIG_SPEC b
  WHERE a.DOC_DG_CODE = b.DOC_DG_CODE
  AND   TO_NUMBER(b.DOC_CODE) =TO_NUMBER(VDOC)
  ORDER BY PRINT_ORDER;
  CTRL NUMBER :=0;
  V_DESIG VARCHAR2(500);
 BEGIN
 FOR REC IN C1 LOOP
  CTRL :=CTRL+1;
  IF CTRL=1 THEN
   V_DESIG :=REC.DESIG_DESC;
  ELSE
   V_DESIG := V_DESIG||', '||REC.DESIG_DESC;
  END IF;
 END LOOP;
 RETURN V_DESIG;
END;
/


DROP FUNCTION TDMS_OPL.DOC_ADD_FUNC;

CREATE OR REPLACE FUNCTION TDMS_OPL.DOC_ADD_FUNC (VDOC VARCHAR2) RETURN VARCHAR2
IS
VDOC_ADD VARCHAR2(500);
BEGIN
SELECT
RTRIM(LTRIM(DECODE(A.ROOM_NO,NULL,NULL,A.ROOM_NO||' ,')||' '||
DECODE(initcap(A.HOUSE_NAME),NULL,NULL,initcap(A.HOUSE_NAME)||' ,')||' '||
DECODE(A.HOLDING_NO,NULL,NULL,A.HOLDING_NO||' ,')||' '||
DECODE(A.ROAD_NO,NULL,NULL,A.ROAD_NO||' ,')||' '||
DECODE(A.ROAD,NULL,NULL,INITCAP(A.ROAD)||' ,')||' '||
DECODE(A.BLOCK_NO,NULL,NULL,A.BLOCK_NO||' ,')||' '||
DECODE(A.SECTION,NULL,NULL,A.SECTION||' ,')||' '||
DECODE(initcap(A.LAND_MARK),NULL,NULL,'('||initcap(A.LAND_MARK)||'),')||' '||
DECODE(initcap(C.AREA_DESC),NULL,NULL,initcap(C.AREA_DESC)||' ,')||' '||
DECODE(initcap(D.THANA_DESC),NULL,NULL,initcap(D.THANA_DESC)||' ,')||' '||
DECODE(initcap(E.DIST_DESC),NULL,NULL,initcap(E.DIST_DESC))||' '||DECODE(A.POSTCODE_NO,NULL,NULL,'- '||A.POSTCODE_NO))) INST_ADD
INTO VDOC_ADD
FROM DOC_MASTER A, AREA C, THANA D, DISTRICT E
WHERE A.AREA_CODE = C.AREA_CODE(+)
AND   C.THANA_CODE = D.THANA_CODE(+)
AND   D.DIST_CODE = E.DIST_CODE(+)
AND   a.DOC_CODE = VDOC;
RETURN VDOC_ADD;
EXCEPTION
WHEN OTHERS THEN
RETURN ' ';
END;
/


DROP FUNCTION TDMS_OPL.DOB;

CREATE OR REPLACE FUNCTION TDMS_OPL.DOB (FDATE DATE, TDATE DATE)
RETURN CHAR IS
 VNM  NUMBER;
 VYR  NUMBER;
 VMO  NUMBER;
 VDY  NUMBER;
 VTXT VARCHAR2(100);
BEGIN
  VNM := MONTHS_BETWEEN(FDATE,TDATE);
  VYR := TRUNC(VNM/12);
  VMO := ROUND(((VNM/12)-TRUNC(VNM/12))*12);
  VDY := ROUND((VNM-trunc(VNM))*30);
  VTXT :=VYR||' Years,'||' '||VMO||' Months,'||' '||VDY||' Days';
 RETURN VTXT;
END;
/


DROP FUNCTION TDMS_OPL.CUST_ADD_FUNC;

CREATE OR REPLACE FUNCTION TDMS_OPL.CUST_ADD_FUNC (VCUST VARCHAR2) RETURN VARCHAR2
IS
VCUST_ADD VARCHAR2(500);
BEGIN
SELECT
RTRIM(LTRIM(DECODE(A.ROOM_NO,NULL,NULL,A.ROOM_NO||' ,')||' '||
DECODE(initcap(A.HOUSE_NAME),NULL,NULL,initcap(A.HOUSE_NAME)||' ,')||' '||
DECODE(A.HOLDING_NO,NULL,NULL,A.HOLDING_NO||' ,')||' '||
DECODE(A.ROAD_NO,NULL,NULL,A.ROAD_NO||' ,')||' '||
DECODE(A.RD_NAME,NULL,NULL,INITCAP(A.RD_NAME)||' ,')||' '||
DECODE(A.BLOCK_NO,NULL,NULL,A.BLOCK_NO||' ,')||' '||
DECODE(A.SECTOR,NULL,NULL,A.SECTOR||' ,')||' '||
DECODE(initcap(A.LAND_MARK),NULL,NULL,'('||initcap(A.LAND_MARK)||'),')||' '||
DECODE(initcap(C.AREA_DESC),NULL,NULL,initcap(C.AREA_DESC)||' ,')||' '||
DECODE(initcap(D.THANA_DESC),NULL,NULL,initcap(D.THANA_DESC)||' ,')||' '||
DECODE(initcap(E.DIST_DESC),NULL,NULL,initcap(E.DIST_DESC))||' '||DECODE(A.POST_CODE,NULL,NULL,'- '||A.POST_CODE))) INST_ADD
INTO VCUST_ADD
FROM  CUST_FULL A, AREA C, THANA D, DISTRICT E
WHERE A.AREA_CODE = C.AREA_CODE(+)
AND   C.THANA_CODE = D.THANA_CODE(+)
AND   D.DIST_CODE = E.DIST_CODE(+)
AND   a.CUST_CODE = VCUST;
RETURN VCUST_ADD;
EXCEPTION
WHEN OTHERS THEN
RETURN ' ';
END;
/


DROP FUNCTION TDMS_OPL.COMA_STRIPPER;

CREATE OR REPLACE FUNCTION TDMS_OPL.coma_stripper (p_string VARCHAR2 ) RETURN VARCHAR2
IS
v_current_element NUMBER;   -- # of elements in string being processed
v_char_length NUMBER;   -- length of parameter
v_ret_val VARCHAR2 (2000);   -- return value
v_current_char VARCHAR2 (1);   -- the character being processed
BEGIN
  v_char_length := LENGTH (p_string);
   v_current_element := 1;
   LOOP
     EXIT WHEN v_current_element > v_char_length;
         v_current_char := SUBSTR (p_string, v_current_element, 1);
    IF    TRANSLATE (v_current_char, ',', '~~~~~~~~~~') != '~'
        OR v_current_char = '~'
      THEN
         v_ret_val := v_ret_val || v_current_char;
      END IF;
         v_current_element := v_current_element + 1;
   END LOOP;   -- every character in the string
   RETURN (v_ret_val);
EXCEPTION
WHEN OTHERS THEN
RETURN ' ';
END;
/


DROP FUNCTION TDMS_OPL.BMDC_DOC_NAME_FUN;

CREATE OR REPLACE FUNCTION TDMS_OPL.BMDC_DOC_NAME_FUN(V_D VARCHAR2) RETURN VARCHAR2 IS
 X VARCHAR2(300);
BEGIN 
SELECT LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(
LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(
LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(
LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(
LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(
LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(LTRIM(REPLACE(
LTRIM(REPLACE(LTRIM(REPLACE(REPLACE(LTRIM(REPLACE(LTRIM(
REPLACE(DOC_NAME,'A. ',' ')),'MD. ',' ')),'M.',' '),'A.B.',' '))
,',','')),'MD.',' ')),'B.',' ')),'R. ',' ')),'A.Q.',' ')),'A.S.',' '))
,' K.F.M',' ')),' SK.',' ')),'.',' ')),' AL ',' ')),' K ',' ')),'-E-',' '))
,' - E',' ')),'-UL-',' ')),' K ',' ')),' N ',' ')),' S ',' ')),' MD.',' '))
,' A ',' ')),' T ',' ')),' AD ',' ')),' G ',' ')),' G ',' ')),' F ',' '))
,' M ',' ')),' H ',' ')),' MD ',' ')),' L ',' ')),' B ',' ')),' Z ',' '))
,'-E-',' ')),' G',' ')),' Q M',' ')),' A-S',' ')),' AZ ',' ')),' D ','')),' I ',' ')),'- -',' '))
INTO X
FROM BOOK_OF_BMDC
WHERE DOC_NAME=V_D;
RETURN X;
EXCEPTION
WHEN OTHERS THEN
RETURN NULL;
END;
/


DROP PUBLIC SYNONYM DOC_ADD_FUNC;

CREATE PUBLIC SYNONYM DOC_ADD_FUNC FOR TDMS_OPL.DOC_ADD_FUNC;


GRANT EXECUTE ON TDMS_OPL.DOC_ADD_FUNC TO PUBLIC;


DROP FUNCTION PMIS_OPL.TRIM_MD;

CREATE OR REPLACE FUNCTION PMIS_OPL.TRIM_MD(V_FULL_NAME VARCHAR2) RETURN VARCHAR2 IS
    V_NAME VARCHAR2(100);
BEGIN
    V_NAME  := LTRIM(RTRIM(REPLACE(UPPER(V_FULL_NAME),'MD.',NULL)));
    RETURN  INITCAP(V_NAME);
EXCEPTION
    WHEN OTHERS THEN
    RETURN 0;
END;
/


DROP FUNCTION PMIS_OPL.TLAST_DAY_YEAR;

CREATE OR REPLACE FUNCTION PMIS_OPL.TLAST_DAY_YEAR(CUR_DATE DATE)
RETURN DATE IS
X DATE;
BEGIN
select last_day(add_months(trunc(CUR_DATE,'YYYY'), 11))
INTO X
from dual;
RETURN X;
EXCEPTION
WHEN OTHERS THEN
RETURN NULL;
END;
/


DROP FUNCTION PMIS_OPL.SPEL_OUT;

CREATE OR REPLACE FUNCTION PMIS_OPL.spel_out(a_number number) return char is
type numtab is table of
varchar2(30)
index by binary_integer;
    number_chart numtab;
     crore number;
    lakh number;
    thou number;
    hund number;
     doubl number;
    sing number;
    deci number;
    text varchar2(500);
begin
    if a_number >= 0 then
        --The Table
        number_chart(1):='One';
        number_chart(2):='Two';
        number_chart(3):='Three';
        number_chart(4):='Four';
        number_chart(5):='Five';
        number_chart(6):='Six';
        number_chart(7):='Seven';
        number_chart(8):='Eight';
        number_chart(9):='Nine';
        number_chart(10):='Ten';
        number_chart(11):='Eleven';
        number_chart(12):='Twelve';
        number_chart(13):='Thirteen';
        number_chart(14):='Fourteen';
        number_chart(15):='Fifteen';
        number_chart(16):='Sixteen';
        number_chart(17):='Seventeen';
        number_chart(18):='Eighteen';
        number_chart(19):='Nineteen';
        number_chart(20):='Twenty';
        number_chart(30):='Thirty';
        number_chart(40):='Forty';
        number_chart(50):='Fifty';
        number_chart(60):='Sixty';
        number_chart(70):='Seventy';
        number_chart(80):='Eighty';
        number_chart(90):='Ninety';
        crore:=floor(a_number/10000000);
        lakh:=floor((a_number-trunc(a_number,-7))/100000);
        thou:=floor((a_number-trunc(a_number,-5))/1000);
        hund:=floor((a_number-trunc(a_number,-3))/100);
        doubl:=trunc(a_number-trunc(a_number,-2),0);
        sing:=trunc(a_number-trunc(a_number,-1),0);
        deci:=(a_number-trunc(a_number,0))*100;
        
        if crore<>0 then
         text:=spel_out(crore)||' '||'Crore ';
        end if;
        if lakh <>0 then
         if (lakh<=20)  or  (lakh mod 10=0) then
          text:=text||number_chart(lakh)||' Lac ';
         else
          text:=text||number_chart(trunc(lakh,-1))||' '||number_chart(trunc(lakh,0)-trunc(lakh,-1))||' Lac ';
             end if;
        end if;
        if thou <>0 then
         if (thou<=20)  or  (thou mod 10=0) then
          text:=text||number_chart(thou)||' Thousand ';
         else
          text:=text||number_chart(trunc(thou,-1))||' '||number_chart(trunc(thou,0)-trunc(thou,-1))||' Thousand ';
             end if;
        end if;
        if hund <>0 then
         if (hund<=20)  or  (hund mod 10=0) then
          text:=text||number_chart(hund)||' Hundred ';
         else
          text:=text||number_chart(trunc(hund,-1))||' '||number_chart(trunc(hund,0)-trunc(hund,-1))||' Hundred ';
             end if;
        end if;
        if doubl <>0 then
         if (doubl<=20)  or  (doubl mod 10=0) then
          text:=text||number_chart(doubl)||' ';
         else
          text:=text||number_chart(trunc(doubl,-1))||' '||number_chart(trunc(doubl,0)-trunc(doubl,-1))||' ';
             end if;
        end if;
        if deci <>0 then
         if (deci<=20)  or  (deci mod 10=0) then
          text:=text||' and '||number_chart(deci)||' Paisa ';
         else
          text:=text||' and '||number_chart(trunc(deci,-1))||' '||number_chart(trunc(deci,0)-trunc(deci,-1))||' Paisa ';
             end if;
        end if;
        return(text);
    else
        return('Amount less than zero!');
    end if;
end spel_out;
/


DROP FUNCTION PMIS_OPL.MONTH_LEAVE_CNT;

CREATE OR REPLACE FUNCTION PMIS_OPL.MONTH_LEAVE_CNT(F_DT DATE, T_DT DATE) RETURN NUMBER IS
    CNT NUMBER;
BEGIN
  SELECT  (T_DT-F_DT)+1
  INTO        CNT
  FROM (SELECT F_DT,
       DECODE(TRUNC(T_DT,'MON'),TRUNC(F_DT,'MON'),T_DT,LAST_DAY(TRUNC(F_DT,'MON'))) T_DT
       FROM DUAL) A;
    RETURN    CNT;
EXCEPTION
    WHEN OTHERS THEN
    RETURN 0;
END;
/


DROP FUNCTION PMIS_OPL.MAC_NAME_FUNC;

CREATE OR REPLACE FUNCTION PMIS_OPL.MAC_NAME_FUNC return CHAR is
VMAC varchar2(100);
begin
  SELECT SYS_CONTEXT('USERENV','HOST')
  INTO VMAC
  FROM DUAL;
RETURN VMAC;
END;
/


DROP FUNCTION PMIS_OPL.MACHINE_NAME;

CREATE OR REPLACE FUNCTION PMIS_OPL.MACHINE_NAME RETURN CHAR IS
    V_MAC_NAME VARCHAR2(50);
BEGIN
    SELECT  USERENV('TERMINAL')
    INTO    V_MAC_NAME
    FROM    DUAL;
    RETURN  V_MAC_NAME;
EXCEPTION
    WHEN OTHERS THEN
    NULL;
END;
/


DROP FUNCTION PMIS_OPL.LR_PIC_LEN;

CREATE OR REPLACE FUNCTION PMIS_OPL.LR_PIC_LEN(P_EMP_CODE IN VARCHAR2) RETURN NUMBER AS 
    L_RAW LONG RAW; 
BEGIN 
    SELECT  EMP_PIC 
    INTO    L_RAW 
    FROM    PMIS_EMP_OTHERS 
    WHERE   EMP_CODE = P_EMP_CODE; 

    IF (L_RAW IS NULL) THEN
        RETURN NULL;
    ELSE
        RETURN UTL_RAW.LENGTH(L_RAW);
    END IF; 
EXCEPTION 
    WHEN OTHERS THEN 
    RETURN NULL; 
END;
/


DROP FUNCTION PMIS_OPL.LR_LENGTH;

CREATE OR REPLACE FUNCTION PMIS_OPL.LR_LENGTH(P_EMP_CODE IN VARCHAR2) RETURN NUMBER AS 
    L_RAW LONG RAW;
BEGIN
    SELECT  EMP_SIGN_PIC 
    INTO    L_RAW
    FROM    PMIS_EMP_SIGN_PIC
    WHERE   EMP_CODE    = P_EMP_CODE; 
    
    IF (L_RAW IS NULL) THEN
        RETURN NULL;
    ELSE
        RETURN UTL_RAW.LENGTH(L_RAW);
    END IF;
EXCEPTION
    WHEN OTHERS THEN 
    RETURN NULL;
END;
/


DROP FUNCTION PMIS_OPL.LR2HEX;

CREATE OR REPLACE FUNCTION PMIS_OPL.LR2HEX(P_EMP_CODE IN VARCHAR2) RETURN VARCHAR2 AS 
    L_RAW LONG RAW; 
    L_STR VARCHAR2(2000); 
    L_LEN NUMBER; 
BEGIN
    SELECT  EMP_SIGN_PIC 
    INTO    L_RAW
    FROM    PMIS_EMP_SIGN_PIC
    WHERE   EMP_CODE    = P_EMP_CODE; 

    IF (L_RAW IS NOT NULL) THEN
        L_LEN := LEAST(UTL_RAW.LENGTH(L_RAW), 1000);
        L_RAW := UTL_RAW.SUBSTR(L_RAW,1,L_LEN); 
    END IF; 
    L_STR := L_RAW; 

    RETURN L_STR; 
EXCEPTION 
    WHEN OTHERS THEN 
    RETURN NULL; 
END;
/


DROP FUNCTION PMIS_OPL.LOAN_AGREE;

CREATE OR REPLACE FUNCTION PMIS_OPL.LOAN_AGREE(a_number number) return char is
type numtab is table of
varchar2(30)
index by binary_integer;
    number_chart numtab;
     crore number;
    lakh number;
    thou number;
    hund number;
     doubl number;
    sing number;
    deci number;
    text varchar2(500);
begin
 --The Table
    number_chart(1):='One';
    number_chart(2):='Two';
    number_chart(3):='Three';
    number_chart(4):='Four';
    number_chart(5):='Five';
    number_chart(6):='Six';
    number_chart(7):='Seven';
    number_chart(8):='Eight';
    number_chart(9):='Nine';
    number_chart(10):='Ten';
    number_chart(11):='Eleven';
    number_chart(12):='Twelve';
    number_chart(13):='Thirteen';
    number_chart(14):='Fourteen';
    number_chart(15):='Fifteen';
    number_chart(16):='Sixteen';
    number_chart(17):='Seventeen';
    number_chart(18):='Eighteen';
    number_chart(19):='Nineteen';
    number_chart(20):='Twenty';
    number_chart(30):='Thirty';
    number_chart(40):='Forty';
    number_chart(50):='Fifty';
    number_chart(60):='Sixty';
    number_chart(70):='Seventy';
    number_chart(80):='Eighty';
    number_chart(90):='Ninety';
    crore:=floor(a_number/10000000);
    lakh:=floor((a_number-trunc(a_number,-7))/100000);
    thou:=floor((a_number-trunc(a_number,-5))/1000);
    hund:=floor((a_number-trunc(a_number,-3))/100);
    doubl:=trunc(a_number-trunc(a_number,-2),0);
    sing:=trunc(a_number-trunc(a_number,-1),0);
    deci:=(a_number-trunc(a_number,0))*100;
if crore<>0 then
 text:=spel_out(crore)||' '||'Crore ';
end if;
if lakh <>0 then
 if (lakh<=20)  or  (lakh mod 10=0) then
  text:=text||number_chart(lakh)||' Lac ';
 else
  text:=text||number_chart(trunc(lakh,-1))||'-'||number_chart(trunc(lakh,0)-trunc(lakh,-1))||' Lac ';
     end if;
end if;
if thou <>0 then
 if (thou<=20)  or  (thou mod 10=0) then
  text:=text||number_chart(thou)||' Thousand ';
 else
  text:=text||number_chart(trunc(thou,-1))||'-'||number_chart(trunc(thou,0)-trunc(thou,-1))||' Thousand ';
     end if;
end if;
if hund <>0 then
 if (hund<=20)  or  (hund mod 10=0) then
  text:=text||number_chart(hund)||' Hundred ';
 else
  text:=text||number_chart(trunc(hund,-1))||'-'||number_chart(trunc(hund,0)-trunc(hund,-1))||' Hundred ';
     end if;
end if;
if doubl <>0 then
 if (doubl<=20)  or  (doubl mod 10=0) then
  text:=text||number_chart(doubl)||' ';
 else
  text:=text||number_chart(trunc(doubl,-1))||'-'||number_chart(trunc(doubl,0)-trunc(doubl,-1))||' ';
     end if;
end if;
if deci <>0 then
 if (deci<=20)  or  (deci mod 10=0) then
  text:=text||' and '||number_chart(deci)||' Paisa ';
 else
  text:=text||' and '||number_chart(trunc(deci,-1))||'-'||number_chart(trunc(deci,0)-trunc(deci,-1))||' Paisa ';
     end if;
end if;
 return(text);
end LOAN_AGREE;
/


DROP FUNCTION PMIS_OPL.LAST_DAY_YEAR;

CREATE OR REPLACE FUNCTION PMIS_OPL.LAST_DAY_YEAR(CUR_DATE DATE)
RETURN DATE IS
X DATE;
BEGIN
select last_day(add_months(trunc(CUR_DATE,'YYYY'), 11))
INTO X
from dual;
RETURN X;
EXCEPTION
WHEN OTHERS THEN
RETURN NULL;
END;
/


DROP FUNCTION PMIS_OPL.LAST_DAY;

CREATE OR REPLACE FUNCTION PMIS_OPL.LAST_DAY(CUR_DATE DATE)
RETURN DATE IS
X DATE;
BEGIN
select last_day(add_months(trunc(CUR_DATE,'YYYY'), 11))
INTO X
from dual;
RETURN X;
EXCEPTION
WHEN OTHERS THEN
RETURN NULL;
END;
/


DROP FUNCTION PMIS_OPL.GET_PRL_SMS_DATA;

CREATE OR REPLACE FUNCTION PMIS_OPL.GET_PRL_SMS_DATA(VECODE VARCHAR2,VMNYR DATE, VPROCESS_EVENT NUMBER ) return Char is
    V_SAL_DESC VARCHAR2(500);
BEGIN
    V_SAL_DESC :=NULL;
    SELECT  TO_CHAR(MNYR,'MMRR')||
            '['||EMP_CODE||']'||'Bank:'||BRANCH_NAME||
            (CASE WHEN ACCOUNT_NO IS NULL THEN NULL ELSE ', AC:'||ACCOUNT_NO END)||CHR(10)||
            'BSC:'||BASIC||','||'OAW:'||OTHER_ALLOW||','||'GRS:'||GROSS_AMOUNT||','||CHR(10)||
            (CASE WHEN ADD_DESC IS NULL THEN NULL ELSE ADD_DESC||CHR(10) END)||
            (CASE WHEN DED_DESC IS NULL THEN NULL ELSE DED_DESC||CHR(10) END)||
            'Net:'||NET_AMOUNT||BAL_DESC SAL_DESC
    INTO    V_SAL_DESC
    FROM    (
            SELECT  M.MNYR, 
                    M.EMP_CODE, 
                    M.EMP_OFFICE_NAME, 
                    M.BRANCH_NAME, 
                    M.ACCOUNT_NO, 
                    M.MOBILE_PHONE, 
                    M.BASIC, 
                    M.OTHER_ALLOW, 
                    M.GROSS_AMOUNT, 
                    N.ADD_DESC, 
                    M.TOT_ADD, 
                    N.DED_DESC, 
                    M.TOT_DED, 
                    M.NET_AMOUNT, 
                    N.BAL_DESC
            FROM    (
                    SELECT  A.MNYR, 
                            A.EMP_CODE, 
                            B.EMP_OFFICE_NAME, 
                            DECODE(D.BANK_CODE,'0000','CASH','OPLF','CASH',D.BANK_CODE) BRANCH_NAME, 
                            SUBSTR(A.ACCOUNT_NO,-D.ACC_NO_LAST_DIGIT) ACCOUNT_NO, 
                            G.MOBILE_PHONE_1 MOBILE_PHONE, 
                            A.BASIC, 
                            A.OTHER_ALLOW, 
                            A.GROSS_AMOUNT, 
                            E.TOT_ADD, 
                            F.TOT_DED, 
                            FLOOR(NVL(A.NET_AMOUNT,0)) NET_AMOUNT
                    FROM    PMIS_PAYROLL_MASTER_REG A, 
                            PMIS_EMP B, 
                            PMIS_BANK_BRANCH C, 
                            PMIS_BANK D, 
                            (
                            SELECT  A.EMP_CODE, 
                                    SUM(NVL(B.ADD_AMT,0)) TOT_ADD
                            FROM    PMIS_PAYROLL_MASTER_REG A, 
                                    PMIS_PAYROLL_DETAIL_REG B, 
                                    PMIS_PAY_SALARY_HEAD C
                            WHERE   A.PAYROLL_CODE  = B.PAYROLL_CODE
                            AND     B.SAL_HEAD_CODE = C.SAL_HEAD_CODE
                            AND     A.MNYR          = VMNYR
                            AND     A.PROCESS_EVENT = VPROCESS_EVENT
                            AND     A.EMP_CODE      IN (VECODE)
                            AND     C.SAL_HEAD_TYPE = 'A'
                            AND     C.SAL_HEAD_CAT  = 'E'
                            GROUP BY A.EMP_CODE
                            ) E, 
                            (
                            SELECT  EMP_CODE, 
                                    SUM(NVL(TOT_DED,0)) TOT_DED
                            FROM    (
                                    SELECT  A.EMP_CODE, 
                                            FLOOR(SUM(NVL(B.DEDUCT_AMT,0))) TOT_DED
                                    FROM    PMIS_PAYROLL_MASTER_REG A, 
                                            PMIS_PAYROLL_DETAIL_REG B, 
                                            PMIS_PAY_SALARY_HEAD C
                                    WHERE   A.PAYROLL_CODE  = B.PAYROLL_CODE
                                    AND     B.SAL_HEAD_CODE = C.SAL_HEAD_CODE
                                    AND     A.MNYR          = VMNYR
                                    AND     A.PROCESS_EVENT = VPROCESS_EVENT
                                    AND     A.EMP_CODE      IN (VECODE)
                                    AND     C.SAL_HEAD_TYPE = 'D'
                                    GROUP BY A.EMP_CODE
                                    UNION
                                    SELECT  B.EMP_CODE, 
                                            FLOOR(SUM(NVL(A.EMP_DED_AMT,0))) SAL_HEAD_AMT
                                    FROM    PMIS_LOAN_DEDUCTION A, 
                                            PMIS_LOAN_MASTER B, 
                                            (SELECT * FROM PMIS_LOAN_TYPE       WHERE USE_FLAG = 'P' ) C, 
                                            (SELECT * FROM PMIS_PAY_SALARY_HEAD WHERE SAL_HEAD_EMP_GRP = '00002') D
                                    WHERE   A.LOAN_SLNO         = B.LOAN_SLNO
                                    AND     B.LOAN_CODE         = C.LOAN_CODE
                                    AND     C.SAL_HEAD_CODE     = D.SAL_HEAD_CODE
                                    AND     TRUNC(A.MNYR,'MON') = VMNYR
                                    AND     A.INSTALL_SOURCE    = '00001'
                                    AND     NVL(A.EMP_BALANCE,0)>=0
                                    AND     NVL(B.EMP_DED_AMT,0)>0
                                    AND     B.EMP_CODE          IN(VECODE)
                                    GROUP BY B.EMP_CODE
                                    )
                            GROUP BY EMP_CODE
                            ) F, 
                            PMIS_EMP_OTHERS G
                    WHERE   A.EMP_CODE      = B.EMP_CODE
                    AND     A.BRANCH_CODE   = C.BRANCH_CODE
                    AND     C.BANK_CODE     = D.BANK_CODE
                    AND     A.EMP_CODE      = E.EMP_CODE(+)
                    AND     A.EMP_CODE      = F.EMP_CODE(+)
                    AND     A.EMP_CODE      = G.EMP_CODE
                    AND     A.MNYR          = VMNYR
                    AND     A.PROCESS_EVENT = VPROCESS_EVENT
                    AND     A.EMP_CODE      IN (VECODE)
                    AND     A.SMS_STAT      = 'N'
                    ) M,
                    (
                    SELECT  A.EMP_CODE, 
                            B.ADD_DESC, 
                            C.DED_DESC, 
                            D.BAL_DESC
                    FROM    (
                            SELECT  A.EMP_CODE
                            FROM    PMIS_PAYROLL_MASTER_REG A
                            WHERE   A.MNYR          = VMNYR
                            AND     A.PROCESS_EVENT = VPROCESS_EVENT
                            AND     A.EMP_CODE      IN (VECODE)
                            AND     A.SMS_STAT      = 'N'
                            ) A,
                            (
                            SELECT  EMP_CODE, 
                                    SAL_HEAD_TYPE, 
                                    --SAL_HEAD_TYPE_DESC||WM_CONCAT(ADD_DESC) ADD_DESC
                                    SAL_HEAD_TYPE_DESC||
                                    
                                    
                                    LISTAGG(ADD_DESC,', ') WITHIN GROUP (ORDER BY ADD_DESC DESC) ADD_DESC
                            FROM    (
                                    SELECT  A.EMP_CODE, 
                                            A.SAL_HEAD_TYPE, 
                                            DECODE(A.SAL_HEAD_TYPE,'A','Add:') SAL_HEAD_TYPE_DESC, 
                                            A.SHORT_DESC||':'||A.ADD_AMT ADD_DESC
                                    FROM    (
                                            SELECT  A.EMP_CODE, 
                                                    C.SAL_HEAD_TYPE, 
                                                    B.SAL_HEAD_CODE, 
                                                    C.SHORT_DESC, 
                                                    B.ADD_AMT
                                            FROM    PMIS_PAYROLL_MASTER_REG A, 
                                                    PMIS_PAYROLL_DETAIL_REG B, 
                                                    PMIS_PAY_SALARY_HEAD C
                                            WHERE   A.PAYROLL_CODE  = B.PAYROLL_CODE
                                            AND     B.SAL_HEAD_CODE = C.SAL_HEAD_CODE
                                            AND     A.MNYR          = VMNYR
                                            AND     A.PROCESS_EVENT = VPROCESS_EVENT
                                            AND     A.EMP_CODE      IN (VECODE)
                                            AND     C.SAL_HEAD_TYPE = 'A'
                                            AND     C.SAL_HEAD_CAT  = 'E'
                                            AND     A.SMS_STAT      = 'N'
                                            ) A
                                    )
                            GROUP BY EMP_CODE, SAL_HEAD_TYPE, SAL_HEAD_TYPE_DESC
                            ) B, 
                            (
                            SELECT  EMP_CODE, 
                                    SAL_HEAD_TYPE, 
                                    --SAL_HEAD_TYPE_DESC||WM_CONCAT(DED_DESC) DED_DESC
                                    SAL_HEAD_TYPE_DESC||LISTAGG(DED_DESC,', ') WITHIN GROUP (ORDER BY DED_DESC DESC) DED_DESC
                            FROM    (
                                    SELECT  A.EMP_CODE, 
                                            A.SAL_HEAD_TYPE, 
                                            DECODE(A.SAL_HEAD_TYPE,'D','Ded:') SAL_HEAD_TYPE_DESC, 
                                            A.SHORT_DESC||':'||A.DEDUCT_AMT DED_DESC
                                    FROM    (
                                            SELECT  A.EMP_CODE, 
                                                    C.SAL_HEAD_TYPE, 
                                                    B.SAL_HEAD_CODE, 
                                                    C.SHORT_DESC, 
                                                    B.DEDUCT_AMT
                                            FROM    PMIS_PAYROLL_MASTER_REG A, 
                                                    PMIS_PAYROLL_DETAIL_REG B, 
                                                    PMIS_PAY_SALARY_HEAD C
                                            WHERE   A.PAYROLL_CODE  = B.PAYROLL_CODE
                                            AND     B.SAL_HEAD_CODE = C.SAL_HEAD_CODE
                                            AND     A.MNYR          = VMNYR
                                            AND     A.PROCESS_EVENT = VPROCESS_EVENT
                                            AND     A.EMP_CODE      IN (VECODE)
                                            AND     C.SAL_HEAD_TYPE = 'D'
                                            AND     A.SMS_STAT      = 'N'
                                            UNION
                                            SELECT  B.EMP_CODE, 
                                                    D.SAL_HEAD_TYPE, 
                                                    D.SAL_HEAD_CODE, 
                                                    C.SHORT_DESC,  
                                                    FLOOR(NVL(A.EMP_DED_AMT,0)) DEDUCT_AMT
                                            FROM    PMIS_LOAN_DEDUCTION A, 
                                                    PMIS_LOAN_MASTER B, 
                                                    (SELECT * FROM PMIS_LOAN_TYPE       WHERE USE_FLAG = 'P' ) C, 
                                                    (SELECT * FROM PMIS_PAY_SALARY_HEAD WHERE SAL_HEAD_EMP_GRP = '00002') D
                                            WHERE   A.LOAN_SLNO         = B.LOAN_SLNO
                                            AND     B.LOAN_CODE         = C.LOAN_CODE
                                            AND     C.SAL_HEAD_CODE     = D.SAL_HEAD_CODE
                                            AND     TRUNC(A.MNYR,'MON') = VMNYR
                                            AND     A.PROCESS_EVENT     = VPROCESS_EVENT
                                            AND     A.INSTALL_SOURCE    = '00001'
                                            AND     NVL(A.EMP_BALANCE,0)>=0
                                            AND     NVL(B.EMP_DED_AMT,0)>0
                                            AND     B.EMP_CODE          IN(VECODE)
                                            ) A
                                    )
                            GROUP BY EMP_CODE, SAL_HEAD_TYPE, SAL_HEAD_TYPE_DESC
                            ) C, 
                            (
                            SELECT  EMP_CODE, 
                                    SAL_HEAD_TYPE, 
                                    --SAL_HEAD_TYPE_DESC||WM_CONCAT(BAL_DESC) BAL_DESC
                                    SAL_HEAD_TYPE_DESC||LISTAGG(BAL_DESC,', ') WITHIN GROUP (ORDER BY BAL_DESC DESC) BAL_DESC
                            FROM    (
                                    SELECT  A.EMP_CODE, 
                                            A.SAL_HEAD_TYPE, 
                                            DECODE(A.SAL_HEAD_TYPE,'B','BL:') SAL_HEAD_TYPE_DESC, 
                                            A.SHORT_DESC||':'||A.DEDUCT_AMT BAL_DESC
                                    FROM    (
                                            SELECT  B.EMP_CODE, 
                                                    'B' SAL_HEAD_TYPE, 
                                                    D.SAL_HEAD_CODE, 
                                                    C.SHORT_DESC SHORT_DESC,  
                                                    B.EMP_BALANCE DEDUCT_AMT
                                            FROM    PMIS_LOAN_DEDUCTION A, 
                                                    PMIS_LOAN_MASTER B, 
                                                    (SELECT * FROM PMIS_LOAN_TYPE       WHERE USE_FLAG = 'P' ) C, 
                                                    (SELECT * FROM PMIS_PAY_SALARY_HEAD WHERE SAL_HEAD_EMP_GRP = '00002') D
                                            WHERE   A.LOAN_SLNO         = B.LOAN_SLNO
                                            AND     B.LOAN_CODE         = C.LOAN_CODE
                                            AND     C.SAL_HEAD_CODE     = D.SAL_HEAD_CODE
                                            AND     TRUNC(A.MNYR,'MON') = VMNYR
                                            AND     A.PROCESS_EVENT     = VPROCESS_EVENT
                                            AND     A.INSTALL_SOURCE    = '00001'
                                            AND     NVL(A.EMP_BALANCE,0)>=0
                                            AND     NVL(B.EMP_DED_AMT,0)>0
                                            AND     B.EMP_CODE          IN(VECODE)
                                            ) A
                                    )
                            GROUP BY EMP_CODE, SAL_HEAD_TYPE, SAL_HEAD_TYPE_DESC
                            ) D
                    WHERE   A.EMP_CODE  = B.EMP_CODE(+)
                    AND     A.EMP_CODE  = C.EMP_CODE(+)
                    AND     A.EMP_CODE  = D.EMP_CODE(+)
                    ) N
            WHERE   M.EMP_CODE  = N.EMP_CODE(+)
            );
    RETURN TRIM(V_SAL_DESC);
EXCEPTION
    WHEN OTHERS THEN
    RETURN NULL;
END;
/


DROP FUNCTION PMIS_OPL.GET_LOC_NAMES;

CREATE OR REPLACE FUNCTION PMIS_OPL.GET_LOC_NAMES(VUSERID VARCHAR2) RETURN VARCHAR2 IS
    V_GRP_ID_DESC VARCHAR2(200);
BEGIN
    SELECT  LISTAGG(B.ITEM_DESC, '; ') WITHIN GROUP (ORDER BY A.GRP_ID) GRP_ID_DESC
    INTO    V_GRP_ID_DESC
    FROM    PMIS_LOOKUP_GRP_ID A, 
            (SELECT * FROM PMIS_GENLOOKUP_DTL WHERE LOOKUP_TYPE = '00049') B
    WHERE   A.GRP_ID    = B.ITEM_CODE
    AND     A.USER_ID   = VUSERID
    ORDER BY A.GRP_ID;
    RETURN V_GRP_ID_DESC;
EXCEPTION
    WHEN OTHERS THEN
    RETURN NULL;
END;
/


DROP FUNCTION PMIS_OPL.GET_ADDRESS_PRES_UP;

CREATE OR REPLACE FUNCTION PMIS_OPL.GET_ADDRESS_PRES_UP(VECODE VARCHAR2,V_ADD_TYPE VARCHAR2) return Char is
    V_PRS_ADD VARCHAR2(500);
BEGIN
    V_PRS_ADD :=NULL;
    SELECT  
       (CASE WHEN D.VILL_BAZ_MOHO_NAME IS NULL THEN NULL ELSE 'Vill : '||D.VILL_BAZ_MOHO_NAME END)||
        (CASE WHEN K.THANA_DESC IS NULL THEN NULL ELSE ', P.S:'||K.THANA_DESC END)||
        (CASE WHEN F.DIST_DESC IS NULL THEN NULL ELSE ', DIST: '||F.DIST_DESC END)
        ADDRESS INTO V_PRS_ADD
FROM    PMIS_EMP_ADDRESS D, 
        AREA E, 
        DISTRICT F, 
        THANA K, 
        PO_SUB L
WHERE   D.ADDRESS_TYPE       = V_ADD_TYPE
AND     D.AREA_CODE          = E.AREA_CODE
AND     E.DIST_CODE          = F.DIST_CODE     
AND     E.THANA_CODE         = K.THANA_CODE
AND     D.PO_SUB_CODE        = L.PO_SUB_SLNO
AND     D.EMP_CODE           = VECODE;
    RETURN TRIM(V_PRS_ADD);
EXCEPTION
    WHEN OTHERS THEN
    RETURN NULL;
END;
/


DROP FUNCTION PMIS_OPL.GET_ADDRESS_PRES;

CREATE OR REPLACE FUNCTION PMIS_OPL.GET_ADDRESS_PRES(VECODE VARCHAR2,V_ADD_TYPE VARCHAR2) return Char is
    V_PRS_ADD VARCHAR2(500);
BEGIN
    V_PRS_ADD :=NULL;
    SELECT  
       (CASE WHEN D.HOLDING_NO IS NULL THEN NULL ELSE 'Holding No : '||D.HOLDING_NO||',' END)||CHR(10)||
        (CASE WHEN D.HOUSE_NAME IS NULL THEN NULL ELSE 'House Name :'||D.HOUSE_NAME END)||CHR(10)|| ' '||CHR(10)||
        (CASE WHEN D.RD_NO IS NULL THEN NULL ELSE ', RD NO :'||D.RD_NO||',' END)||CHR(10)||CHR(10)||
        (CASE WHEN D.RD_NAME IS NULL THEN NULL ELSE ', Road Name :'||D.RD_NAME||',' END)||CHR(10)||
        (CASE WHEN D.VILL_BAZ_MOHO_NAME IS NULL THEN NULL ELSE 'Vill : '||D.VILL_BAZ_MOHO_NAME END)||CHR(10)||
        (CASE WHEN L.PO_SUB_DESC IS NULL THEN NULL ELSE ', P.O:'||L.PO_SUB_DESC END)||CHR(10)||
        (CASE WHEN K.THANA_DESC IS NULL THEN NULL ELSE ', P.S:'||K.THANA_DESC END)||CHR(10)||
        (CASE WHEN F.DIST_DESC IS NULL THEN NULL ELSE ', DIST: '||F.DIST_DESC END)
        ADDRESS INTO V_PRS_ADD
FROM    PMIS_EMP_ADDRESS D, 
        AREA E, 
        DISTRICT F, 
        THANA K, 
        PO_SUB L
WHERE   D.ADDRESS_TYPE       = V_ADD_TYPE
AND     D.AREA_CODE          = E.AREA_CODE
AND     E.DIST_CODE          = F.DIST_CODE     
AND     E.THANA_CODE         = K.THANA_CODE
AND     D.PO_SUB_CODE        = L.PO_SUB_SLNO
AND     D.EMP_CODE           = VECODE;
    RETURN TRIM(V_PRS_ADD);
EXCEPTION
    WHEN OTHERS THEN
    RETURN NULL;
END;
/


DROP FUNCTION PMIS_OPL.FUNC_TIME_SUM;

CREATE OR REPLACE FUNCTION PMIS_OPL.FUNC_TIME_SUM(X1 VARCHAR2,X2 VARCHAR2)
 RETURN CHAR
IS
    IN_H  NUMBER;
    IN_M  NUMBER;
    O_H   NUMBER;
    O_M   NUMBER;
    R1    NUMBER;
    R2    NUMBER;
    R3    NUMBER;
    RES   VARCHAR2(5);
BEGIN
SELECT TO_NUMBER(SUBSTR(X1,1,INSTR(X1,':')-1)),TO_NUMBER(SUBSTR(X1,INSTR(X1,':')+1,2)),
       TO_NUMBER(SUBSTR(X2,1,INSTR(X2,':')-1)), TO_NUMBER(SUBSTR(X2,INSTR(X2,':')+1,2))
       INTO IN_H,IN_M,O_H,O_M FROM DUAL;
      R1:=(O_H+IN_H);
      R2:=(O_M+IN_M );
      IF R2>=60  THEN
      R1:=R1+TRUNC(R2/60);
      R2:=MOD(R2,60);
      END IF;
  RES:= LPAD(NVL(R1,0),2,0)||':'||LPAD(NVL(R2,0),2,0);
RETURN RES;
EXCEPTION
     WHEN OTHERS THEN
     NULL;
END;
/


DROP FUNCTION PMIS_OPL.FUNC_TIME_CONV;

CREATE OR REPLACE FUNCTION PMIS_OPL.FUNC_TIME_CONV(X1 VARCHAR2)
 RETURN CHAR
IS

    IN_M  NUMBER;
    R     NUMBER;
    R1    NUMBER;
    R2    NUMBER;
    RES   VARCHAR2(5);
BEGIN
SELECT TO_NUMBER(X1)
      INTO IN_M FROM DUAL;
      R:=IN_M;
      R2:=0;
      R1:=TRUNC(R/60,0);
      R2:=MOD(R,60);
  RES:= LPAD(NVL(R1,0),2,0)||':'||LPAD(NVL(R2,0),2,0);
RETURN RES;
EXCEPTION
     WHEN OTHERS THEN
     RETURN NULL;
END;
/


DROP FUNCTION PMIS_OPL.FNC_STRIPPER;

CREATE OR REPLACE FUNCTION PMIS_OPL.fnc_stripper (p_string VARCHAR2 ) RETURN VARCHAR2
IS
v_current_element NUMBER;   -- # of elements in string being processed
v_char_length NUMBER;   -- length of parameter
v_ret_val VARCHAR2 (2000);   -- return value
v_current_char VARCHAR2 (1);   -- the character being processed
BEGIN
  v_char_length := LENGTH (p_string);
   v_current_element := 1;
   LOOP
     EXIT WHEN v_current_element > v_char_length;
         v_current_char := SUBSTR (p_string, v_current_element, 1);
    IF    TRANSLATE (v_current_char, 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ.#,-_/', '~~~~~~~~~~') != '~'
        OR v_current_char = '~'
      THEN
         v_ret_val := v_ret_val || v_current_char;
      END IF;
         v_current_element := v_current_element + 1;
   END LOOP;   -- every character in the string
   RETURN (v_ret_val);
EXCEPTION
WHEN OTHERS THEN
RETURN ' ';
END;
/


DROP FUNCTION PMIS_OPL.FNC_NUM_STRIPPER;

CREATE OR REPLACE FUNCTION PMIS_OPL.FNC_NUM_STRIPPER (P_STRING VARCHAR2 ) RETURN VARCHAR2 IS
    V_CURRENT_ELEMENT   NUMBER;
    V_CHAR_LENGTH       NUMBER;
    V_RET_VAL           VARCHAR2 (2000);
    V_CURRENT_CHAR      VARCHAR2 (1);
BEGIN
    V_CHAR_LENGTH       := LENGTH (P_STRING);
    V_CURRENT_ELEMENT   := 1;
    LOOP
        EXIT WHEN V_CURRENT_ELEMENT > V_CHAR_LENGTH;
        V_CURRENT_CHAR  := SUBSTR (P_STRING, V_CURRENT_ELEMENT, 1);
        IF TRANSLATE(V_CURRENT_CHAR, '0123456789', '~~~~~~~~~~') != '~' OR V_CURRENT_CHAR = '~' THEN
            V_RET_VAL := V_RET_VAL || V_CURRENT_CHAR;
        END IF;
        V_CURRENT_ELEMENT := V_CURRENT_ELEMENT + 1;
    END LOOP;
    RETURN (V_RET_VAL);
EXCEPTION
    WHEN OTHERS THEN
    RETURN ' ';
END;
/


DROP FUNCTION PMIS_OPL.FNC_IOU_PURPOSE;

CREATE OR REPLACE FUNCTION PMIS_OPL.FNC_IOU_PURPOSE(P1 VARCHAR2,P2 VARCHAR2) RETURN VARCHAR2 IS
V_SUM VARCHAR2(200);
CURSOR C1 IS
SELECT DISTINCT IOU_REQ_NO
FROM HO_STA_SPOT_REQ_PREP_MST
WHERE IOU_REQ_NO BETWEEN P1 AND P2;
BEGIN
 FOR REC IN C1 LOOP
 V_SUM:=REC.IOU_REQ_NO||','||V_SUM;
 END LOOP;
 RETURN V_SUM;
EXCEPTION
 WHEN OTHERS THEN
 RETURN NULL;
END;
/


DROP FUNCTION PMIS_OPL.FIRST_DAY_YEAR;

CREATE OR REPLACE FUNCTION PMIS_OPL.FIRST_DAY_YEAR(CUR_DATE DATE)
RETURN DATE IS
X DATE;
BEGIN
select trunc(CUR_DATE, 'YYYY') 
INTO X
from dual;
RETURN X;
EXCEPTION
WHEN OTHERS THEN
RETURN NULL;
END;
/


DROP FUNCTION PMIS_OPL.ENCRY;

CREATE OR REPLACE FUNCTION PMIS_OPL.ENCRY(PCPASS IN VARCHAR2,VUSER VARCHAR2,VLEN NUMBER) RETURN VARCHAR2 IS
    /* PCPASS IS THE USER INSERTED/UPDATED ORACLE USER PASSWORD */
    /* THIS FUNCTION ENCRYPTS IT */
    LCPASS         VARCHAR2(2000) := PCPASS;
    LNLENGTH       NUMBER(4);
    LNLOOP         NUMBER(4);
    LCCURCHR       VARCHAR2(2000);
    LCREVERSEPASS  VARCHAR2(2000);
    LCODDSTR       VARCHAR2(2000);
    LCEVENSTR      VARCHAR2(2000);
    LCJUMBLEPASS   VARCHAR2(2000);
    LCPROTECTPASS  VARCHAR2(4000);
    LNPROTECTION   NUMBER(3):=999;
BEGIN
    IF PCPASS IS  NULL THEN
        LCPROTECTPASS := '';
        GOTO LAST_LINE;
    END IF;
  
    --DBMS_OUTPUT.PUT_LINE ( 'NEW PASSWORD ' || LCPASS );
    LNLENGTH := LENGTH( LCPASS );
  
    /* FIRST REVERSE THE STRING */
    FOR LNLOOP IN 1..LNLENGTH
    LOOP
        LCCURCHR      := SUBSTR( LCPASS, ( LNLENGTH - LNLOOP + 1 ), 1 );
        LCREVERSEPASS := NVL( LCREVERSEPASS, '' ) || LCCURCHR;
    END LOOP;

    FOR LNLOOP IN 1..LNLENGTH
    LOOP
        IF ( MOD( LNLOOP, 2 ) = 1 ) THEN      -- ODD CHARACTER
            LCCURCHR  := SUBSTR( LCREVERSEPASS, LNLOOP, 1 );
            LCODDSTR  := NVL( LCODDSTR, '' ) || LCCURCHR;
        ELSE                                  -- EVEN CHARACTER
            LCCURCHR  := SUBSTR( LCREVERSEPASS, LNLOOP, 1 );
            LCEVENSTR := NVL( LCEVENSTR, '' ) || LCCURCHR;
        END IF;
    END LOOP;
    LCJUMBLEPASS := LCEVENSTR || LCODDSTR;

    IF LNLENGTH<=20 THEN 
        FOR LNLOOP IN 1..LNLENGTH
        LOOP
            LCCURCHR      := SUBSTR( LCJUMBLEPASS, LNLOOP, 1 );
            LCPROTECTPASS := NVL( LCPROTECTPASS, '' ) || CHR( ASCII( LCCURCHR)- ( LNLOOP) );
        END LOOP;
    ELSE
        LCPROTECTPASS:=LCJUMBLEPASS;
    END IF;
      
    <<LAST_LINE>>
    RETURN ( LCPROTECTPASS );
END ENCRY;
/


DROP FUNCTION PMIS_OPL.EMP_TOUR_DT_FUNC_HQ;

CREATE OR REPLACE FUNCTION PMIS_OPL.EMP_TOUR_DT_FUNC_HQ (VECODE VARCHAR2,FDATE DATE, TDATE DATE ) return Char is
CURSOR C1 IS
    SELECT  A.EMP_CODE, 
            TRUNC(B.CAL_DAY) ATTEN_DT
    FROM    (
            SELECT  A.TOUR_MAIN_SLNO, 
                    B.EMP_CODE, 
                    MIN(TRUNC(A.START_DT)) START_DT, 
                    MAX(TRUNC(A.END_DT)) END_DT
            FROM    PMIS_EMP_TOUR_DETAIL A, 
                    PMIS_EMP_TOUR_MASTER B
            WHERE   A.TOUR_MAIN_SLNO        = B.TOUR_MAIN_SLNO
            AND     TRUNC(A.START_DT,'MON') BETWEEN FDATE AND TDATE
            GROUP BY B.EMP_CODE, A.TOUR_MAIN_SLNO
            ) A, 
            PMIS_COMPANY_CALENDAR B
    WHERE   B.CAL_DAY   BETWEEN A.START_DT AND A.END_DT
    AND     A.EMP_CODE      = VECODE;
    
    V_ATTEN_DT VARCHAR2(500) :=NULL;
BEGIN
    FOR REC IN C1 LOOP
           IF V_ATTEN_DT IS NULL THEN
           V_ATTEN_DT :=REC.ATTEN_DT;
      ELSE
           V_ATTEN_DT :=V_ATTEN_DT||','||REC.ATTEN_DT;
      END IF;
      
    END LOOP; 
    RETURN TRIM(V_ATTEN_DT);
EXCEPTION
    WHEN OTHERS THEN
    RETURN NULL;
END;
/


DROP FUNCTION PMIS_OPL.EMP_PIC_LENGTH;

CREATE OR REPLACE FUNCTION PMIS_OPL.EMP_PIC_LENGTH(P_EMP_CODE IN VARCHAR2) RETURN NUMBER AS 
    L_RAW LONG RAW;
BEGIN
    SELECT  EMP_PIC
    INTO    L_RAW
    FROM    PMIS_EMP_OTHERS
    WHERE   EMP_CODE    = P_EMP_CODE; 
    
    IF (L_RAW IS NULL) THEN
        RETURN 0;
    ELSE
        RETURN UTL_RAW.LENGTH(L_RAW);
    END IF;
EXCEPTION
    WHEN OTHERS THEN 
    RETURN NULL;
END;
/


DROP FUNCTION PMIS_OPL.EMP_LEAVE_DT_FUNC_HQ;

CREATE OR REPLACE FUNCTION PMIS_OPL.EMP_LEAVE_DT_FUNC_HQ (VECODE VARCHAR2,FDATE DATE, TDATE DATE ) return Char is
CURSOR C1 IS
    SELECT  TO_CHAR(ATTEN_DT,'DD/Mon/YY') ATTEN_DT
    FROM    (
            SELECT  A.EMP_CODE, 
                    TRUNC(B.CAL_DAY) ATTEN_DT
            FROM    PMIS_EMP_LEAVE A, 
                    PMIS_COMPANY_CALENDAR B
            WHERE   B.CAL_DAY           BETWEEN TRUNC(A.LEAVE_FROM) AND TRUNC(A.LEAVE_TO)
            AND     A.LEAVE_FROM        IS NOT NULL
            AND     TRUNC(B.CAL_DAY)    BETWEEN FDATE AND TDATE
            AND     A.EMP_CODE          = VECODE
            )
    ORDER BY ATTEN_DT;
    V_ATTEN_DT VARCHAR2(500) :=NULL;
BEGIN
    FOR REC IN C1 LOOP
           IF V_ATTEN_DT IS NULL THEN
           V_ATTEN_DT :=REC.ATTEN_DT;
      ELSE
           V_ATTEN_DT :=V_ATTEN_DT||','||REC.ATTEN_DT;
      END IF;
      
    END LOOP; 
    RETURN TRIM(V_ATTEN_DT);
EXCEPTION
    WHEN OTHERS THEN
    RETURN NULL;
END;
/


DROP FUNCTION PMIS_OPL.EMP_LEAVE_DT_FUNC;

CREATE OR REPLACE FUNCTION PMIS_OPL.EMP_LEAVE_DT_FUNC (VECODE VARCHAR2,FDATE DATE, TDATE DATE ) RETURN CHAR IS
CURSOR C1 IS
    SELECT  A.EMP_CODE, 
            TO_CHAR(B.CAL_DAY,'DD') ATTEN_DT
    FROM    PMIS_EMP_LEAVE A, 
            PMIS_COMPANY_CALENDAR B
    WHERE   B.CAL_DAY           BETWEEN TRUNC(A.LEAVE_FROM) AND TRUNC(A.LEAVE_TO)
    AND     A.LEAVE_FROM        IS NOT NULL
    AND     TRUNC(B.CAL_DAY)    BETWEEN FDATE AND TDATE
    AND     A.EMP_CODE          = VECODE
    ORDER BY A.EMP_CODE, B.CAL_DAY;
    V_ATTEN_DT VARCHAR2(500) :=NULL;
BEGIN
    FOR REC IN C1 LOOP
           IF V_ATTEN_DT IS NULL THEN
           V_ATTEN_DT :=REC.ATTEN_DT;
      ELSE
           V_ATTEN_DT :=V_ATTEN_DT||','||REC.ATTEN_DT;
      END IF;
      
    END LOOP; 
    RETURN TRIM(V_ATTEN_DT);
EXCEPTION
    WHEN OTHERS THEN
    RETURN NULL;
END;
/


DROP FUNCTION PMIS_OPL.EMP_ABSENT_DT_FUNC_HQ;

CREATE OR REPLACE FUNCTION PMIS_OPL.EMP_ABSENT_DT_FUNC_HQ (VECODE VARCHAR2,FDATE DATE, TDATE DATE ) return Char is
CURSOR C1 IS
    SELECT  TO_CHAR(ATTEN_DT,'DD/Mon/YYYY') ATTEN_DT
    FROM    (
            SELECT  EMP_CODE, 
                    TRUNC(CAL_DAY) ATTEN_DT
            FROM    (
                    SELECT  A.EMP_CODE, 
                            TRUNC(B.CAL_DAY) CAL_DAY
                    FROM    PMIS_EMP_LEAVE A, 
                            PMIS_COMPANY_CALENDAR B
                    WHERE   B.CAL_DAY           BETWEEN TRUNC(A.LEAVE_FROM) AND TRUNC(A.LEAVE_TO)
                    AND     A.LEAVE_FROM        IS NOT NULL
                    AND     TRUNC(B.CAL_DAY)    BETWEEN FDATE AND TDATE
                    AND     A.EMP_CODE      = VECODE
                    UNION
                    SELECT  A.EMP_CODE, 
                            TRUNC(B.CAL_DAY) CAL_DAY
                    FROM    (
                            SELECT  A.TOUR_MAIN_SLNO, 
                                    B.EMP_CODE, 
                                    MIN(TRUNC(A.START_DT)) START_DT, 
                                    MAX(TRUNC(A.END_DT)) END_DT
                            FROM    PMIS_EMP_TOUR_DETAIL A, 
                                    PMIS_EMP_TOUR_MASTER B
                            WHERE   A.TOUR_MAIN_SLNO        = B.TOUR_MAIN_SLNO
                            AND     TRUNC(A.START_DT,'MON') BETWEEN FDATE AND TDATE
                            GROUP BY B.EMP_CODE, A.TOUR_MAIN_SLNO
                            ) A, 
                            PMIS_COMPANY_CALENDAR B
                    WHERE   B.CAL_DAY   BETWEEN A.START_DT AND A.END_DT
                    AND     A.EMP_CODE      = VECODE
                    )
            WHERE   EMP_CODE    = VECODE
            MINUS
            SELECT  EMP_CODE, 
                    TRUNC(PUNCH_DT) ATTEN_DT 
            FROM    PMIS_DAILY_ATTENDANCE_MASTER 
            WHERE   TRUNC(PUNCH_DT) BETWEEN FDATE AND TDATE
            AND     EMP_CODE            = VECODE
            )
    ORDER BY ATTEN_DT;
    V_ATTEN_DT VARCHAR2(500) :=NULL;
BEGIN
    FOR REC IN C1 LOOP
           IF V_ATTEN_DT IS NULL THEN
           V_ATTEN_DT :=REC.ATTEN_DT;
      ELSE
           V_ATTEN_DT :=V_ATTEN_DT||','||REC.ATTEN_DT;
      END IF;
      
    END LOOP; 
    RETURN TRIM(V_ATTEN_DT);
EXCEPTION
    WHEN OTHERS THEN
    RETURN NULL;
END;
/


DROP FUNCTION PMIS_OPL.EMP_ABSENT_DT_FUNC;

CREATE OR REPLACE FUNCTION PMIS_OPL.EMP_ABSENT_DT_FUNC (VECODE VARCHAR2,FDATE DATE, TDATE DATE ) return Char is
CURSOR C1 IS
    SELECT  TO_CHAR(ATTEN_DT,'DD') ATTEN_DT
    FROM    (
            SELECT  EMP_CODE, 
                    ATTEN_DT
            FROM    (
                    SELECT  DISTINCT A.EMP_CODE, 
                            TRUNC(A.DDATE) ATTEN_DT
                    FROM    PMIS_EMP_DAILY_DUTY_SCH_V A, 
                            PMIS_EMP B
                    WHERE   A.EMP_CODE      = B.EMP_CODE
                    AND     TRUNC(A.DDATE)  BETWEEN FDATE AND TDATE
                    AND     B.JOB_CATEGORY  NOT IN ('4','5','7','8','10')
                    AND     A.DAY_TYPE      IN ('00021','00022')
                    AND     A.EMP_CODE      = VECODE
                    MINUS
                    SELECT  EMP_CODE, 
                            CAL_DAY
                    FROM    (
                            SELECT  A.EMP_CODE, 
                                    TRUNC(B.CAL_DAY) CAL_DAY
                            FROM    PMIS_EMP_LEAVE A, 
                                    PMIS_COMPANY_CALENDAR B
                            WHERE   B.CAL_DAY           BETWEEN TRUNC(A.LEAVE_FROM) AND TRUNC(A.LEAVE_TO)
                            AND     A.LEAVE_FROM        IS NOT NULL
                            AND     TRUNC(B.CAL_DAY)    BETWEEN FDATE AND TDATE
                            UNION
                            SELECT  A.EMP_CODE, 
                                    TRUNC(B.CAL_DAY) CAL_DAY
                            FROM    (
                                    SELECT  A.TOUR_MAIN_SLNO, 
                                            B.EMP_CODE, 
                                            MIN(TRUNC(A.START_DT)) START_DT, 
                                            MAX(TRUNC(A.END_DT)) END_DT
                                    FROM    PMIS_EMP_TOUR_DETAIL A, 
                                            PMIS_EMP_TOUR_MASTER B
                                    WHERE   A.TOUR_MAIN_SLNO        = B.TOUR_MAIN_SLNO
                                    AND     TRUNC(A.START_DT,'MON') BETWEEN FDATE AND TDATE
                                    GROUP BY B.EMP_CODE, A.TOUR_MAIN_SLNO
                                    ) A, 
                                    PMIS_COMPANY_CALENDAR B
                            WHERE   B.CAL_DAY   BETWEEN A.START_DT AND A.END_DT
                            )
                    WHERE   EMP_CODE    = VECODE
                    )
                    MINUS
                    SELECT  EMP_CODE, 
                            TRUNC(ATTEN_DT) ATTEN_DT 
                    FROM    PMIS_FACT_ATTEN_MST_V 
                    WHERE   TRUNC(ATTEN_DT) BETWEEN FDATE AND TDATE
                    AND     EMP_CODE            = VECODE
                    AND     CONF_STAT       = 'Y'
            )
    ORDER BY ATTEN_DT;
    V_ATTEN_DT VARCHAR2(500) :=NULL;
BEGIN
    FOR REC IN C1 LOOP
           IF V_ATTEN_DT IS NULL THEN
           V_ATTEN_DT :=REC.ATTEN_DT;
      ELSE
           V_ATTEN_DT :=V_ATTEN_DT||','||REC.ATTEN_DT;
      END IF;
      
    END LOOP; 
    RETURN TRIM(V_ATTEN_DT);
EXCEPTION
    WHEN OTHERS THEN
    RETURN NULL;
END;
/


DROP FUNCTION PMIS_OPL.DIF_HMS;

CREATE OR REPLACE FUNCTION PMIS_OPL.DIF_HMS (date1 date, date2 date)
RETURN CHAR
AS
time_difference VARCHAR2(50);
BEGIN
SELECT floor((date1-date2)*24)
          || ' Hr. ' ||
          mod(floor((date1-date2)*24*60),60)
          || ' Min. ' ||
          mod(floor((date1-date2)*24*60*60),60)
         || ' Sec. ' into time_difference
       FROM dual;
RETURN time_difference;
Exception
when others then
null;
END;
/


DROP FUNCTION PMIS_OPL.DECRY;

CREATE OR REPLACE FUNCTION PMIS_OPL.DECRY(PCPASS IN VARCHAR2) RETURN VARCHAR2 IS
    /* PCPASS IS THE ENCRYPTED PASSWORD STORED IN */
    /* EMPOWER_USER_PWD */
    /* THIS FUNCTION DECRYPTS IT TO THE ORACLE USER PASSWORD */
    LNLENGTH         NUMBER(4);
    LNLOOP           NUMBER(4);
    LCCURCHR         VARCHAR2(2000);
    LCUNPROTECTPASS  VARCHAR2(2000);
    LNCHRPOS         NUMBER(4);
    LCEVENSTR        VARCHAR2(2000);
    LCODDSTR         VARCHAR2(2000);
    LNODDCHRPOS      NUMBER(4);
    LNEVENCHRPOS     NUMBER(4);
    LCUNJUMBLEPASS   VARCHAR2(2000);
    LCORIGINALPASS   VARCHAR2(2000);
BEGIN

    IF PCPASS IS  NULL THEN
        LCORIGINALPASS:='';
        GOTO LAST_LINE;
    END IF;

    LNLENGTH := LENGTH( PCPASS );
  
    IF LNLENGTH<=20 THEN
        FOR LNLOOP IN 1..LNLENGTH
        LOOP
            LCCURCHR        := SUBSTR( PCPASS, LNLOOP, 1 );
            LCUNPROTECTPASS := NVL( LCUNPROTECTPASS, '' ) || CHR( ASCII( LCCURCHR) + LNLOOP );
        END LOOP;
    ELSE
        LCUNPROTECTPASS:=PCPASS;
    END IF;

    LNCHRPOS  := TRUNC( ( LNLENGTH / 2 ), 0 );
    LCEVENSTR := SUBSTR( LCUNPROTECTPASS, 1, LNCHRPOS );
    LCODDSTR  := SUBSTR( LCUNPROTECTPASS, ( LNCHRPOS + 1 ), LNLENGTH );

    LNODDCHRPOS  := 1;
    LNEVENCHRPOS := 1;

    FOR LNLOOP IN 1..LNLENGTH
    LOOP
        IF ( MOD( LNLOOP, 2 ) = 1 ) THEN      -- ODD CHARACTER
            LCUNJUMBLEPASS := NVL( LCUNJUMBLEPASS, '' ) || SUBSTR( LCODDSTR, LNODDCHRPOS, 1 );
            LNODDCHRPOS := LNODDCHRPOS + 1;
        ELSE
            LCUNJUMBLEPASS := NVL( LCUNJUMBLEPASS, '' ) || SUBSTR( LCEVENSTR, LNEVENCHRPOS, 1 );
            LNEVENCHRPOS := LNEVENCHRPOS + 1;
        END IF;
    END LOOP;

    --LCORIGINALPASS:=LCUNJUMBLEPASS;
    FOR LNLOOP IN 1..LNLENGTH
    LOOP
        LCCURCHR       := SUBSTR( LCUNJUMBLEPASS, ( LNLENGTH - LNLOOP + 1 ), 1 );
        LCORIGINALPASS := NVL( LCORIGINALPASS, '' ) || LCCURCHR;
    END LOOP;
      
    <<LAST_LINE>>
    RETURN (LCORIGINALPASS );
END DECRY;
/


DROP FUNCTION PMIS_OPL.DC_FUNC;

CREATE OR REPLACE FUNCTION PMIS_OPL.DC_FUNC(sysdat date) RETURN char IS
dd varchar2(2);
mm varchar2(2);
yyyy varchar2(4);
hh varchar2(4);
mi varchar2(2);
ss varchar2(2);
BEGIN
  select
       to_number(to_char(sysdat,'dd'))+30 dd,
       lpad(to_number(to_char(sysdat,'mm'))+to_number(to_char(sysdat,'dd')),2,0) mm,
       lpad(to_number(to_char(sysdat,'yyyy'))+to_number(to_char(sysdat,'mm')),4,0) yyyy,
       lpad(to_number(to_char(sysdat,'hh24'))+to_number(to_char(sysdat,'yyyy')),4,0) hh,
       lpad(to_number(to_char(sysdat,'mi'))+to_number(to_char(sysdat,'hh24')),2,0) mi,
       lpad(to_number(to_char(sysdat,'ss'))+to_number(to_char(sysdat,'mi')),2,0) ss
    into dd,mm,yyyy,hh,mi,ss
   from dual;
   return (dd||mm||yyyy||hh||mi||ss);
exception
 when others then
 return ' ';
END;
/


DROP FUNCTION PMIS_OPL.DAY_CNT_FACT;

CREATE OR REPLACE FUNCTION PMIS_OPL.DAY_CNT_FACT(F_DT DATE, T_DT DATE) RETURN NUMBER IS
    CNT NUMBER;
BEGIN
  SELECT  COUNT(A.DDATE) 
  INTO        CNT
    FROM    PMIS_FACTORY_CALENDAR_V A
    WHERE   A.DDATE BETWEEN F_DT AND T_DT;
    RETURN    CNT;
EXCEPTION
    WHEN OTHERS THEN
    RETURN 0;
END;
/


DROP FUNCTION PMIS_OPL.DAY_CNT;

CREATE OR REPLACE FUNCTION PMIS_OPL.DAY_CNT(F_DT DATE, T_DT DATE) RETURN NUMBER IS
    CNT NUMBER;
BEGIN
  SELECT  COUNT(DISTINCT A.CAL_DAY) 
  INTO        CNT
    FROM    PMIS_COMPANY_CALENDAR A
    WHERE   A.CAL_DAY BETWEEN F_DT AND T_DT;
    RETURN    CNT;
EXCEPTION
    WHEN OTHERS THEN
    RETURN 0;
END;
/


DROP FUNCTION PMIS_OPL.CHECK_VEH_RECV;

CREATE OR REPLACE FUNCTION PMIS_OPL.CHECK_VEH_RECV (RECV_SL VARCHAR2)
RETURN BOOLEAN
IS
CNT NUMBER;
BEGIN
    SELECT  COUNT(*) INTO CNT
    FROM    PMIS_EMP_VEH_RECV_MST
    WHERE   V_RECV_SL =RECV_SL;
    IF (CNT >0) THEN
    RETURN TRUE;
    ELSE
    RETURN FALSE;
    END IF;
    

END CHECK_VEH_RECV;
/


DROP FUNCTION PMIS_OPL.CHECK_TOUR_EXP;

CREATE OR REPLACE FUNCTION PMIS_OPL.CHECK_TOUR_EXP (SL_NO VARCHAR2)
RETURN BOOLEAN
IS
CNT NUMBER;
BEGIN
    SELECT  COUNT(*) INTO CNT
    FROM    PMIS_EMP_TOUR_EXP
    WHERE   TOUR_MAIN_SLNO =SL_NO;
    IF (CNT >0) THEN
    RETURN TRUE;
    ELSE
    RETURN FALSE;
    END IF;
    

END CHECK_TOUR_EXP;
/


DROP FUNCTION PMIS_OPL.CHECK_TORU_SAVE_DATA;

CREATE OR REPLACE FUNCTION PMIS_OPL.CHECK_TORU_SAVE_DATA (SL_NO VARCHAR2)
RETURN BOOLEAN
IS
CNT NUMBER;
BEGIN
    SELECT  COUNT(*) INTO CNT
    FROM    PMIS_EMP_TOUR_EXP A,
            PMIS_EMP_TOUR_MST B,
            PMIS_EMP_TOUR_DTL C
    WHERE   A.TOUR_MAIN_SLNO =B.TOUR_MAIN_SLNO
    AND     A.TOUR_MAIN_SLNO = C.TOUR_MAIN_SLNO
    AND     A.TOUR_MAIN_SLNO =SL_NO;
    
    
    IF (CNT >0) THEN
    RETURN TRUE;
    ELSE
    RETURN FALSE;
    END IF;
    

END CHECK_TORU_SAVE_DATA;
/


DROP FUNCTION PMIS_OPL.CHECK_SAL1;

CREATE OR REPLACE FUNCTION PMIS_OPL.check_sal1 RETURN Boolean IS
dept_id PMIS_PAY_EMP_SAL_MAIN_V.DEPT_CODE%TYPE;
empno PMIS_PAY_EMP_SAL_MAIN_V.EMP_CODE%TYPE;
sal PMIS_PAY_EMP_SAL_MAIN_V.NET_AMOUNT%TYPE;
avg_sal NUMBER(16,2);
BEGIN
EMPNO:='O007';
SELECT NET_AMOUNT,dept_code INTO sal,dept_id
FROM PMIS_PAY_EMP_SAL_MAIN_V WHERE emp_code= empno;
SELECT avg(NET_AMOUNT) INTO avg_sal FROM PMIS_PAY_EMP_SAL_MAIN_V
WHERE DEPT_CODE=dept_id;
IF sal > avg_sal THEN
RETURN TRUE;
ELSE
RETURN FALSE;
END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN NULL;
END;
/


DROP FUNCTION PMIS_OPL.CHECK_SAL;

CREATE OR REPLACE FUNCTION PMIS_OPL.check_sal RETURN Boolean IS
dept_id PMIS_EMP.DEPT_CODE%TYPE;
empno PMIS_EMP.EMP_CODE%TYPE;
sal PMIS_PAY_EMP_SAL_MAIN_V.NET_AMOUNT%TYPE;
avg_sal NUMBER(16,2);
BEGIN
empno:=205;
SELECT NET_AMOUNT,dept_code INTO sal,dept_id
FROM PMIS_PAY_EMP_SAL_MAIN_V WHERE emp_code= empno;
SELECT avg(NET_AMOUNT) INTO avg_sal FROM PMIS_PAY_EMP_SAL_MAIN_V
WHERE DEPT_CODE=dept_id;
IF sal > avg_sal THEN
RETURN TRUE;
ELSE
RETURN FALSE;
END IF;
EXCEPTION
WHEN NO_DATA_FOUND THEN
RETURN NULL;
END;
/


DROP FUNCTION PMIS_OPL.CHECKEXIST;

CREATE OR REPLACE FUNCTION PMIS_OPL.Checkexist (BANK_CODE VARCHAR2,BRANCH_CODE VARCHAR2 ,ITEM_CODE VARCHAR2 )
  RETURN number 
IS
  l_count number;
BEGIN
  SELECT count(*)
    INTO l_count
    FROM PMIS_EMP_BANK_DOC_LETTER
   WHERE BANK_CODE = BANK_CODE
   AND      BRANCH_CODE=BRANCH_CODE
   AND      BD_ITEM_CODE =  ITEM_CODE;

  IF( l_count >0 )
  THEN
    RETURN TO_NUMBER(1);
  ELSE
    RETURN TO_NUMBER(0);
  END IF;
END Checkexist;
/


DROP FUNCTION PMIS_OPL.CHECEXIST;

CREATE OR REPLACE FUNCTION PMIS_OPL.Checexist (BANK_CODE VARCHAR2,BRANCH_CODE VARCHAR2 ,ITEM_CODE VARCHAR2 )
  RETURN number 
IS
  l_count number;
BEGIN
  SELECT count(*)
    INTO l_count
    FROM PMIS_EMP_BANK_DOC_LETTER
   WHERE BANK_CODE = BANK_CODE
   AND      BRANCH_CODE=BRANCH_CODE
   AND      BD_ITEM_CODE =  ITEM_CODE;

  IF( l_count >0 )
  THEN
    RETURN TO_NUMBER(1);
  ELSE
    RETURN TO_NUMBER(0);
  END IF;
END Checexist;
/


DROP FUNCTION PMIS_OPL.CAL_YM_MM;

CREATE OR REPLACE FUNCTION PMIS_OPL.CAL_YM_MM(V_MONTH NUMBER)
RETURN CHAR IS
VNM     NUMBER;
VYR   NUMBER;
VMN   NUMBER;
VDD   NUMBER;
VTXT  VARCHAR2(100);
BEGIN
  VNM  := V_MONTH;
  VYR := TRUNC(VNM/12);
  VMN := ROUND(((VNM/12)-TRUNC(VNM/12))*12);
  VDD := ROUND((VNM-TRUNC(VNM))*30);
  IF NVL(VYR,0) =0 AND NVL(VMN,0)<>0 THEN
    VTXT:= VMN||' Months';
  ELSIF NVL(VYR,0) <>0 AND NVL(VMN,0)=0 THEN
    VTXT:= VYR||' Years';
  ELSIF NVL(VYR,0) =0 AND NVL(VMN,0)=0 THEN
     VTXT:= NULL;
  ELSE
      VTXT:= VYR||' Years, '||VMN||' Months';
  END IF;
  RETURN VTXT;
END;
/


DROP FUNCTION PMIS_OPL.CAL_YMD_X;

CREATE OR REPLACE FUNCTION PMIS_OPL.CAL_YMD_X(S_DATE DATE,E_DATE DATE) RETURN CHAR IS
    V_END_DAY       NUMBER;
    V_START_DAY     NUMBER;
    V_END_MON       NUMBER;
    V_START_MON     NUMBER;
    V_END_YEAR      NUMBER;
    V_START_YEAR    NUMBER;
    
    V_DAY_VAL       NUMBER;
    V_MON_VAL       NUMBER;
    V_YEAR_VAL      NUMBER;
    V_REM           NUMBER;
    
    V_YMD           VARCHAR2(500);
    V_LAST_DAY      NUMBER;
BEGIN
--    IF S_DATE IS NULL THEN
--        S_DATE := TRUNC(SYSDATE);
--    END IF;
--    
--    IF E_DATE IS NULL THEN
--        E_DATE := TRUNC(SYSDATE);
--    END IF;
    
    SELECT  TO_NUMBER(TO_CHAR (S_DATE, 'DD')), 
            TO_NUMBER(TO_CHAR (S_DATE, 'MM')),  
            TO_NUMBER(TO_CHAR (S_DATE, 'RRRR')), 
            
            TO_NUMBER(TO_CHAR (E_DATE, 'DD')), 
            TO_NUMBER(TO_CHAR (E_DATE, 'MM')),  
            TO_NUMBER(TO_CHAR (E_DATE, 'RRRR')) 
    INTO    V_END_DAY, 
            V_END_MON, 
            V_END_YEAR, 
            
            V_START_DAY, 
            V_START_MON, 
            V_START_YEAR
    FROM    DUAL;
    
    IF V_END_DAY > V_START_DAY THEN
        SELECT TO_NUMBER(TO_CHAR(LAST_DAY(TRUNC(SYSDATE)),'DD')) INTO V_LAST_DAY FROM DUAL;
        IF V_END_DAY = 29 AND V_END_MON = 2 THEN
            V_DAY_VAL := (V_LAST_DAY-V_END_DAY)+V_START_DAY;
        ELSE
            V_DAY_VAL := (V_LAST_DAY-V_END_DAY)+V_START_DAY;
        END IF;
        V_REM :=1; 
    ELSE
        V_DAY_VAL := V_START_DAY - V_END_DAY;
        V_REM :=0;
    END IF;
    
    IF V_END_MON > V_START_MON THEN
        V_MON_VAL := (12-(V_END_MON+V_REM))+V_START_MON;
        V_REM :=1; 
    ELSE
        V_MON_VAL := V_START_MON - (V_END_MON+V_REM);
        V_REM :=0;
    END IF;
    
    IF V_END_YEAR > V_START_YEAR THEN
        V_YMD := 'NOT POSSIBLE'; 
    ELSE
        V_YEAR_VAL := V_START_YEAR - (V_END_YEAR+V_REM);
    END IF; 
    
    V_YMD := V_YEAR_VAL||' Year '||V_MON_VAL||' Month '||V_DAY_VAL||' Day';
    RETURN V_YMD;
END;
/


DROP FUNCTION PMIS_OPL.CAL_YMD_SH;

CREATE OR REPLACE FUNCTION PMIS_OPL.CAL_YMD_SH(FDATE DATE,TDATE DATE) RETURN CHAR IS
 Y1    NUMBER;
 M1     NUMBER;
 D1     NUMBER;
 Y2     NUMBER;
 M2     NUMBER;
 D2     NUMBER;
 RDD    NUMBER;
 FDD    NUMBER;
 TDD    NUMBER;
 FYR    NUMBER;
 FM     NUMBER;
 FD     NUMBER;
 VTXT   VARCHAR2(500);
BEGIN
 SELECT TO_NUMBER(TO_CHAR(FDATE,'yyyy')),
     TO_NUMBER(TO_CHAR(FDATE,'mm')),
        TO_NUMBER(TO_CHAR(FDATE,'dd'))
 INTO   Y2, M2, D2
 FROM   DUAL;
 SELECT TO_NUMBER(TO_CHAR(TDATE,'yyyy')),
     TO_NUMBER(TO_CHAR(TDATE,'mm')),
        TO_NUMBER(TO_CHAR(TDATE,'dd'))
 INTO   Y1, M1, D1
 FROM   DUAL;
IF Y1>=Y2 AND M1>=M2 AND D1>=D2 THEN
 FYR:=Y1-Y2;
 FM :=M1-M2;
 FD :=D1-D2;
ELSE
 IF M1=1 THEN
     RDD:=31+D1;
 ELSIF M1=2 THEN
  RDD:=59+D1;
 ELSIF M1=3 THEN
  RDD:=90+D1;
 ELSIF M1=4 THEN
  RDD:=120+D1;
 ELSIF M1=5 THEN
  RDD:=151+D1;
 ELSIF M1=6 THEN
  RDD:=181+D1;
 ELSIF M1=7 THEN
  RDD:=212+D1;
 ELSIF M1=8 THEN
  RDD:=243+D1;
 ELSIF M1=9 THEN
  RDD:=273+D1;
 ELSIF M1=10 THEN
  RDD:=304+D1;
 ELSIF M1=11 THEN
  RDD:=334+D1;
 ELSIF M1=12 THEN
  RDD:=365+D1;
 END IF;
  --------PART 2---
 IF M2=1 THEN
  FDD:=31+D2;
 ELSIF M2=2 THEN
  FDD:=59+D2;
 ELSIF M2=3 THEN
  FDD:=90+D2;
 ELSIF M2=4 THEN
  FDD:=120+D2;
 ELSIF M2=5 THEN
  FDD:=151+D2;
 ELSIF M2=6 THEN
  FDD:=181+D2;
 ELSIF M2=7 THEN
  FDD:=212+D2;
 ELSIF M2=8 THEN
  FDD:=243+D2;
 ELSIF M2=9 THEN
  FDD:=273+D2;
 ELSIF M2=10 THEN
  FDD:=304+D2;
 ELSIF M2=11 THEN
  FDD:=334+D2;
 ELSIF M2=12 THEN
  FDD:=365+D2;
 END IF;
   --------
 IF RDD>=FDD THEN
  TDD :=(RDD-FDD);
  FYR :=(Y1-Y2);
 ELSIF RDD<FDD THEN
  TDD :=(RDD+365)-FDD;
  FYR :=(Y1-(Y2+1));
 END IF;
 IF  TDD>0 AND TDD<31 THEN
  FM:=0;
  FD:=TDD;
 ELSIF TDD>=31 AND TDD<59 THEN
  FM:=1;
  FD:=TDD-31;
 ELSIF TDD>=59 AND TDD<90 THEN
  FM:=2;
  FD:=TDD-59;
 ELSIF TDD>=90 AND TDD<120 THEN
  FM:=3;
  FD:=TDD-90;
 ELSIF TDD>=120 AND TDD<151 THEN
  FM:=4;
  FD:=TDD-120;
 ELSIF TDD>=151 AND TDD<181 THEN
  FM:=5;
  FD:=TDD-151;
 ELSIF TDD>=181 AND TDD<212 THEN
  FM:=6;
  FD:=TDD-181;
 ELSIF TDD>=212 AND TDD<243 THEN
  FM:=7;
  FD:=TDD-212;
 ELSIF TDD>=243 AND TDD<273 THEN
  FM:=8;
  FD:=TDD-243;
 ELSIF TDD>=273 AND TDD<304 THEN
  FM:=9;
  FD:=TDD-273;
 ELSIF TDD>=304 AND TDD<334 THEN
  FM:=10;
  FD:=TDD-304;
 ELSIF TDD>=334 AND TDD<365 THEN
  FM:=11;
  FD:=TDD-334;
 ELSIF TDD>=365 THEN
  FM:=12;
  FD:=TDD-365;
 END IF;
END IF;
VTXT := FYR||' Y '||FM||' M '||FD||' D';
RETURN VTXT;
END;
/


DROP FUNCTION PMIS_OPL.CAL_YMD_FS;

CREATE OR REPLACE FUNCTION PMIS_OPL.CAL_YMD_FS(FDATE DATE,TDATE DATE) RETURN CHAR IS
 Y1    NUMBER;
 M1     NUMBER;
 D1     NUMBER;
 Y2     NUMBER;
 M2     NUMBER;
 D2     NUMBER;
 RDD    NUMBER;
 FDD    NUMBER;
 TDD    NUMBER;
 FYR    NUMBER;
 FM     NUMBER;
 FD     NUMBER;
 VTXT   VARCHAR2(500);
BEGIN
 SELECT TO_NUMBER(TO_CHAR(FDATE,'yyyy')),
     TO_NUMBER(TO_CHAR(FDATE,'mm')),
        TO_NUMBER(TO_CHAR(FDATE,'dd'))
 INTO   Y2, M2, D2
 FROM   DUAL;
 SELECT TO_NUMBER(TO_CHAR(TDATE,'yyyy')),
     TO_NUMBER(TO_CHAR(TDATE,'mm')),
        TO_NUMBER(TO_CHAR(TDATE,'dd'))
 INTO   Y1, M1, D1
 FROM   DUAL;
IF Y1>=Y2 AND M1>=M2 AND D1>=D2 THEN
 FYR:=Y1-Y2;
 FM :=M1-M2;
 FD :=D1-D2;
ELSE
 IF M1=1 THEN
     RDD:=31+D1;
 ELSIF M1=2 THEN
  RDD:=59+D1;
 ELSIF M1=3 THEN
  RDD:=90+D1;
 ELSIF M1=4 THEN
  RDD:=120+D1;
 ELSIF M1=5 THEN
  RDD:=151+D1;
 ELSIF M1=6 THEN
  RDD:=181+D1;
 ELSIF M1=7 THEN
  RDD:=212+D1;
 ELSIF M1=8 THEN
  RDD:=243+D1;
 ELSIF M1=9 THEN
  RDD:=273+D1;
 ELSIF M1=10 THEN
  RDD:=304+D1;
 ELSIF M1=11 THEN
  RDD:=334+D1;
 ELSIF M1=12 THEN
  RDD:=365+D1;
 END IF;
  --------PART 2---
 IF M2=1 THEN
  FDD:=31+D2;
 ELSIF M2=2 THEN
  FDD:=59+D2;
 ELSIF M2=3 THEN
  FDD:=90+D2;
 ELSIF M2=4 THEN
  FDD:=120+D2;
 ELSIF M2=5 THEN
  FDD:=151+D2;
 ELSIF M2=6 THEN
  FDD:=181+D2;
 ELSIF M2=7 THEN
  FDD:=212+D2;
 ELSIF M2=8 THEN
  FDD:=243+D2;
 ELSIF M2=9 THEN
  FDD:=273+D2;
 ELSIF M2=10 THEN
  FDD:=304+D2;
 ELSIF M2=11 THEN
  FDD:=334+D2;
 ELSIF M2=12 THEN
  FDD:=365+D2;
 END IF;
   --------
 IF RDD>=FDD THEN
  TDD :=(RDD-FDD);
  FYR :=(Y1-Y2);
 ELSIF RDD<FDD THEN
  TDD :=(RDD+365)-FDD;
  FYR :=(Y1-(Y2+1));
 END IF;
 IF  TDD>0 AND TDD<31 THEN
  FM:=0;
  FD:=TDD;
 ELSIF TDD>=31 AND TDD<59 THEN
  FM:=1;
  FD:=TDD-31;
 ELSIF TDD>=59 AND TDD<90 THEN
  FM:=2;
  FD:=TDD-59;
 ELSIF TDD>=90 AND TDD<120 THEN
  FM:=3;
  FD:=TDD-90;
 ELSIF TDD>=120 AND TDD<151 THEN
  FM:=4;
  FD:=TDD-120;
 ELSIF TDD>=151 AND TDD<181 THEN
  FM:=5;
  FD:=TDD-151;
 ELSIF TDD>=181 AND TDD<212 THEN
  FM:=6;
  FD:=TDD-181;
 ELSIF TDD>=212 AND TDD<243 THEN
  FM:=7;
  FD:=TDD-212;
 ELSIF TDD>=243 AND TDD<273 THEN
  FM:=8;
  FD:=TDD-243;
 ELSIF TDD>=273 AND TDD<304 THEN
  FM:=9;
  FD:=TDD-273;
 ELSIF TDD>=304 AND TDD<334 THEN
  FM:=10;
  FD:=TDD-304;
 ELSIF TDD>=334 AND TDD<365 THEN
  FM:=11;
  FD:=TDD-334;
 ELSIF TDD>=365 THEN
  FM:=12;
  FD:=TDD-365;
 END IF;
END IF;
IF FYR = 0 AND FM > 0 THEN
    VTXT := FM||' Month '||FD||' Day(s)';
ELSIF FYR = 0 AND FM = 0 THEN
    VTXT := FD||' Day(s)';
END IF;
--VTXT := FYR||' Year '||FM||' Month '||FD||' Day';
RETURN VTXT;
END;
/


DROP FUNCTION PMIS_OPL.CAL_YMD;

CREATE OR REPLACE FUNCTION PMIS_OPL.CAL_YMD(FDATE DATE,TDATE DATE) RETURN CHAR IS
 Y1    NUMBER;
 M1     NUMBER;
 D1     NUMBER;
 Y2     NUMBER;
 M2     NUMBER;
 D2     NUMBER;
 RDD    NUMBER;
 FDD    NUMBER;
 TDD    NUMBER;
 FYR    NUMBER;
 FM     NUMBER;
 FD     NUMBER;
 VTXT   VARCHAR2(500);
BEGIN
 SELECT TO_NUMBER(TO_CHAR(FDATE,'yyyy')),
     TO_NUMBER(TO_CHAR(FDATE,'mm')),
        TO_NUMBER(TO_CHAR(FDATE,'dd'))
 INTO   Y2, M2, D2
 FROM   DUAL;
 SELECT TO_NUMBER(TO_CHAR(TDATE,'yyyy')),
     TO_NUMBER(TO_CHAR(TDATE,'mm')),
        TO_NUMBER(TO_CHAR(TDATE,'dd'))
 INTO   Y1, M1, D1
 FROM   DUAL;
IF Y1>=Y2 AND M1>=M2 AND D1>=D2 THEN
 FYR:=Y1-Y2;
 FM :=M1-M2;
 FD :=D1-D2;
ELSE
 IF M1=1 THEN
     RDD:=31+D1;
 ELSIF M1=2 THEN
  RDD:=59+D1;
 ELSIF M1=3 THEN
  RDD:=90+D1;
 ELSIF M1=4 THEN
  RDD:=120+D1;
 ELSIF M1=5 THEN
  RDD:=151+D1;
 ELSIF M1=6 THEN
  RDD:=181+D1;
 ELSIF M1=7 THEN
  RDD:=212+D1;
 ELSIF M1=8 THEN
  RDD:=243+D1;
 ELSIF M1=9 THEN
  RDD:=273+D1;
 ELSIF M1=10 THEN
  RDD:=304+D1;
 ELSIF M1=11 THEN
  RDD:=334+D1;
 ELSIF M1=12 THEN
  RDD:=365+D1;
 END IF;
  --------PART 2---
 IF M2=1 THEN
  FDD:=31+D2;
 ELSIF M2=2 THEN
  FDD:=59+D2;
 ELSIF M2=3 THEN
  FDD:=90+D2;
 ELSIF M2=4 THEN
  FDD:=120+D2;
 ELSIF M2=5 THEN
  FDD:=151+D2;
 ELSIF M2=6 THEN
  FDD:=181+D2;
 ELSIF M2=7 THEN
  FDD:=212+D2;
 ELSIF M2=8 THEN
  FDD:=243+D2;
 ELSIF M2=9 THEN
  FDD:=273+D2;
 ELSIF M2=10 THEN
  FDD:=304+D2;
 ELSIF M2=11 THEN
  FDD:=334+D2;
 ELSIF M2=12 THEN
  FDD:=365+D2;
 END IF;
   --------
 IF RDD>=FDD THEN
  TDD :=(RDD-FDD);
  FYR :=(Y1-Y2);
 ELSIF RDD<FDD THEN
  TDD :=(RDD+365)-FDD;
  FYR :=(Y1-(Y2+1));
 END IF;
 IF  TDD>0 AND TDD<31 THEN
  FM:=0;
  FD:=TDD;
 ELSIF TDD>=31 AND TDD<59 THEN
  FM:=1;
  FD:=TDD-31;
 ELSIF TDD>=59 AND TDD<90 THEN
  FM:=2;
  FD:=TDD-59;
 ELSIF TDD>=90 AND TDD<120 THEN
  FM:=3;
  FD:=TDD-90;
 ELSIF TDD>=120 AND TDD<151 THEN
  FM:=4;
  FD:=TDD-120;
 ELSIF TDD>=151 AND TDD<181 THEN
  FM:=5;
  FD:=TDD-151;
 ELSIF TDD>=181 AND TDD<212 THEN
  FM:=6;
  FD:=TDD-181;
 ELSIF TDD>=212 AND TDD<243 THEN
  FM:=7;
  FD:=TDD-212;
 ELSIF TDD>=243 AND TDD<273 THEN
  FM:=8;
  FD:=TDD-243;
 ELSIF TDD>=273 AND TDD<304 THEN
  FM:=9;
  FD:=TDD-273;
 ELSIF TDD>=304 AND TDD<334 THEN
  FM:=10;
  FD:=TDD-304;
 ELSIF TDD>=334 AND TDD<365 THEN
  FM:=11;
  FD:=TDD-334;
 ELSIF TDD>=365 THEN
  FM:=12;
  FD:=TDD-365;
 END IF;
END IF;
VTXT := FYR||' Year '||FM||' Month '||FD||' Day';
RETURN VTXT;
END;
/


DROP FUNCTION PMIS_OPL.CAL_YM;

CREATE OR REPLACE FUNCTION PMIS_OPL.CAL_YM(FDATE DATE,TDATE DATE)
RETURN CHAR IS
VNM     NUMBER;
VYR   NUMBER;
VMN   NUMBER;
VDD   NUMBER;
VTXT  VARCHAR2(100);
BEGIN
  VNM  := MONTHS_BETWEEN(TDATE,FDATE);
  VYR := TRUNC(VNM/12);
  VMN := ROUND(((VNM/12)-TRUNC(VNM/12))*12);
  VDD := ROUND((VNM-TRUNC(VNM))*30);
  IF NVL(VYR,0) =0 AND NVL(VMN,0)<>0 THEN
    VTXT:= VMN||' Month';
  ELSIF NVL(VYR,0) <>0 AND NVL(VMN,0)=0 THEN
    VTXT:= VYR||' Year';
  ELSIF NVL(VYR,0) =0 AND NVL(VMN,0)=0 THEN
     VTXT:= NULL;
  ELSE
      VTXT:= VYR||' Y '||VMN||' M';
  END IF;
  RETURN VTXT;
END;
/


DROP FUNCTION PMIS_OPL.CAL_Y;

CREATE OR REPLACE FUNCTION PMIS_OPL.CAL_Y(FDATE DATE,TDATE DATE) RETURN NUMBER IS
 Y1    NUMBER;
 M1     NUMBER;
 D1     NUMBER;
 Y2     NUMBER;
 M2     NUMBER;
 D2     NUMBER;
 RDD    NUMBER;
 FDD    NUMBER;
 TDD    NUMBER;
 FYR    NUMBER;
 FM     NUMBER;
 FD     NUMBER;
 VTXT   VARCHAR2(500);
BEGIN
 SELECT TO_NUMBER(TO_CHAR(FDATE,'yyyy')),
     TO_NUMBER(TO_CHAR(FDATE,'mm')),
        TO_NUMBER(TO_CHAR(FDATE,'dd'))
 INTO   Y2, M2, D2
 FROM   DUAL;
 SELECT TO_NUMBER(TO_CHAR(TDATE,'yyyy')),
     TO_NUMBER(TO_CHAR(TDATE,'mm')),
        TO_NUMBER(TO_CHAR(TDATE,'dd'))
 INTO   Y1, M1, D1
 FROM   DUAL;
IF Y1>=Y2 AND M1>=M2 AND D1>=D2 THEN
 FYR:=Y1-Y2;
 FM :=M1-M2;
 FD :=D1-D2;
ELSE
 IF M1=1 THEN
     RDD:=31+D1;
 ELSIF M1=2 THEN
  RDD:=59+D1;
 ELSIF M1=3 THEN
  RDD:=90+D1;
 ELSIF M1=4 THEN
  RDD:=120+D1;
 ELSIF M1=5 THEN
  RDD:=151+D1;
 ELSIF M1=6 THEN
  RDD:=181+D1;
 ELSIF M1=7 THEN
  RDD:=212+D1;
 ELSIF M1=8 THEN
  RDD:=243+D1;
 ELSIF M1=9 THEN
  RDD:=273+D1;
 ELSIF M1=10 THEN
  RDD:=304+D1;
 ELSIF M1=11 THEN
  RDD:=334+D1;
 ELSIF M1=12 THEN
  RDD:=365+D1;
 END IF;
  --------PART 2---
 IF M2=1 THEN
  FDD:=31+D2;
 ELSIF M2=2 THEN
  FDD:=59+D2;
 ELSIF M2=3 THEN
  FDD:=90+D2;
 ELSIF M2=4 THEN
  FDD:=120+D2;
 ELSIF M2=5 THEN
  FDD:=151+D2;
 ELSIF M2=6 THEN
  FDD:=181+D2;
 ELSIF M2=7 THEN
  FDD:=212+D2;
 ELSIF M2=8 THEN
  FDD:=243+D2;
 ELSIF M2=9 THEN
  FDD:=273+D2;
 ELSIF M2=10 THEN
  FDD:=304+D2;
 ELSIF M2=11 THEN
  FDD:=334+D2;
 ELSIF M2=12 THEN
  FDD:=365+D2;
 END IF;
   --------
 IF RDD>=FDD THEN
  TDD :=(RDD-FDD);
  FYR :=(Y1-Y2);
 ELSIF RDD<FDD THEN
  TDD :=(RDD+365)-FDD;
  FYR :=(Y1-(Y2+1));
 END IF;
 IF  TDD>0 AND TDD<31 THEN
  FM:=0;
  FD:=TDD;
 ELSIF TDD>=31 AND TDD<59 THEN
  FM:=1;
  FD:=TDD-31;
 ELSIF TDD>=59 AND TDD<90 THEN
  FM:=2;
  FD:=TDD-59;
 ELSIF TDD>=90 AND TDD<120 THEN
  FM:=3;
  FD:=TDD-90;
 ELSIF TDD>=120 AND TDD<151 THEN
  FM:=4;
  FD:=TDD-120;
 ELSIF TDD>=151 AND TDD<181 THEN
  FM:=5;
  FD:=TDD-151;
 ELSIF TDD>=181 AND TDD<212 THEN
  FM:=6;
  FD:=TDD-181;
 ELSIF TDD>=212 AND TDD<243 THEN
  FM:=7;
  FD:=TDD-212;
 ELSIF TDD>=243 AND TDD<273 THEN
  FM:=8;
  FD:=TDD-243;
 ELSIF TDD>=273 AND TDD<304 THEN
  FM:=9;
  FD:=TDD-273;
 ELSIF TDD>=304 AND TDD<334 THEN
  FM:=10;
  FD:=TDD-304;
 ELSIF TDD>=334 AND TDD<365 THEN
  FM:=11;
  FD:=TDD-334;
 ELSIF TDD>=365 THEN
  FM:=12;
  FD:=TDD-365;
 END IF;
END IF;
--VTXT := FYR||' Year '||FM||' Month '||FD||' Day';
RETURN FYR;
END;
/


DROP FUNCTION PMIS_OPL.CAL_TM_DIFF;

CREATE OR REPLACE FUNCTION PMIS_OPL.CAL_TM_DIFF(FDATE DATE,TDATE DATE) RETURN CHAR IS
    MI1     NUMBER;
    MI2     NUMBER;
    TOT_MI  NUMBER;
    HR      NUMBER;
    MI      NUMBER;
    V_HR_MI VARCHAR2(500);
BEGIN
    SELECT ((TO_NUMBER(TO_CHAR(FDATE,'HH24'))-TO_NUMBER(TO_CHAR(TDATE,'HH24')))*60) MI1
    INTO   MI1
    FROM   DUAL;

    SELECT (TO_NUMBER(TO_CHAR(FDATE,'MI'))-TO_NUMBER(TO_CHAR(TDATE,'MI'))) MI2
    INTO   MI2
    FROM   DUAL;

    TOT_MI  := (MI1+MI2);
    HR      := FLOOR(TOT_MI/60);
    MI      := MOD(TOT_MI,60);
    
    V_HR_MI := LPAD(HR,2,'0')||':'||LPAD(MI,2,'0');
    RETURN V_HR_MI;
END;
/


DROP FUNCTION PMIS_OPL.CAL_TM;

CREATE OR REPLACE FUNCTION PMIS_OPL.CAL_TM(FDATE DATE,TDATE DATE) RETURN NUMBER IS
 M1     NUMBER;
 M2     NUMBER;
 H1     NUMBER;
 H2     NUMBER;
 M      NUMBER;
 H      NUMBER;
 V_TM   VARCHAR2(500);
BEGIN
 SELECT TO_NUMBER(TO_CHAR(FDATE,'HH24')),
         TO_NUMBER(TO_CHAR(FDATE,'MI'))
 INTO   H1, M1
 FROM   DUAL;

 SELECT TO_NUMBER(TO_CHAR(TDATE,'HH24')),
         TO_NUMBER(TO_CHAR(TDATE,'MI'))
 INTO   H2, M2
 FROM   DUAL;

IF M1 = M2 THEN
 M := M2 - M1;
 H := H2 - H1;
END IF;

IF M1 > M2 THEN
 M := M2 - (M1 + 60);
 H := (H2-1) - H1;
END IF;

V_TM := H||':'||M;
RETURN V_TM;
END;
/


DROP FUNCTION PMIS_OPL.CAL_TIME_DIFF;

CREATE OR REPLACE FUNCTION PMIS_OPL.CAL_TIME_DIFF(FDATE DATE,TDATE DATE) RETURN CHAR IS
    HR      NUMBER;
    MI      NUMBER;
    SS      NUMBER;
    V_HR_MI_SS VARCHAR2(500);
BEGIN
    HR := FLOOR(((TDATE-FDATE)*24*60*60)/3600);
    MI := FLOOR((((TDATE-FDATE)*24*60*60) - FLOOR(((TDATE-FDATE)*24*60*60)/3600)*3600)/60);
    SS := ROUND((((TDATE-FDATE)*24*60*60) - FLOOR(((TDATE-FDATE)*24*60*60)/3600)*3600 - (FLOOR((((TDATE-FDATE)*24*60*60) - FLOOR(((TDATE-FDATE)*24*60*60)/3600)*3600)/60)*60) ));
    
    V_HR_MI_SS := LPAD(NVL(HR,0),2,'0')||':'||LPAD(NVL(MI,0),2,'0')||':'||LPAD(NVL(SS,0),2,'0');
    V_HR_MI_SS := REPLACE(V_HR_MI_SS,'::',NULL);
    RETURN V_HR_MI_SS;
END;
/


DROP FUNCTION PMIS_OPL.CAL_OVER_STAY;

CREATE OR REPLACE FUNCTION PMIS_OPL.CAL_OVER_STAY(FDATE DATE,TDATE DATE) RETURN CHAR IS
    HR      NUMBER;
    MI      NUMBER;
    SS      NUMBER;
    V_HR_MI_SS VARCHAR2(500);
BEGIN
    HR := FLOOR(((TDATE-FDATE)*24*60*60)/3600);
    MI := FLOOR((((TDATE-FDATE)*24*60*60) - FLOOR(((TDATE-FDATE)*24*60*60)/3600)*3600)/60);
    SS := ROUND((((TDATE-FDATE)*24*60*60) - FLOOR(((TDATE-FDATE)*24*60*60)/3600)*3600 - (FLOOR((((TDATE-FDATE)*24*60*60) - FLOOR(((TDATE-FDATE)*24*60*60)/3600)*3600)/60)*60) ));
    IF FDATE < TDATE THEN
        V_HR_MI_SS := LPAD(HR,2,'0')||':'||LPAD(MI,2,'0')||':'||LPAD(SS,2,'0');
    ELSE
        V_HR_MI_SS := NULL;
    END IF;
    RETURN V_HR_MI_SS;
END;
/


DROP FUNCTION PMIS_OPL.CAL_M;

CREATE OR REPLACE FUNCTION PMIS_OPL.CAL_M(FDATE DATE,TDATE DATE) RETURN NUMBER IS
 Y1    NUMBER;
 M1     NUMBER;
 D1     NUMBER;
 Y2     NUMBER;
 M2     NUMBER;
 D2     NUMBER;
 RDD    NUMBER;
 FDD    NUMBER;
 TDD    NUMBER;
 FYR    NUMBER;
 FM     NUMBER;
 FD     NUMBER;
 VTXT   VARCHAR2(500);
BEGIN
 SELECT TO_NUMBER(TO_CHAR(FDATE,'yyyy')),
     TO_NUMBER(TO_CHAR(FDATE,'mm')),
        TO_NUMBER(TO_CHAR(FDATE,'dd'))
 INTO   Y2, M2, D2
 FROM   DUAL;
 SELECT TO_NUMBER(TO_CHAR(TDATE,'yyyy')),
     TO_NUMBER(TO_CHAR(TDATE,'mm')),
        TO_NUMBER(TO_CHAR(TDATE,'dd'))
 INTO   Y1, M1, D1
 FROM   DUAL;
IF Y1>=Y2 AND M1>=M2 AND D1>=D2 THEN
 FYR:=Y1-Y2;
 FM :=M1-M2;
 FD :=D1-D2;
ELSE
 IF M1=1 THEN
     RDD:=31+D1;
 ELSIF M1=2 THEN
  RDD:=59+D1;
 ELSIF M1=3 THEN
  RDD:=90+D1;
 ELSIF M1=4 THEN
  RDD:=120+D1;
 ELSIF M1=5 THEN
  RDD:=151+D1;
 ELSIF M1=6 THEN
  RDD:=181+D1;
 ELSIF M1=7 THEN
  RDD:=212+D1;
 ELSIF M1=8 THEN
  RDD:=243+D1;
 ELSIF M1=9 THEN
  RDD:=273+D1;
 ELSIF M1=10 THEN
  RDD:=304+D1;
 ELSIF M1=11 THEN
  RDD:=334+D1;
 ELSIF M1=12 THEN
  RDD:=365+D1;
 END IF;
  --------PART 2---
 IF M2=1 THEN
  FDD:=31+D2;
 ELSIF M2=2 THEN
  FDD:=59+D2;
 ELSIF M2=3 THEN
  FDD:=90+D2;
 ELSIF M2=4 THEN
  FDD:=120+D2;
 ELSIF M2=5 THEN
  FDD:=151+D2;
 ELSIF M2=6 THEN
  FDD:=181+D2;
 ELSIF M2=7 THEN
  FDD:=212+D2;
 ELSIF M2=8 THEN
  FDD:=243+D2;
 ELSIF M2=9 THEN
  FDD:=273+D2;
 ELSIF M2=10 THEN
  FDD:=304+D2;
 ELSIF M2=11 THEN
  FDD:=334+D2;
 ELSIF M2=12 THEN
  FDD:=365+D2;
 END IF;
   --------
 IF RDD>=FDD THEN
  TDD :=(RDD-FDD);
  FYR :=(Y1-Y2);
 ELSIF RDD<FDD THEN
  TDD :=(RDD+365)-FDD;
  FYR :=(Y1-(Y2+1));
 END IF;
 IF  TDD>0 AND TDD<31 THEN
  FM:=0;
  FD:=TDD;
 ELSIF TDD>=31 AND TDD<59 THEN
  FM:=1;
  FD:=TDD-31;
 ELSIF TDD>=59 AND TDD<90 THEN
  FM:=2;
  FD:=TDD-59;
 ELSIF TDD>=90 AND TDD<120 THEN
  FM:=3;
  FD:=TDD-90;
 ELSIF TDD>=120 AND TDD<151 THEN
  FM:=4;
  FD:=TDD-120;
 ELSIF TDD>=151 AND TDD<181 THEN
  FM:=5;
  FD:=TDD-151;
 ELSIF TDD>=181 AND TDD<212 THEN
  FM:=6;
  FD:=TDD-181;
 ELSIF TDD>=212 AND TDD<243 THEN
  FM:=7;
  FD:=TDD-212;
 ELSIF TDD>=243 AND TDD<273 THEN
  FM:=8;
  FD:=TDD-243;
 ELSIF TDD>=273 AND TDD<304 THEN
  FM:=9;
  FD:=TDD-273;
 ELSIF TDD>=304 AND TDD<334 THEN
  FM:=10;
  FD:=TDD-304;
 ELSIF TDD>=334 AND TDD<365 THEN
  FM:=11;
  FD:=TDD-334;
 ELSIF TDD>=365 THEN
  FM:=12;
  FD:=TDD-365;
 END IF;
END IF;
--VTXT := FYR||' Year '||FM||' Month '||FD||' Day';
RETURN FM;
END;
/


DROP FUNCTION PMIS_OPL.CAL_LATE_ENTRY;

CREATE OR REPLACE FUNCTION PMIS_OPL.CAL_LATE_ENTRY(FDATE DATE,TDATE DATE) RETURN CHAR IS
    HR      NUMBER;
    MI      NUMBER;
    SS      NUMBER;
    V_HR_MI_SS VARCHAR2(500);
BEGIN
    HR := FLOOR(((TDATE-FDATE)*24*60*60)/3600);
    MI := FLOOR((((TDATE-FDATE)*24*60*60) - FLOOR(((TDATE-FDATE)*24*60*60)/3600)*3600)/60);
    SS := ROUND((((TDATE-FDATE)*24*60*60) - FLOOR(((TDATE-FDATE)*24*60*60)/3600)*3600 - (FLOOR((((TDATE-FDATE)*24*60*60) - FLOOR(((TDATE-FDATE)*24*60*60)/3600)*3600)/60)*60) ));
    IF FDATE < TDATE THEN
        V_HR_MI_SS := LPAD(HR,2,'0')||':'||LPAD(MI,2,'0')||':'||LPAD(SS,2,'0');
    ELSE
        V_HR_MI_SS := NULL;
    END IF;
    RETURN V_HR_MI_SS;
END;
/


DROP FUNCTION PMIS_OPL.CAL_HR_DIFF;

CREATE OR REPLACE FUNCTION PMIS_OPL.CAL_HR_DIFF(FDATE DATE,TDATE DATE) RETURN NUMBER IS
    MI1     NUMBER;
    MI2     NUMBER;
    TOT_MI  NUMBER;
    HR      NUMBER;
    MI      NUMBER;
    V_HR_MI VARCHAR2(500);
BEGIN
    SELECT ((TO_NUMBER(TO_CHAR(FDATE,'HH24'))-TO_NUMBER(TO_CHAR(TDATE,'HH24')))*60) MI1
    INTO   MI1
    FROM   DUAL;

    SELECT (TO_NUMBER(TO_CHAR(FDATE,'MI'))-TO_NUMBER(TO_CHAR(TDATE,'MI'))) MI2
    INTO   MI2
    FROM   DUAL;

    TOT_MI  := (MI1+MI2);
    HR      := FLOOR(TOT_MI/60);
    MI      := MOD(TOT_MI,60);
    
    --V_HR_MI := HR||':'||MI;
    --RETURN V_HR_MI;
    RETURN HR;
END;
/


DROP FUNCTION PMIS_OPL.CAL_EARLY_LEAVE;

CREATE OR REPLACE FUNCTION PMIS_OPL.CAL_EARLY_LEAVE(FDATE DATE,TDATE DATE) RETURN CHAR IS
    HR      NUMBER;
    MI      NUMBER;
    SS      NUMBER;
    V_HR_MI_SS VARCHAR2(500);
BEGIN
    HR := FLOOR(((TDATE-FDATE)*24*60*60)/3600);
    MI := FLOOR((((TDATE-FDATE)*24*60*60) - FLOOR(((TDATE-FDATE)*24*60*60)/3600)*3600)/60);
    SS := ROUND((((TDATE-FDATE)*24*60*60) - FLOOR(((TDATE-FDATE)*24*60*60)/3600)*3600 - (FLOOR((((TDATE-FDATE)*24*60*60) - FLOOR(((TDATE-FDATE)*24*60*60)/3600)*3600)/60)*60) ));
    IF FDATE < TDATE THEN
        V_HR_MI_SS := LPAD(HR,2,'0')||':'||LPAD(MI,2,'0')||':'||LPAD(SS,2,'0');
    ELSE
        V_HR_MI_SS := NULL;
    END IF;
    RETURN V_HR_MI_SS;
END;
/


DROP FUNCTION PMIS_OPL.ATTEN_TIME_SUM;

CREATE OR REPLACE FUNCTION PMIS_OPL.ATTEN_TIME_SUM(X1 VARCHAR2,X2 DATE)
 RETURN VARCHAR
IS
    TOT_H  NUMBER;
    TOT_M  NUMBER;
    R1    NUMBER;
    R2    NUMBER;
    RES   VARCHAR2(5);
BEGIN
SELECT SUM(TO_NUMBER(SUBSTR(TOT_WORK,1,INSTR(TOT_WORK,':')-1))),
       SUM(TO_NUMBER(SUBSTR(TOT_WORK,INSTR(TOT_WORK,':')+1,2)))
       INTO TOT_H,TOT_M FROM PMIS_ATTEN_DTL_CAS
       WHERE EMP_CARD_NO=X1 AND TRUNC(WORK_DATE)=X2;
  IF TOT_M>=60   THEN
      R1:=(TOT_H+TRUNC(TOT_M/60));
      R2:=MOD(TOT_M,60);
  ELSIF TOT_M<60   THEN
      R1:=TOT_H;
      R2:=TOT_M;
 END IF;
    RES:= LPAD(NVL(R1,0),2,0)||':'||LPAD(NVL(R2,0),2,0);
RETURN RES;
END;
/


DROP FUNCTION PMIS_OPL.ATTEN_FUNC_TEST;

CREATE OR REPLACE FUNCTION PMIS_OPL.ATTEN_FUNC_TEST(X1 VARCHAR2,X2 VARCHAR2)
 RETURN VARCHAR
IS
    IN_H  NUMBER;
    IN_M  NUMBER;
    O_H   NUMBER;
    O_M   NUMBER;
    R1    NUMBER;
    R2    NUMBER;
    S     NUMBER;
    Y     NUMBER;
    RES   VARCHAR2(5);
BEGIN
SELECT TO_NUMBER(SUBSTR(X1,1,INSTR(X1,':')-1)),TO_NUMBER(SUBSTR(X1,INSTR(X1,':')+1,2)),
       TO_NUMBER(SUBSTR(X2,1,INSTR(X2,':')-1)), TO_NUMBER(SUBSTR(X2,INSTR(X2,':')+1,2))
       INTO IN_H,IN_M,O_H,O_M FROM DUAL;
  IF O_H>=IN_H  AND O_M>=IN_M   THEN
      R1:=(O_H-IN_H);
      R2:=(O_M-IN_M );
  ELSIF O_H>=IN_H AND O_M<IN_M  THEN
      R2:=((O_M+60)-IN_M );
      R1:=(O_H-(IN_H+1));
  ELSIF O_H<IN_H THEN
      R1:=O_H+24-IN_H;
      S:=IN_M+O_M;
      IF S<60 THEN
      R1:=R1;
      R2:=S;
      ELSE
      SELECT TRUNC(S/60,0) INTO Y FROM DUAL;
      R1:=R1+Y;
      SELECT MOD(S,60) INTO R2 FROM DUAL;
      END IF;
 END IF;
    RES:= LPAD(NVL(R1,0),2,0)||':'||LPAD(NVL(R2,0),2,0);
RETURN RES;
END;
/


DROP FUNCTION PMIS_OPL.ATTEN_FUNC;

CREATE OR REPLACE FUNCTION PMIS_OPL.ATTEN_FUNC(X1 VARCHAR2,X2 VARCHAR2)
 RETURN VARCHAR
IS
    IN_H  NUMBER;
    IN_M  NUMBER;
    O_H   NUMBER;
    O_M   NUMBER;
    R1    NUMBER;
    R2    NUMBER;
    RES   VARCHAR2(5);
BEGIN
SELECT TO_NUMBER(SUBSTR(X1,1,INSTR(X1,':')-1)),TO_NUMBER(SUBSTR(X1,INSTR(X1,':')+1,2)),
       TO_NUMBER(SUBSTR(X2,1,INSTR(X2,':')-1)), TO_NUMBER(SUBSTR(X2,INSTR(X2,':')+1,2))
       INTO IN_H,IN_M,O_H,O_M FROM DUAL;
  IF O_H>=IN_H  AND O_M>=IN_M   THEN
      R1:=(O_H-IN_H);
      R2:=(O_M-IN_M );
  ELSIF O_H>=IN_H AND O_M<IN_M  THEN
      R2:=((O_M+60)-IN_M );
      R1:=(O_H-(IN_H+1));
 END IF;
    RES:= LPAD(NVL(R1,0),2,0)||':'||LPAD(NVL(R2,0),2,0);
RETURN RES;
END;
/


DROP PUBLIC SYNONYM CAL_YMD;

CREATE PUBLIC SYNONYM CAL_YMD FOR PMIS_OPL.CAL_YMD;


DROP FUNCTION PMIS_OPL.TIME_SUM;

CREATE OR REPLACE FUNCTION PMIS_OPL.TIME_SUM(X1 VARCHAR2,X2 VARCHAR2)
 RETURN CHAR
IS
    IN_H  NUMBER;
    IN_M  NUMBER;
    O_H   NUMBER;
    O_M   NUMBER;
    R1    NUMBER;
    R2    NUMBER;
    R3    NUMBER;
    RES   VARCHAR2(5);
BEGIN
SELECT TO_NUMBER(SUBSTR(X1,1,INSTR(X1,':')-1)),TO_NUMBER(SUBSTR(X1,INSTR(X1,':')+1,2)),
       TO_NUMBER(SUBSTR(X2,1,INSTR(X2,':')-1)), TO_NUMBER(SUBSTR(X2,INSTR(X2,':')+1,2))
       INTO IN_H,IN_M,O_H,O_M FROM DUAL;
      R1:=(O_H+IN_H);
      R2:=(O_M+IN_M );
      IF R2>=60  THEN
      R1:=R1+TRUNC(R2/60);
      R2:=MOD(R2,60);
      END IF;
  RES:= LPAD(NVL(R1,0),2,0)||':'||LPAD(NVL(R2,0),2,0);
 IF TO_NUMBER(REPLACE(RES,':','.'))>24 THEN
 RES:=ATTEN_FUNC('24:00',RES);
 ELSE
 RES:=RES;
 END IF;
RETURN RES;
EXCEPTION
     WHEN OTHERS THEN
     NULL;
END;
/


GRANT EXECUTE, DEBUG ON PMIS_OPL.CAL_YM TO DSS_OPL;

GRANT EXECUTE ON PMIS_OPL.CAL_YM TO OPL;

GRANT EXECUTE, DEBUG ON PMIS_OPL.CAL_YM TO TDMS_OPL;

GRANT EXECUTE ON PMIS_OPL.CAL_YMD TO TDMS_OPL;
