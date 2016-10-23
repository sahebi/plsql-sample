create or replace view ms_mrp_unique as
Select year,
       GOODS,
       Sum(SCHEDULE) SCHEDULE,
       Sum(Schedule_OutSource) Schedule_OutSource,
       Sum(Schedule_OutSource_sub) Schedule_OutSource_sub,
       Decode(Sum(SCHEDULE), 0, Sum(SUB_SCHEDULE), 0) SUB_SCHEDULE,
       Sum(Schedule_pieces) Schedule_pieces,

       Sum(SCHEDULE_KOL) SCHEDULE_KOL,
       Decode(Sum(SCHEDULE_KOL), 0, Sum(SUB_SCHEDULE_KOL), 0) SUB_SCHEDULE_KOL,

       Sum(Recieve_Balance) Recieve_Balance,
       Sum(Recieve_Montaji) Recieve_Montaji,
       Decode(Sum(SCHEDULE), 0, Sum(Recieve_ZirMajmoe), 0) Recieve_ZirMajmoe,
       Sum(Recive_OutSource) Recive_OutSource,
       Sum(Recieve_BalaMajmoe) Recieve_BalaMajmoe,
       Sum(IMP_Balance) Recieve_IMP,

       Sum(Deport_Balance) Deport_Balance,
       Sum(Deport_Montaji) Deport_Montaji,
       Decode(Sum(SCHEDULE), 0, Sum(Deport_Zirmajmoe), 0) Deport_Zirmajmoe,
       Sum(Deport_Balamajmoe) Deport_Balamajmoe,

       Sum(SCHEDULE)
       + Decode(Sum(SCHEDULE), 0, Sum(SUB_SCHEDULE), 0)
       + Decode(Sum(SCHEDULE)+Sum(SUB_SCHEDULE), 0, Sum(Schedule_pieces), 0)
       - (
                     Sum(Recieve_Balance)
                     + Sum(Recieve_Montaji)
                     + Decode(Sum(SCHEDULE), 0, Sum(Recieve_ZirMajmoe), 0)
                     + Sum(Recieve_BalaMajmoe)
                     + Sum(IMP_Balance)
         )
       + (
                Sum(Deport_Balance)
                + Decode(Sum(SCHEDULE), 0, Sum(Deport_Montaji), 0)
                + Decode(Sum(SCHEDULE), 0, Sum(Deport_Zirmajmoe), 0)
                --+ Sum(Deport_Balamajmoe)
         ) Schedule_Balance
   From (
          Select year, GOODS,
                 SCHEDULE, Schedule_OutSource, SUB_SCHEDULE,
                 0 Recieve_Balance, 0 Recieve_Montaji, 0 Recieve_ZirMajmoe, 0 Recive_OutSource, 0 Recieve_BalaMajmoe, 0 IMP_Balance,
                 0 Deport_Balance,  0 Deport_Montaji,  0 Deport_Zirmajmoe, 0 Deport_Balamajmoe,
                 SCHEDULE_KOL, SUB_SCHEDULE_KOL, Schedule_OutSource_sub, Schedule_pieces
               from ms_schedule Union All
          Select year, GOODS,
                 0,0,0,
                 BALANCE, MONTAJI, ZIRMAJMOE, Balance_outsource, BalaMajmoe, IMP_Balance,
                 0,0,0,0,
                 0,0, 0, 0
             From ms_recieve Union All
          Select year, GOODS,
                 0,0,0,
                 0,0,0, 0, 0, 0,
                 BALANCE, MONTAJI, ZIRMAJMOE, Balamajmoe,
                 0,0,0, 0
             from ms_deport
        )
    Group by year, GOODS
;
