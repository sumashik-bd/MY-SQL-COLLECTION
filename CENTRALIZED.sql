---------------------------------------------------- 2ND

PROCEDURE BE_CENTRALIZE (V_WINDOW  IN  VARCHAR2) 
IS
V_WIDTH  NUMBER(4);
V_HEIGHT NUMBER(4);
VW       NUMBER(4);
VH       NUMBER(4);
X        VARCHAR2(500);
BEGIN
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =    
     BEGIN    
          SELECT ''||'-'||'Logged As : '||EMP_OFFICE_NAME
                    INTO X
          FROM  PMIS_EMP_ALL_V
          WHERE EMP_CODE = :GLOBAL.USERID
          AND   JOB_CATEGORY NOT IN('4','5','7','10','11');
          EXCEPTION
      WHEN NO_DATA_FOUND THEN
     --- X := ''
     NULL;
     END;
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
SET_WINDOW_PROPERTY(FORMS_MDI_WINDOW,WINDOW_STATE,MAXIMIZE);
  VW        :=GET_APPLICATION_PROPERTY(DISPLAY_WIDTH)-20;
  VH        :=GET_APPLICATION_PROPERTY(DISPLAY_HEIGHT)-150;    
  V_WIDTH   := GET_WINDOW_PROPERTY(V_WINDOW, WIDTH);
  V_HEIGHT  := GET_WINDOW_PROPERTY(V_WINDOW, HEIGHT);
  SET_WINDOW_PROPERTY(V_WINDOW, POSITION, (VW-V_WIDTH)/2, (VH-V_HEIGHT)/2) ;
  SET_WINDOW_PROPERTY('WINDOW1',TITLE,X||', '||TO_CHAR(SYSDATE,'DD/MM/YYYY HH12:MI:SS PM'));
  EXCEPTION
     WHEN OTHERS THEN
     MESSAGE(SQLERRM(SQLCODE));
     MESSAGE(SQLERRM(SQLCODE));
END;

-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

BEGIN
---=================================
  BE_CENTRALIZE('WINDOW1');
--================================
  EXCEPTION
     WHEN OTHERS THEN
     MESSAGE(SQLERRM(SQLCODE));
     MESSAGE(SQLERRM(SQLCODE));
END;

---==== FOR DEPOT FORMS ================================================

PROCEDURE BE_CENTRALIZE (V_WINDOW  IN  VARCHAR2) 
IS
V_WIDTH  NUMBER(4);
V_HEIGHT NUMBER(4);
VW       NUMBER(4);
VH       NUMBER(4);
X        VARCHAR2(500);
BEGIN
    
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =    
     BEGIN    
                SELECT 'User - '||UPPER(LTRIM(RTRIM(ENAME)))||' ['||empno||']' 
                INTO X 
                FROM EMP
                WHERE EMPNO=:GLOBAL.USERID;
                EXCEPTION
     WHEN OTHERS THEN
     MESSAGE(SQLERRM(SQLCODE));
     MESSAGE(SQLERRM(SQLCODE));
     END;
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =
-- = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = = =

  SET_WINDOW_PROPERTY(FORMS_MDI_WINDOW,WINDOW_STATE,MAXIMIZE);
  VW        :=GET_APPLICATION_PROPERTY(DISPLAY_WIDTH)-20;
  VH        :=GET_APPLICATION_PROPERTY(DISPLAY_HEIGHT)-150;    
  V_WIDTH   := GET_WINDOW_PROPERTY(V_WINDOW, WIDTH);
  V_HEIGHT  := GET_WINDOW_PROPERTY(V_WINDOW, HEIGHT);
  SET_WINDOW_PROPERTY(V_WINDOW, POSITION, (VW-V_WIDTH)/2, (VH-V_HEIGHT)/2) ;
  SET_WINDOW_PROPERTY('WINDOW1',TITLE,X||', '||TO_CHAR(SYSDATE,'DD/MM/YYYY HH12:MI:SS PM'));
EXCEPTION
     WHEN OTHERS THEN
     MESSAGE(SQLERRM(SQLCODE));
     MESSAGE(SQLERRM(SQLCODE));
END;