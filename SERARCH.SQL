        DECLARE
            V_REC NUMBER;
        BEGIN
            GO_BLOCK('MIS_BRAND_NAT_SL_GR_GLB');
            FIRST_RECORD;
        FOR I IN 1..:NOF_REC1 LOOP
            IF UPPER(:MIS_BRAND_NAT_SL_GR_GLB.BRAND_NAME) LIKE UPPER(:SEARCH_BY)||'%' THEN
            V_REC := I ;
            GO_RECORD(V_REC);
            EXIT;
            ELSE
            NEXT_RECORD;
            END IF;
            END LOOP;
        IF V_REC<=0 OR V_REC IS NULL THEN
            MESSAGE('Seaching Complete, There no result to be displayed');
            MESSAGE('Seaching Complete, There no result to be displayed');
        FIRST_RECORD;
        END IF;
        EXCEPTION
        WHEN OTHERS THEN
            MESSAGE('Seaching Complete, There no result to be displayed');
            MESSAGE('Seaching Complete, There no result to be displayed');
        NULL;     
        END;
