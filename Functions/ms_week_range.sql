Create or replace view ms_week_range as
Select week, Min(dt) start_week, Max(dt) end_week
  from ms_week
    Group by week