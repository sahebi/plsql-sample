Begin
  for c in (Select * From All_Policies Where SEL='YES' /*INS='YES', UPD='YES', DEL='YES'*/) Loop
    DBMS_RLS.enable_policy(
      c.object_owner,
      c.object_name,
      c.policy_group,
      c.policy_name,
      false
    );
  end loop;
End;
/
