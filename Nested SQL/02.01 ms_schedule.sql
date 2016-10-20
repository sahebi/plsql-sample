create or replace view ms_schedule as
Select year, goods, Sum(Schedule) Schedule, Sum(Schedule_OutSource) Schedule_OutSource, Sum(Sub_Schedule) Sub_Schedule, Sum(Schedule_Kol) Schedule_Kol, Sum(Sub_Schedule_Kol) Sub_Schedule_Kol, Sum(Schedule_OutSource_sub) Schedule_OutSource_sub, Sum(Schedule_pieces) Schedule_pieces
   from
       (
       Select SubStr(Start_dt, 1, 4) year,
              goods,
              Sum(amount) Schedule,
              0 Schedule_OutSource,
              0 Sub_Schedule,
              0 Schedule_Kol,
              0 Sub_Schedule_Kol,
              0 Schedule_OutSource_sub,
              0 Schedule_pieces
         From Mat_Schedule a
             Where 
                  (SubStr(Start_dt, 1, 4) - h_year =  0 And start_dt <= sahebi.h_date_ieg)--sahebi.h_date--sahebi.h_mrp_end_date
                   And Start_dt >= '1391/01/01'
               Group by SubStr(Start_dt, 1, 4), goods
       Union All
       Select SubStr(Start_dt, 1, 4) year,
              goods,
              Sum(amount) Schedule,
              0 Schedule_OutSource,
              0 Sub_Schedule,
              0 Schedule_Kol,
              0 Sub_Schedule_Kol,
              0 Schedule_OutSource_sub,
              0 Schedule_pieces
         From Mat_Schedule a
             Where --industry_dt <> 'NEW' And
                   --Start_dt >= sahebi.h_year_tamin||'/01/01'
                  (SubStr(Start_dt, 1, 4) - h_year <> 0)
                   And Start_dt >= '1391/01/01'
               Group by SubStr(Start_dt, 1, 4), goods
       Union All
       Select SubStr(Start_dt, 1, 4) year,
              goods,
              0 Schedule,
              0 Schedule_OutSource,
              0 Sub_Schedule,
              Sum(amount) Schedule_Kol,
              0 Sub_Schedule_Kol,
              0 Schedule_OutSource_sub,
              0 Schedule_pieces
         From Mat_Schedule a
           Where Start_dt >= '1391/01/01'
             --where --industry_dt <> 'NEW' And
               --    Start_dt >= sahebi.h_year_tamin||'/01/01'
                 --  And start_dt <= H_YEAR||'/12/30'
               Group by SubStr(Start_dt, 1, 4), goods
       Union All
       Select a.year,
              a.goods,
              0,
              a.Schedule_OutSource Amount,
              0,
              0,
              0,
              Schedule_OutSource_Sub Schedule_OutSource_sub,
              0 Schedule_pieces
         From ms_schedule_outsource a
           Where a.year >= 1391
           --Where goods = 106605
       Union All
       Select year,
              a.mat_ind_items_goods,
              0 Amount,
              0,
              0,
              0 Amount,
              0,
              0 Schedule_OutSource_sub,
              a.amount / (b.Amount + (b.Amount * b.drop_amount)) Schedule_pieces
        from pieces_request a, i_prod.material_equal b
           where --depo_dt like H_YEAR||'%' And
                 a.goods = b.equal
                 And Year >= 1391
                 And mat_ind_items_goods is not null
                 And OUTSOURCE_ID is null
                 --And id = 374341
      Union All
      Select year||'',
             Montaj_goods,
             0,
             0 Schedule_OutSource,
             min(amount),
             0,
             0,
             0 Schedule_OutSource_sub,
             0 Schedule_pieces
        From ms_sub_schedule
          --Where Montaj_goods = 106900
           Group by year, Montaj_goods
      Union All
      Select year||'',
             Montaj_goods,
             0,
             0 Schedule_OutSource,
             0,
             0,
             min(amount),
             0 Schedule_OutSource_sub,
             0 Schedule_pieces
        From (
              Select Year, Montaj_Goods, Min(Amount) as Amount
                From (
                      Select year, Montaj_goods, b.pp_goods, Nvl(Sum(a.Amount / b.amount),0) Amount
                        from u_temp_montaj_year B
                             LEFT JOIN Mat_Schedule a On b.pp_goods = a.goods
                                                         And b.year = SubStr(a.Start_dt, 1, 4)
                                                         And Start_dt >= '1391/01/01'
                          group by year, Montaj_goods, b.pp_goods
                     ) XXX
                  Group by Year, Montaj_Goods
             )
           Group by year, Montaj_goods
      )
  Group by year, goods
;
