create or replace view ms_recieve as
Select year, GOODS, Sum(BALANCE) BALANCE, Sum(Balance_outsource) Balance_outsource, Sum(MONTAJI) MONTAJI, Sum(IMP_Balance) IMP_Balance, Sum(ZirMajmoe) ZirMajmoe, Sum(BalaMajmoe) BalaMajmoe
  From (
        Select year, GOODS,
               BALANCE, Balance_outsource, MONTAJI, IMP_Balance,
               0 ZirMajmoe, 0 BalaMajmoe
           from ms_recieve_details
        Union All
        Select b.year||'', b.Montaj_goods,
               0 BALANCE, 0 Balance_outsource, 0 MONTAJI, 0 IMP_Balance,
               Min(b.Amount) ZirMajmoee,
               0 BalaMajmoe
           from ms_sub_recieve_details b
                 Group by year, b.Montaj_goods
        /*
        Union All
        Select a.year, b.pp_goods,
               0 BALANCE, 0 Balance_outsource, 0 MONTAJI, 0 IMP_Balance,
               0 ZirMajmoee,
               (a.balance+a.IMP_Balance) * b.Amount BalaMajmoe
          from ms_recieve_details a,
               u_temp_montaj b
            Where a.goods = b.Montaj_goods
                  And (Year, a.goods) not in (Select SubStr(Start_dt, 1, 4), goods From Mat_Schedule a)
                  --And a.goods = 106605--105709
                  --and year = 1395
          */
       )
    Group by year, Goods
;
