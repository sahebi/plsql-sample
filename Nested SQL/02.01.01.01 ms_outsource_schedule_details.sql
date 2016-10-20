create or replace view ms_outsource_schedule_details as
Select SubStr(depo_dt, 1, 4) year, a.outsource_id, a.mat_ind_items_goods, a.goods, Sum(a.amount) amount, b.amount zarib, Sum(a.amount)/b.amount amount_pieces
  from pieces_request a, material_bom b
   where a.mat_ind_items_goods = b.parent_id
         And a.goods = b.material_code
         And SubStr(a.depo_dt, 1, 1) = '1'
         and a.outsource_id is not null
         --And depo_dt like '1394%'
         --And a.outsource_id = 2984
     Group by SubStr(depo_dt, 1, 4), a.outsource_id, a.mat_ind_items_goods, a.goods, b.amount
;
