DECLARE
    V_VALID VARCHAR2(15);
BEGIN
    V_VALID := :LOGON_BLK.EMAIL_ADDRESS ;
IF NOT V_VALID IN ('@','\','/','^','&','>','<','!') THEN
        MESSAGE('Enter E-mail without any SpecialCharacters');
        MESSAGE('Enter E-mail without any SpecialCharacters');
END IF; 
END;


if instr(:LOGON_BLK.EMAIL_ADDRESS,'@') <> 0 then
    message('Please, Enter email address without using "@"');
    message('Please, Enter email address without using "@"');
raise form_trigger_failure;
end if;
		