create or replace view ms_sub_recieve_details as
Select year, Montaj_goods, Min(Amount) as Amount
  From (
        Select a.year, a.pp_goods, a.Montaj_goods, Sum(Nvl(b.balance+b.IMP_Balance,0) / a.Amount) Amount
          from u_temp_montaj_year a
               LEFT JOIN ms_recieve_details b On a.pp_goods = b.goods
                                                 And a.year = b.year
            Group by a.year, a.pp_goods, a.Montaj_goods
       )
      --Where Montaj_goods = 106900
      --      And year = 1395
      Group by year, Montaj_goods
;
