CREATE OR REPLACE FUNCTION SYSTEM.miladi (paramdate char) RETURN date is
 TmpMonth12 number;
  yy number(4);
  mz number(2);
  dd number(2);
  kabis number;
  mm number;
  i number;
  ldays  number;
  dddd number;
  tt number;
  idate Date;
begin
  yy:=to_number(substr(ParamDate,1,4));
  mz:=to_number(substr(ParamDate,6,2));
  dd:=to_number(substr(ParamDate,9,2));
  if (yy/4)=trunc(yy/4) then
     kabis:=0;
     TmpMonth12:=30;
  else
     kabis:=1;
     TmpMonth12:=29;
  end if;
     if  mz<= 6 then
         mm := 31 * (mz-1) ;
     end if ;
      if  mz >= 7 and mz<=11 then
          mm := 30*(mz-7) + 31*6 ;
      end if;

IF MZ=12 THEN 
          mm :=  31*6 + 30*5 ;
END IF ;          
       yy:=yy-1;
  ldays:=(yy*365)+(trunc(yy/4))+mm+dd+1948310-kabis;
   idate:= to_date(ldays,'J');
   return idate;
end ;
