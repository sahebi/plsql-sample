create or replace view ms_deport_action as
Select b.year,
       a.Goods,
       Nvl(d.trust_id, -1) trust_id,
       Sum(Nvl(a.Amount, 0)) Balance
          From Mat_Deport a,
               Mat_Action b,
               Mat_ind c,
               Mat_Ind_Items d
            Where a.parent_id = b.id
                  And b.year >= 1391
                  And a.Confirm_dt is not null
                  And a.Confirm_dt not Like 'RJCT'
                  And b.indent_id = c.id
                  And c.id = d.parent_id
                  and d.goods = a.goods
                  And c.Mat_Delivery_Exit_Status is null
                  --And b.year >= sahebi.h_year_tamin
                  --And nvl(a.depo_dt, sahebi.h_date) <= sahebi.h_date --check by seyed? y/n
              Group By b.year, a.Goods, d.trust_id
;
