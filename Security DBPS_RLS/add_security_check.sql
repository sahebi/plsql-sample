
-- FGA
Select * from DBA_AUDIT_POLICIES;
DBMS_FGA.add_policy(
    object_schema   => :DBA_OBJECTS.OWNER,
    object_name     => :DBA_OBJECTS.OBJECT_NAME,
    policy_name     => P_NAME,
    audit_column    => :DBA_OBJECTS.AUDIT_COLUMN,
    audit_condition => NULL, -- Equivalent to TRUE
    statement_types => :DBA_OBJECTS.STATMENT_TYPE
);

-- FGA Enable and Disable
DBMS_FGA.DISABLE_POLICY(
    :DBA_AUDIT_POLICIES.object_schema, 
    :DBA_AUDIT_POLICIES.OBJECT_NAME,    
    :DBA_AUDIT_POLICIES.POLICY_NAME
);
DBMS_FGA.ENABLE_POLICY(
    :DBA_AUDIT_POLICIES.object_schema, 
    :DBA_AUDIT_POLICIES.OBJECT_NAME,    
    :DBA_AUDIT_POLICIES.POLICY_NAME
);

-- FGA Drop
DBMS_FGA.DROP_POLICY(
    :DBA_AUDIT_POLICIES.object_schema, 
    :DBA_AUDIT_POLICIES.OBJECT_NAME,    
    :DBA_AUDIT_POLICIES.POLICY_NAME
);

-- VPD, Row Level Security
Select * From ALL_POLICIES;

DBMS_RLS.add_policy(
    :DBA_OBJECTS.OWNER, :DBA_OBJECTS.OBJECT_NAME,
    P_NAME,
    'Security','Security.SELECT_Security',
    'UPDATE', TRue
);
DBMS_RLS.add_policy(
    :DBA_OBJECTS.OWNER, :DBA_OBJECTS.OBJECT_NAME,
    P_NAME,
    'Security','Security.UPDATE_Security',
    'UPDATE', TRue

DBMS_RLS.add_policy(
    :DBA_OBJECTS.OWNER, :DBA_OBJECTS.OBJECT_NAME,
    P_NAME,
    'Security','Security.INSERT_Security',
    'UPDATE', TRue
);
DBMS_RLS.add_policy(
    :DBA_OBJECTS.OWNER, :DBA_OBJECTS.OBJECT_NAME,
    P_NAME,
    'Security','Security.DELETE_Security',
    'UPDATE', TRue
);

DBMS_RLS.enable_grouped_policy(
    :ALL_POLICIES.OBJECT_OWNER,
	:ALL_POLICIES.OBJECT_NAME,
	:ALL_POLICIES.POLICY_GROUP,
	:ALL_POLICIES.POLICY_NAME,
	FALSE
);

DBMS_RLS.enable_grouped_policy(
    :ALL_POLICIES.OBJECT_OWNER,
    :ALL_POLICIES.OBJECT_NAME,
    :ALL_POLICIES.POLICY_GROUP,
    :ALL_POLICIES.POLICY_NAME,
    TRUE
);

DBMS_RLS.DROP_POLICY(
    :ALL_POLICIES.OBJECT_OWNER, 
   	:ALL_POLICIES.OBJECT_NAME,    
   	:ALL_POLICIES.POLICY_NAME
);

-- Column Masking
Select * from ALL_SEC_RELEVANT_COLS;

DBMS_RLS.ADD_POLICY (
    object_schema         => :DBA_OBJECTS.OWNER,
    object_name           => :DBA_TAB_COLUMNS.TABLE_NAME,
    policy_name           => P_NAME,
    function_schema       => 'SECURITY',
    policy_function       => 'security.Column_Security',
    sec_relevant_cols     => :DBA_TAB_COLUMNS.COLUMN_NAME,
    sec_relevant_cols_opt =>  DBMS_RLS.ALL_ROWS
);
