create or replace view material_equal as
Select a.parent_id, b.equal, a.material_code, a.amount, a.drop_amount
  from MATERIAL_BOM A, Materials B
    Where part_no = 1
          And a.Material_Code = b.code
          And b.equal is not null;
