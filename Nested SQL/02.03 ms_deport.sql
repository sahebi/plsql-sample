create or replace view ms_deport as
Select year, GOODS, Sum(BALANCE) BALANCE, Sum(MONTAJI) MONTAJI, Sum(ZirMajmoe) ZirMajmoe, Sum(Balamajmoe) Balamajmoe
  From (
        Select year, GOODS, BALANCE, MONTAJI, 0 ZirMajmoe, 0 Balamajmoe
           from ms_deport_details
        Union All
        Select a.year||'', a.Montaj_goods, 0, 0, Min(Nvl(b.balance,0) / a.Amount) ZirMajmoee, 0 Balamajmoe
          From u_temp_montaj_year a
            Left Join ms_deport_details b
                 ON a.pp_goods = b.goods And a.year = b.year
              Group by a.year, a.Montaj_goods
        Union All
        Select a.year, b.PP_GOODS, 0 BALANCE, 0 MONTAJI, 0 ZirMajmoe, a.BALANCE * b.Amount Balamajmoe
           from ms_deport_details a,
                u_temp_montaj b
             Where a.goods = b.montaj_goods
         )
    Group by year, Goods
;
