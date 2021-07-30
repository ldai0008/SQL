--****PLEASE ENTER YOUR DETAILS BELOW****
--Q1b-tds-dm.sql
--Student ID:30759277
--Student Name:LUDAI
--Tutorial No: Tutorial 9 

SET SERVEROUTPUT ON;


/* Comments for your marker:

Create a sequence which will allow entry of data into the OFFENCE table - the
sequence must begin at 100 and go up in steps of 1;

Add three details of Lion Lawless's offences;

Change the details of Lion Lawless's offences;


*/


/*
1b(i) Create a sequence 
*/
--PLEASE PLACE REQUIRED SQL STATEMENT(S) FOR THIS PART HERE


DROP SEQUENCE OFFENCE_SEQ;

create SEQUENCE OFFENCE_SEQ 
START WITH 100
INCREMENT BY 1;
commit;





/*
1b(ii) Take the necessary steps in the database to record data.
*/
--PLEASE PLACE REQUIRED SQL STATEMENT(S) FOR THIS PART HERE
INSERT INTO OFFENCE VALUES (OFFENCE_SEQ.nextval, TO_DATE('10-Aug-2019 08:04 AM','DD-MON-YYYY HH:MI PM'),'42793 Londonderry Road,Clayton South',100,10000011,'100389','JYA3HHE05RA070562');
commit;
INSERT INTO OFFENCE VALUES (OFFENCE_SEQ.nextval, TO_DATE('16-Oct-2019 9:00 PM','DD-MON-YYYY HH:MI PM'),'6361 Hoard Alley,Berwick',101,10000015,'100389','JYA3HHE05RA070562');
commit;
INSERT INTO OFFENCE VALUES (OFFENCE_SEQ.nextval, TO_DATE('7-Jan-2020 7:07 AM','DD-MON-YYYY HH:MI PM'),'6361 Hoard Alley,Berwick',99,10000015,'100389','JYA3HHE05RA070562');
INSERT INTO suspension VALUES('100389',TO_DATE('7-Jan-2020','DD-MON-YYYY'),TO_DATE(ADD_MONTHS('7-Jan-2020',6)));
commit;





/*
1b(iii) Take the necessary steps in the database to record changes. 
*/
--PLEASE PLACE REQUIRED SQL STATEMENT(S) FOR THIS PART HERE
update OFFENCE
set    dem_code = 106
where  off_no = 102;
COMMIT;

select * from OFFENCE;

select * from suspension;

delete suspension where lic_no = '100389';
COMMIT;
select * from suspension;






