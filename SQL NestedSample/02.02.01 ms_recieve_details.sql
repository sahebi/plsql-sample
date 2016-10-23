create or replace view ms_recieve_details as
Select year, GOODS, Sum(BALANCE) BALANCE, Sum(Balance_outsource) Balance_outsource, Sum(MONTAJI) MONTAJI, Sum(IMP_Balance) IMP_Balance
  From
          (
            Select year, GOODS,
                   BALANCE, Balance_outsource, IMP_Balance,
                   0 MONTAJI, 0 MONTAJI_OutSource
              From ms_mat_action
                --Where goods = 106605 and year = 1394
            Union All
            Select a.year, b.Goods,
                   0 BALANCE, 0 Balance_outsource, 0 IMP_Balance,
                   (a.Balance+a.IMP_Balance) * Decode(b.Code, 106605, 1, Decode(Sign(c.schedule+c.Schedule_OutSource), 1, 0, 1)) MONTAJI,
                   0 MONTAJI_OutSource
              From ms_mat_action a
                   LEFT OUTER JOIN MRP_Material b
                        ON a.TRUST_ID = b.TRUST_ID
                           And a.GOODS = b.Code
                   LEFT OUTER JOIN ms_Schedule c
                        ON a.GOODS = c.goods
                           And a.year = c.year
                Where b.Goods is not null --and year = 1394 and Balance_outsource = 0 and a.goods = 106605
              )
       Group By year, Goods
;
