create or replace view i_prod.ms_mrp as
Select a.*,
       b.min min,
       b.max max,
       c.depo_bal + c.quality_amount depo_bal
  From (
      Select xxx.YEAR,
             xxx.GOODS,

             xxx.SCHEDULE,
             Decode(e.SCHEDULE_OUTSOURCE, 1, xxx.Schedule_OutSource, 0) Schedule_OutSource,
             xxx.Schedule_OutSource_sub,
             Decode(e.SCHEDULE_MONTAJI, 1, xxx.SUB_SCHEDULE, 0) SUB_SCHEDULE,
             SCHEDULE_KOL,
             Decode(e.SCHEDULE_MONTAJI, 1, xxx.SUB_SCHEDULE_KOL, 0) SUB_SCHEDULE_KOL,

             xxx.Schedule_pieces,

             xxx.RECIEVE_BALANCE,
             xxx.RECIEVE_MONTAJI,
             Decode(e.SCHEDULE_MONTAJI, 1, xxx.RECIEVE_ZIRMAJMOE, 0) RECIEVE_ZIRMAJMOE,
             Decode(e.SCHEDULE_OUTSOURCE, 1, xxx.Recive_OutSource, 0) Recive_OutSource,
             xxx.Recieve_IMP,
             xxx.Recieve_BalaMajmoe,

             xxx.DEPORT_BALANCE,
             xxx.DEPORT_MONTAJI,
             xxx.DEPORT_ZIRMAJMOE,
             xxx.SCHEDULE_BALANCE
        From (
              Select YEAR,GOODS,SCHEDULE,Schedule_OutSource,SUB_SCHEDULE,SCHEDULE_KOL,SUB_SCHEDULE_KOL,RECIEVE_BALANCE,RECIEVE_MONTAJI,RECIEVE_ZIRMAJMOE,Recive_OutSource,Recieve_IMP,Recieve_BalaMajmoe,DEPORT_BALANCE,DEPORT_MONTAJI,DEPORT_ZIRMAJMOE,SCHEDULE_BALANCE,Schedule_OutSource_sub,Schedule_pieces
                From ms_mrp_unique
                  Where Schedule_OutSource_sub+Schedule_OutSource+SCHEDULE_KOL+Schedule_pieces <> 0
             ) xxx,
            materials e
        Where xxx.GOODS = e.code
              And e.SCHEDULE_MAIN+e.SCHEDULE_OUTSOURCE+Schedule_pieces > 0
      ) a
     Left Join CURRENT_MIN_MAX b On a.goods = b.goods
     Left Join pieces_depo_bal c On a.goods = c.code and H_YEAR = a.year
;
