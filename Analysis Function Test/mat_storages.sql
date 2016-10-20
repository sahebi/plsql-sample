create or replace view mat_storages_calc as
Select x."ID",x."GOODS",x."TYPE",x."SOURCE_TYPE",x."SOURCE_ID",x."SOURCE_DT",x."AMOUNT",x."UNIT_PRICE",x."PRICE",x."DOC_NO",x."AVG_AMOUNT",x."AVG_UNIT_PRICE",x."AVG_AMOUNT_2",x."AVG_UNIT_PRICE_2",x."PRIOR_TYPE",x."PRIOR_AMOUNT",x."PRIOR_UNIT_PRICE"
  From (
        Select x.id, x.goods, x.type, x.Source_Type,
               x.Source_id, x.Source_dt,
               x.Amount, x.Unit_Price, x.Price,
               x.Doc_No, x.Avg_Amount, x.AVG_Unit_Price,
               Sum(Decode(Type,2, -1, 1)*Amount) over   (Partition By x.goods, SubStr(Source_dt, 1, 4) Order by Source_Dt, Type, Source_Type, id) Avg_Amount_2,
               (
                 (
                      Amount
                      *
                      Unit_Price
                 )
                 +
                 (
                      LAG(Amount)     over   (Partition By x.goods, SubStr(Source_dt, 1, 4) Order by Source_Dt, Type, Source_Type, id)
                      *
                      LAG(Unit_Price) over   (Partition By x.goods, SubStr(Source_dt, 1, 4) Order by Source_Dt, Type, Source_Type, id)
                 )
               )
               /
               (
                      Amount
                      +
                      LAG(Amount)     over   (Partition By x.goods, SubStr(Source_dt, 1, 4) Order by Source_Dt, Type, Source_Type, id)
               ) AVG_Unit_Price_2,
               LAG(Type)       over   (Partition By x.goods, SubStr(Source_dt, 1, 4) Order by Source_Dt, Type, Source_Type, id) PRIOR_TYPE,
               LAG(Amount)     over   (Partition By x.goods, SubStr(Source_dt, 1, 4) Order by Source_Dt, Type, Source_Type, id) PRIOR_Amount,
               LAG(Unit_Price) over   (Partition By x.goods, SubStr(Source_dt, 1, 4) Order by Source_Dt, Type, Source_Type, id) PRIOR_UNIT_PRICE
          From Mat_Storages x
        ) x
;