create or replace view saturday as
Select "DT","LEV"
  from (Select hijri(sysdate-level+1) DT, to_char(sysdate-level+1, 'Day', 'nls_date_language=english') LEV
           From dual connect by level <= 7)
     Where lower(trim(Lev)) = trim(lower('saturday'));
