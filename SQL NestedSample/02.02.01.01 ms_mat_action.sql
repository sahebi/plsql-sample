create or replace view ms_mat_action as
Select a.year,
       b.goods,
       Nvl(d.trust_id, -1) trust_id,
       nvl(Sum(Decode( nvl(b.In_amount, 0), 0, b.bl_amount, b.in_amount) * Decode(e.MAT_DELIVERY_EXIT_STATUS, null, 1, 0)), 0) Balance,
       nvl(Sum(Decode( nvl(b.In_amount, 0), 0, b.bl_amount, b.in_amount) * Decode(e.MAT_DELIVERY_EXIT_STATUS, null, 0, 1)), 0) Balance_outsource,
       0 IMP_Balance
      From Mat_action a, Mat_action_items b, Mat_quality c, Mat_Ind_Items d, Mat_ind e
         Where a.Id = b.Parent_id
               And a.id = c.parent_id(+)
               And Nvl(c.type, 1) not in (3,4)
               And b.goods = d.goods
               And a.indent_id = d.parent_id
               And d.Parent_id = e.id
               And a.year >= 1391
         Group by a.year, b.goods, d.trust_id
Union All
Select year, goods, -5, 0, 0, Decode(Nvl(xxx.Amount, 0), 0, xxx.init_amount, xxx.Amount)
  from IMP_DEPO_RECEIVE xxx
;