
-----------FIND MATERIALIZED VIEW REFRESH DATE--------------------
-----------------------------------------------------------------------------------------------
SELECT MVIEW_NAME, REFRESH_MODE, REFRESH_METHOD,
            LAST_REFRESH_TYPE, LAST_REFRESH_DATE
       FROM USER_MVIEWS;

---------------------------COMPLETE MATERIALIZED VIEW REFRESH-----------------------


EXEC DBMS_MVIEW.REFRESH('SD_MPO_MVW','C',ATOMIC_REFRESH =>FALSE);


BEGIN
DBMS_SNAPSHOT.REFRESH('MENU_SETUP_PRIVS_NEW_MV');
END;