CREATE OR REPLACE PACKAGE BODY Security IS
	--##########################################################################################
	function getCondition(vOwner IN varchar2, vObjects IN varchar2, vType varchar2) return varchar2 IS
		vTableCondition varchar2(2000);
		vAndOr					varchar2(2000);
	  vTMP						varchar2(2000);
	begin
		vAndOr := '';
		For CUR_G IN (Select condition, ANDOR From exception_condition Where Owner = vOwner and Table_Name = vObjects and Type=vType)  Loop
			if(CUR_G.condition is not null) then
				vTMP := CUR_G.condition;
			else
				vTMP := '1=1';
			end if;
			vTableCondition := vTableCondition || ' ' || vAndOr || ' ' || vTMP;
			vAndOr          := 'AND';
			if(CUR_G.ANDOR is not null) then
				vAndOr          := CUR_G.ANDOR;
			end if;
		end loop;
		return(vTableCondition);
	end;
	--@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	function STATUS_CHECK(vOwner IN varchar2, vObjects IN varchar2, vType IN varchar2, where_condiction out varchar2) return Boolean IS
  		module_name varchar2(48);
  		action_name varchar2(32);

	  	vUserName 	Varchar2(15);

	  	vReturn 	Boolean;
	  	vTMP		varchar2(2000);

		vColumnCondition	varchar2(2000);

		vTableCondition varchar2(2000);
		vAndOr				  varchar2(2000);

		vSession_id Number;
		vForm_id 	  Number;
	  
		vFromCondition Varchar2(3000);
		vCount Number;
	Begin
		vReturn := False;
		where_condiction := Null;
  		DBMS_application_info.read_module(module_name, action_name);
		if(vType in ('INSERT', 'UPDATE', 'DELETE')) Then
			  -- check module name is MIS 
			  if module_name in ('frmweb.exe', 'MIS', '...') Then
			  	  vReturn := True;
			  else	  		
			  		-- Code Exception User 2
			  		Select Max(User_Name) into vUserName
			  			From Exception_Users 
			  				Where User_Name = User and 
			  							Type = 2 and
			  							(
			  								Owner = 'ALL' OR
			  								(
			  								Owner = vOwner And
			  								Table_Name = vObjects
			  								)
			  							);

			  		if vUserName is not null Then
			  			vReturn := True;
			  		Else
						Insert Into Exception_Logs (Owner, Table_Name, USER_NAME, TYPES, LogTime, Terminal, MODULE) Values (vOwner, vObjects, USER, vType, sysdate, UserEnv('TERMINAL'), sys_context('USERENV','MODULE'));
				  		commit;
			  		end if;
			  end if;
			  where_condiction := Null;
		ElsIf(vType in ('SELECT')) Then
			vTableCondition := NULL;
			vFromCondition  := NULL;

			--- ####################################################
			--- Ezafe Shodan shart bar roye jadval
			--- ####################################################
			Select Max(User_Name) into vUserName
				From Exception_Users
					Where User_Name = User and
								Type = 4 And
								(
									Owner = 'ALL' OR
									(
									Owner = vOwner And
									Table_Name = vObjects
									)
								);
			if (vUserName is null) Then
				vTableCondition := getCondition(vOwner, vObjects, vType);
			end if;

			--- ####################################################
			--- Ezafe Shodan shart bar roye jadval bar asase sharte form
			--- ####################################################
			SELECT SYS_CONTEXT('USERENV','SID') into vSession_id FROM DUAL;
			Select min(form_id) into vForm_id
				From session_forms
					Where session_id = vSession_id;
			vForm_id := Nvl(vForm_id, 0);
						
			Select count(*) into vCount
				From Object_Form
					Where parent_id   = vForm_id And
								Owner       = vOwner And
								Object_Name = vObjects And
								Access_Level = '01';

			if(vCount > 0) Then
				Select condition into vFromCondition
					From Object_Form
						Where Parent_ID   = vForm_id And
									Owner       = vOwner 	 And
									Object_Name = vObjects And
								Access_Level = '01';
			end if;

			where_condiction := nvl(vTableCondition, ' 1 = 1 ') || ' And ' || nvl(vFromCondition, ' 1 = 1 ');
		ElsIf(vType in ('COLUMN')) Then
	  		Select Max(User_Name) into vUserName
	  			From Exception_Users 
	  				Where User_Name = User and 
	  							Type = 3 and
	  							(
	  								Owner = 'ALL' OR
	  								(
	  								Owner = vOwner And
	  								Table_Name = vObjects
	  								)
	  							);
	  		if vUserName is not null Then
				vReturn := True;
			ELSE
				vColumnCondition := getCondition(vOwner, vObjects, vType);
				where_condiction := nvl(vColumnCondition, ' 1 = 2 ');
	  		End if;
		End If;
	  return(vReturn);
	End;
	--##########################################################################################
  function Select_Security(Owner varchar2, Object varchar2) return varchar2 is
  	vReturn varchar2(1000);
  	module_name varchar2(48);
  	action_name varchar2(32);
  	where_str   varchar2(250);
  begin
  	--Check if USER is specified user show confirmed record
	if sys_context('USERENV', 'SESSION_USER')='XXX' THEN 
		if Object in ('MAT_ACTION', 'IMP_DEPO_RECEIVE', 'PRO_ACTION', 'SERVICE_ACTION', 'PME_ACTION', 'CON_ACTION') Then
			return 'FOB_DOC_NO is not null And Length(FOB_DOC_NO) <= 4';
		end if;
		return null;
	end if;

  	vReturn := NULL;
  	if(STATUS_CHECK(Owner, Object, 'SELECT', where_str) = TRUE) Then
  		vReturn := Null;
  	End if;
  	if(where_str is not null) Then
  		vReturn := where_str;
  	end if;

  	return(vReturn);
  end;
	--##########################################################################################
  function Insert_Security(Owner varchar2, Object varchar2) return varchar2 is
  	vReturn varchar2(1000);
  	where_str   varchar2(250);
  begin
 	vReturn := '1 = 2';
  	if(STATUS_CHECK(Owner, Object, 'INSERT', where_str) = TRUE) Then
  		vReturn := Null;
  	End if;
  	if(where_str is not null) Then
  		vReturn := where_str;
  	end if;
  	return(vReturn);
  end;
	--##########################################################################################
  function Update_Security(Owner varchar2, Object varchar2) return varchar2 is
  	vReturn varchar2(1000);
  	where_str   varchar2(250);
  begin
  	vReturn := '1 = 2';
  	if(STATUS_CHECK(Owner, Object, 'UPDATE', where_str) = TRUE) Then
  		vReturn := Null;
  	End if;
  	if(where_str is not null) Then
  		vReturn := where_str;
  	end if;
  	return(vReturn);
  end;
	--##########################################################################################
  function Delete_Security(Owner varchar2, Object varchar2) return varchar2 is
  	vReturn varchar2(1000);
  	where_str   varchar2(250);
  begin
  	vReturn := '1 = 2';
  	if(STATUS_CHECK(Owner, Object, 'DELETE', where_str) = TRUE) Then
  		vReturn := Null;
  	End if;
  	if(where_str is not null) Then
  		vReturn := where_str;
  	end if;
  	return(vReturn);
  end;
  --##########################################################################################
  function Column_Security(Owner varchar2, Object varchar2) return varchar2 is
  	vReturn 		varchar2(1000);
  	where_str   varchar2(1000);
  	vCheckiny		Boolean;
  	cnt 				Number;
  begin
  	vReturn := '1 = 2';
  	Select Count(*) into cnt From tmp_vpd_column_exception;
	if(cnt > 0) Then
			vReturn := Null;
	elsif(STATUS_CHECK(Owner, Object, 'COLUMN', where_str) = TRUE) Then
  		vReturn := Null;
	ELSE
	  	if(where_str is not null) Then
	  		vReturn := where_str;
	  	end if;
	End if;
  	return(vReturn);
  end;
  --##########################################################################################
END;