Create or replace view ms_week as
Select xxx.DT,
       Sum(change_week_flag) over (order by dt)+1 Week
  From (
        Select xxx.*,
               to_char(dtm, 'd'),
               Decode(to_char(Lag(dtm) over (order by dt), 'd'), 6, 1, 0) change_week_flag
          From (
                Select Hijri(Miladi(H_YEAR||'/01/01')+Level-1) dt,
                       Miladi(H_YEAR||'/01/01')+Level-1 dtm
                  From Dual
                    Connect By Level <= 365
               ) xxx
       ) xxx
;
