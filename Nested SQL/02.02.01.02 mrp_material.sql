create or replace view mrp_material as
Select "TRUST_ID","CODE","GOODS","AMOUNT"
     From
           (
            Select b.Parent_id trust_id, a.goods code, b.Goods, b.amount From Trusts a, TRUST_ITEMS b Where A.id = b.parent_id And Active = 0
            Union All
            Select b.Parent_id, a.goods, b.Goods, b.amount      From Trusts a, TRUST_ITEM_DETAILS b Where A.id = b.parent_id And Active = 0
            Union All
            Select -1, Goods, Material_code, Amount From MRP_Material_Bom
           ) xxx;
