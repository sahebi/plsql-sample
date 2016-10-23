--1395/08/02 confused day, recursive select on sub_system
Begin
  for c in (Select * From All_Policies Where SEL='YES' /*INS='YES', UPD='YES', DEL='YES'*/) Loop
    DBMS_RLS.drop_policy(
      c.object_owner,
      c.object_name,
      c.policy_name
    );
  end loop;
End;
/
