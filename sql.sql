CREATE OR REPLACE PACKAGE BODY Security IS
	--##########################################################################################
	function getCondition(vOwner IN varchar2, vObjects IN varchar2, vType varchar2) return varchar2 IS
	begin
		return('');
	end;

	function STATUS_CHECK(vOwner IN varchar2, vObjects IN varchar2, vType IN varchar2, where_condiction out varchar2) return Boolean IS
	Begin
	  vReturn := False;
	  return(true);
	End;

  function Select_Security(Owner varchar2, Object varchar2) return varchar2 is
  begin
  	return(null);
  end;

  function Insert_Security(Owner varchar2, Object varchar2) return varchar2 is
  begin
  	return(null);
  end;

  function Update_Security(Owner varchar2, Object varchar2) return varchar2 is
  begin
  	return(null);
  end;

  function Delete_Security(Owner varchar2, Object varchar2) return varchar2 is
  begin
  	return(null);
  end;

  function Column_Security(Owner varchar2, Object varchar2) return varchar2 is
  begin
  	return(null);
  end;
END;
