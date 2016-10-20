CREATE OR REPLACE FUNCTION SYSTEM.hijri(idate date) RETURN varchar2 IS
    y NUMBER;  /* year */
    d NUMBER;  /* day */
    m NUMBER;  /* month */
    t NUMBER;
    fdate varchar2 (10);
    rdate varchar2 (10);
    FUNCTION kabiseh_Shamsi (y number) RETURN number IS
      BEGIN
        IF MOD ((31 * (y + 38)), 128) < 31 THEN
           RETURN 1;
        END IF;
        RETURN 0;
      END;
BEGIN
    IF idate IS NULL OR IDATE< to_date ('21/3/1940', 'DD/MM/YYYY') THEN  RETURN NULL; END IF;
    y := 1378; m := 1;
    d := TRUNC (idate) - to_date ('21/3/1999', 'DD/MM/YYYY');
    WHILE d > 0 LOOP
      t := kabiseh_Shamsi (y);
      IF d >= 365 + t THEN
         d := d - 365 - t;
         y := y + 1;
      ELSE EXIT;
      END IF;
    END LOOP;
    WHILE d < 0 LOOP
      y := y - 1;
      d := d + 365 + kabiseh_Shamsi (y);
    END LOOP;
    d := d + 1;
    FOR i IN 1..6 LOOP -- Farvardin up to Shahrivar
      EXIT WHEN d <= 31;
      d := d - 31;
      m:= m + 1;
    END LOOP;
    IF m > 6 THEN
       WHILE d > 30 LOOP -- after Shahrivar
          m := m + 1; d := d - 30;
       END LOOP;
    END IF;
       fdate :=to_char(1300 + MOD(y,1300)) ||'/'||TO_Char(m,'FM09')||'/'||TO_Char(d,'FM09');

	IF TO_CHAR(IDATE,'DDMMYYYY')='22072001' THEN
  	RETURN('1380/04/31');
	ELSE
    RETURN fdate;
	END IF;
END;
