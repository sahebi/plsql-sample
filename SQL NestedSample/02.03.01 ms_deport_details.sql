create or replace view ms_deport_details as
Select year, GOODS, Sum(BALANCE) BALANCE, Sum(MONTAJI) MONTAJI
  From
       (
        Select year, GOODS, BALANCE, 0 MONTAJI From ms_deport_action
        Union All
        Select year, b.Goods, 0, Balance * Amount
          From ms_deport_action a, MRP_Material b
            Where a.TRUST_ID = b.TRUST_ID
                  And a.GOODS = b.Code
       )
   Group by year, GOODS
;
