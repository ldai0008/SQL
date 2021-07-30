--****PLEASE ENTER YOUR DETAILS BELOW****
--Q3-tds-mods.sql
--Student ID:30759277
--Student Name:LU DAI
--Tutorial No: Tutorial 9

/* Comments for your marker:




*/


/*
3(i) Changes to live database 1
*/
--PLEASE PLACE REQUIRED SQL STATEMENTS FOR THIS PART HERE
select f.officer_id,count(off_no)
from offence o join officer f on o.officer_id = f.officer_id
group by  f.officer_id
order by f.officer_id;

ALTER TABLE officer
ADD (officer_times NUMBER(3));
COMMENT ON COLUMN officer.officer_times IS
'Total times of police officer booked traffic offence';
commit;
update officer
set    officer_times = 1
where  officer_id = 10000002;
COMMIT;
update officer
set    officer_times = 1
where  officer_id = 10000003;
COMMIT;
update officer
set    officer_times = 1
where  officer_id = 10000004;
COMMIT;
update officer
set    officer_times = 1
where  officer_id = 10000005;
COMMIT;
update officer
set    officer_times = 1
where  officer_id = 10000006;
COMMIT;
update officer
set    officer_times = 1
where  officer_id = 10000007;
COMMIT;
update officer
set    officer_times = 1
where  officer_id = 10000008;
COMMIT;
update officer
set    officer_times = 1
where  officer_id = 10000009;
COMMIT;
update officer
set    officer_times = 1
where  officer_id = 10000010;
COMMIT;
update officer
set    officer_times = 4
where  officer_id = 10000011;
COMMIT;
update officer
set    officer_times = 1
where  officer_id = 10000012;
COMMIT;
update officer
set    officer_times = 1
where  officer_id = 10000013;
COMMIT;
update officer
set    officer_times = 1
where  officer_id = 10000014;
COMMIT;
update officer
set    officer_times = 3
where  officer_id = 10000015;
COMMIT;
update officer
set    officer_times = 1
where  officer_id = 10000016;
COMMIT;
update officer
set    officer_times = 1
where  officer_id = 10000017;
COMMIT;
update officer
set    officer_times = 1
where  officer_id = 10000018;
COMMIT;
update officer
set    officer_times = 1
where  officer_id = 10000019;
COMMIT;
update officer
set    officer_times = 1
where  officer_id = 10000020;
COMMIT;
update officer
set    officer_times = 1
where  officer_id = 10000021;
COMMIT;

select *
from officer;



/*
3(ii) Changes to live database 2
*/
--PLEASE PLACE REQUIRED SQL STATEMENTS FOR THIS PART HERE
DROP TABLE revoked cascade constraints PURGE;


CREATE TABLE revoked (
    rev_no         NUMBER(5) NOT NULL,
    rev_date       DATE NOT NULL,
    rev_fname      VARCHAR2(30),
    rev_lname      VARCHAR2(30),
    rev_reason     char(3) NOT NULL,
    rev_status     VARCHAR2(3) NOT NULL,
    off_no         NUMBER(8) NOT NULL
);

ALTER TABLE revoked
    ADD CHECK ( rev_reason IN (
        'FOS',
        'FEU',
        'DOU',
        'COH',
        'EIP'
    ) );

ALTER TABLE revoked
ADD  CHECK (rev_status in ('Yes','No'));

COMMENT ON COLUMN revoked.rev_no IS
    'revoked unique code';

COMMENT ON COLUMN revoked.rev_date IS
    'when revoked';

COMMENT ON COLUMN revoked.rev_fname IS
    'who revoked the offence first name';
    
COMMENT ON COLUMN revoked.rev_lname IS
    'who revoked the offence last name';
    
COMMENT ON COLUMN revoked.rev_reason IS
    'Revoked reason - can be FOS( First offence exceeding the speed limit by less than 10km/h
    ), FEU( Faulty equipment used ), DOU(Driver objection upheld ),COH( Court hearing ),
    EIP( Error in proceedings )';
    
COMMENT ON COLUMN revoked.rev_status IS
    'Revoked status can be Yes (offence has been revoked),No (offence has not been revoked)';
    
COMMENT ON COLUMN revoked.off_no IS
    'Offence number (unique)';

ALTER TABLE revoked ADD CONSTRAINT revoked_pk PRIMARY KEY ( rev_no );

ALTER TABLE revoked ADD CONSTRAINT rev_off_uk UNIQUE ( off_no );

ALTER TABLE revoked
    ADD CONSTRAINT revoked_offence FOREIGN KEY ( off_no )
        REFERENCES offence ( off_no );
commit;

ALTER TABLE revoked
MODIFY (rev_status VARCHAR2(3) DEFAULT 'No');

COMMIT;



/*
3(iii) Changes to live database 3
*/
--PLEASE PLACE REQUIRED SQL STATEMENTS FOR THIS PART HERE
select * 
from vehicle
where veh_manufname = 'Lamborghini';

DROP TABLE colour cascade constraints PURGE;
DROP SEQUENCE COLOUR_SEQ;

create SEQUENCE COLOUR_SEQ 
START WITH 1
INCREMENT BY 1;

CREATE TABLE colour (
    colour_no         NUMBER(2) DEFAULT colour_seq.nextval NOT NULL,
    colour_type       CHAR(2) NOT NULL,
    colour_des        VARCHAR2(20) NOT NULL,
    veh_vin           CHAR(17) NOT NULL
);

ALTER TABLE colour
    ADD CHECK ( colour_type IN (
        'SP',
        'BM',
        'GR'
           ) );



COMMENT ON COLUMN colour.colour_no IS
    'revoked unique code';

    
COMMENT ON COLUMN colour.colour_type IS
    'Colour type - can be SP( Spoiler ), BM( Bumper ), GR(Grilles )';
    
COMMENT ON COLUMN colour.colour_des IS
    'Colour description recorded';
    
COMMENT ON COLUMN colour.veh_vin IS
    'Vehicle identification number';

ALTER TABLE colour ADD CONSTRAINT colour_pk PRIMARY KEY ( colour_no );

ALTER TABLE colour
    ADD CONSTRAINT colour_vehicle FOREIGN KEY ( veh_vin )
        REFERENCES vehicle ( veh_vin );
commit;

INSERT INTO COLOUR VALUES (COLOUR_SEQ.nextval,'SP','Black','ZHWEF4ZF2LLA13803');
INSERT INTO COLOUR VALUES (COLOUR_SEQ.nextval,'BM','Grey','ZHWEF4ZF2LLA13803');
INSERT INTO COLOUR VALUES (COLOUR_SEQ.nextval,'GR','Magenta','ZHWEF4ZF2LLA13803');
COMMIT;

SELECT *
FROM COLOUR C JOIN VEHICLE V ON C.veh_vin = V.veh_vin
WHERE veh_manufname = 'Lamborghini' AND C.veh_vin = 'ZHWEF4ZF2LLA13803';

INSERT INTO COLOUR VALUES (COLOUR_SEQ.nextval,'SP','Yellow','ZHWES4ZF8KLA12259');
INSERT INTO COLOUR VALUES (COLOUR_SEQ.nextval,'BM','Blue','ZHWES4ZF8KLA12259');
INSERT INTO COLOUR VALUES (COLOUR_SEQ.nextval,'GR','Black','ZHWES4ZF8KLA12259');
COMMIT;

SELECT *
FROM COLOUR C JOIN VEHICLE V ON C.veh_vin = V.veh_vin
WHERE veh_manufname = 'Lamborghini' AND C.veh_vin = 'ZHWES4ZF8KLA12259';

































