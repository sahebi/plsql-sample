create or replace view ms_schedule_outsource as
Select year, goods, Sum(Amount) Schedule_OutSource, Sum(Sub_Amount) Schedule_OutSource_Sub
      From (
            Select year, outsource_id, mat_ind_items_goods goods, min(Amount_Pieces) Amount, 0 Sub_Amount
              from ms_outsource_schedule_details
                Group by year, outsource_id, mat_ind_items_goods
            Union All
            Select year, outsource_id, goods, 0, Sum(Amount) Amount
              from ms_outsource_schedule_details
                Group by year, outsource_id, goods
           )
        --Where --goods  = 108037 year = 1395
        Group by year, goods
;
