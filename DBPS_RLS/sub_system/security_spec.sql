CREATE OR REPLACE PACKAGE Security IS
	function getCondition(vOwner IN varchar2, vObjects IN varchar2, vType varchar2) return varchar2;
	--Table VPD
	function STATUS_CHECK(vOwner in varchar2, vObjects in varchar2, vType in varchar2, where_condiction out varchar2) return Boolean;
  function Select_Security(Owner varchar2, Object varchar2) return varchar2;
  function Insert_Security(Owner varchar2, Object varchar2) return varchar2;
  function Update_Security(Owner varchar2, Object varchar2) return varchar2;
  function Delete_Security(Owner varchar2, Object varchar2) return varchar2;
	--Column VPD
  function Column_Security(Owner varchar2, Object varchar2) return varchar2;
END;
