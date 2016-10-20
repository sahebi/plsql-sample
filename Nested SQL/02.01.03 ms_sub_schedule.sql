create or replace view ms_sub_schedule as
Select Year, Montaj_Goods, Min(Amount) as Amount
  From (
        Select year, Montaj_goods, b.pp_goods, Nvl(Sum(a.Amount / b.amount),0) Amount
          from u_temp_montaj_year B
               LEFT JOIN Mat_Schedule a On b.pp_goods = a.goods
                                           And SubStr(a.Start_dt, 1, 4) - h_year =  0
                                           And a.start_dt <= sahebi.h_date_ieg
                                           And b.year = SubStr(a.Start_dt, 1, 4)
                                           And Start_dt >= '1391/01/01'
            Where year - h_year = 0
            group by year, Montaj_goods, b.pp_goods
       ) XXX
    Group by Year, Montaj_Goods
Union All
Select Year, Montaj_Goods, Min(Amount)
  From (
        Select year, Montaj_goods, b.pp_goods, Nvl(Sum(a.Amount / b.amount),0) Amount
          from u_temp_montaj_year B
               LEFT JOIN Mat_Schedule a On b.pp_goods = a.goods
                                           And SubStr(a.Start_dt, 1, 4) - h_year <> 0
                                           And b.year = SubStr(a.Start_dt, 1, 4)
                                           And Start_dt >= '1391/01/01'
            Where year - h_year <> 0
            group by year, Montaj_goods, b.pp_goods
       ) XXX
    Group by Year, Montaj_Goods
;
