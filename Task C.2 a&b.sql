--FIT5195 Major Assignment
--Task C.2



--a) SQL statements (e.g. create table, insert into, etc) to create the star/snowflakeschema Version-1

--a.1 create Topic_Dim
DROP TABLE topic_dim_v1;

CREATE TABLE topic_dim_v1
    AS
        SELECT
            *
        FROM
            topic;
            
select * from topic_dim_v1;

--a.2 create Media_Dim_v1 
DROP TABLE media_dim_v1;

CREATE TABLE media_dim_v1
    AS
        SELECT
            *
        FROM
            media_channel;
select * from media_dim_v1;
    
--a.3 create Marital_Dim_v1
DROP TABLE marital_dim_v1;

SELECT
    *
FROM
    person2;

CREATE TABLE marital_dim_v1
    AS
        SELECT DISTINCT
            person_marital_status AS marital
        FROM
            person2;

SELECT
    *
FROM
    marital_dim_v1;

--a.4 create Location_Dim_v1
DROP TABLE location_dim_v1;

CREATE TABLE location_dim_v1
    AS
        SELECT DISTINCT
            address_state AS state
        FROM
            address;

SELECT
    *
FROM
    location_dim_v1;

--a.5 create Age_Group_Dim_v1
DROP TABLE age_group_dim_v1;

CREATE TABLE age_group_dim_v1 (
    age_group_id    NUMBER(1),
    age_group_name  VARCHAR2(25),
    age_group_desc  VARCHAR2(30)
);

INSERT INTO age_group_dim_v1 VALUES (
    1,
    'Child',
    '0-16 years old'
);

INSERT INTO age_group_dim_v1 VALUES (
    2,
    'Young adults',
    '17-30 years old'
);

INSERT INTO age_group_dim_v1 VALUES (
    3,
    'Middle-aged adults',
    '31-45 years old'
);

INSERT INTO age_group_dim_v1 VALUES (
    4,
    'Old-aged adults',
    'Over 45 years old'
);

SELECT
    *
FROM
    age_group_dim_v1;

--a.6 create Occupation_Dim_v1
DROP TABLE occupation_dim_v1;

CREATE TABLE occupation_dim_v1 (
    occupation_id    NUMBER(1),
    occupation_desc  VARCHAR2(30)
);

INSERT INTO occupation_dim_v1 VALUES (
    1,
    'Student'
);

INSERT INTO occupation_dim_v1 VALUES (
    2,
    'Staff'
);

INSERT INTO occupation_dim_v1 VALUES (
    3,
    'Community'
);

SELECT
    *
FROM
    occupation_dim_v1;


--a.7 create Program_Length_Dim_v1
DROP TABLE program_length_dim_v1;

CREATE TABLE program_length_dim_v1 (
    program_type_id    NUMBER(1),
    program_type_name  VARCHAR2(20),
    program_type_desc  VARCHAR2(30)
);

INSERT INTO program_length_dim_v1 VALUES (
    1,
    'short',
    'event < three sessions'
);

INSERT INTO program_length_dim_v1 VALUES (
    2,
    'medium',
    'between three to six sessions'
);

INSERT INTO program_length_dim_v1 VALUES (
    3,
    'long',
    'event > six sessions'
);

SELECT
    *
FROM
    program_length_dim_v1;

--a.8 create Event_Size_Dim_v1
DROP TABLE event_size_dim_v1;

CREATE TABLE event_size_dim_v1 (
    event_size_id    NUMBER(1),
    event_size_name  VARCHAR2(20),
    event_size_desc  VARCHAR2(30)
);

INSERT INTO event_size_dim_v1 VALUES (
    1,
    'small',
    'event <= 10 people'
);

INSERT INTO event_size_dim_v1 VALUES (
    2,
    'medium',
    'event between 11 and 30 people'
);

INSERT INTO event_size_dim_v1 VALUES (
    3,
    'large',
    'event > 30 people'
);

SELECT
    *
FROM
    event_size_dim_v1;

--a.9 create Program_Dim_v1
CREATE TABLE program_dim_v1
    AS
        SELECT
            program_id,
            program_name,
            program_details,
            program_fee,
            program_length
        FROM
            program
        ORDER BY
            program_id;

-- add the attribute 'Length_type_id'    
ALTER TABLE program_dim_v1 ADD (
    length_type_id NUMBER(1)
);

-- update data for Length_type_id
UPDATE program_dim_v1
SET
    length_type_id = 1
WHERE
    program_length IN ( '1 session', '2 sessions' );

UPDATE program_dim_v1
SET
    length_type_id = 2
WHERE
    program_length IN ( '3 sessions', '4 sessions', '5 sessions', '6 sessions' );

UPDATE program_dim_v1
SET
    length_type_id = 3
WHERE
    length_type_id IS NULL;

SELECT
    *
FROM
    program_dim_v1;

--a.10 create Event_Dim_v1

CREATE TABLE event_dim_v1
    AS
        SELECT
            event_id,
            event_start_date,
            event_end_date,
            event_size,
            event_location,
            event_cost,
            program_id
        FROM
            event
        ORDER BY
            event_id;

--add the attibute event_size_id
ALTER TABLE event_dim_v1 ADD (
    event_size_id NUMBER(1)
);

--update data for event_size_id, 1 = 'less than 10', 2 = 'between 11 and 30 people,', 3 = 'more than 30 people'
UPDATE event_dim_v1
SET
    event_size_id = 1
WHERE
    event_size <= 10;

UPDATE event_dim_v1
SET
    event_size_id = 3
WHERE
    event_size > 30;

UPDATE event_dim_v1
SET
    event_size_id = 2
WHERE
    event_size_id IS NULL;

SELECT
    *
FROM
    event_dim_v1;

--a.11 create Time_Dim_v1
CREATE TABLE time_temp_dim_v1
    AS
        ( SELECT
            subscription_date AS t
        FROM
            subscription2
        )
        UNION
        ( SELECT
            att_date AS t
        FROM
            attendance2
        )
        UNION
        ( SELECT
            reg_date AS t
        FROM
            registration2
        );

--create the final time_dim, remove the repeat value
CREATE TABLE time_dim_v1
    AS
        SELECT DISTINCT
            to_char(t, 'mmyyyy')      AS time_id,
            to_char(t, 'yyyy')        AS year,
            to_char(t, 'mm')          AS month
        FROM
            time_temp_dim_v1;

SELECT
    *
FROM
    time_dim_v1;

--a.12 create Demographic_dim_v1
DROP TABLE demographic_dim_v1;
DROP TABLE demographic_temp_dim_v1;

--create demographic_temp table
CREATE TABLE demographic_temp_dim_v1
    AS
        SELECT
            *
        FROM
            age_group_dim_v1,
            marital_dim_v1,
            occupation_dim_v1,
            location_dim_v1;

--add new column of  Demographic_ID
ALTER TABLE demographic_temp_dim_v1 ADD (
    demographic_id NUMBER(3)
);
--set the Demographic_ID value
UPDATE demographic_temp_dim_v1
SET
    demographic_id = ROWNUM;

--create final Demographic_dim_v1 table

CREATE TABLE demographic_dim_v1
    AS
        SELECT
            demographic_id,
            age_group_name,
            marital,
            occupation_desc,
            state
        FROM
            demographic_temp_dim_v1;

SELECT
    *
FROM
    demographic_dim_v1;

--a.13 create Interest_fact_v1

DROP TABLE temp_interest;
-- create temp_Interest table
CREATE TABLE temp_interest
    AS
        SELECT
            p.person_id,
            p.person_age,
            p.person_job,
            p.person_marital_status,
            a.address_state,
            s.topic_id
        FROM
            person2          p,
            address          a,
            person_interest  s
        WHERE
                p.person_id = s.person_id
            AND a.address_id = p.address_id;

-- add age_group and occupation columns
ALTER TABLE temp_interest ADD (
    demographic_id  NUMBER(3),
    age_group       VARCHAR2(20),
    occupation      VARCHAR2(20)
);

-- update the data of new columns
UPDATE temp_interest
SET
    age_group = 'Child'
WHERE
    person_age <= 16;

UPDATE temp_interest
SET
    age_group = 'Old-aged adults'
WHERE
    person_age > 45;

UPDATE temp_interest
SET
    age_group = 'Middle-aged adults'
WHERE
    age_group IS NULL;

UPDATE temp_interest
SET
    occupation = 'Student'
WHERE
    person_job = 'Student';

UPDATE temp_interest
SET
    occupation = 'Staff'
WHERE
    person_job = 'Staff';

UPDATE temp_interest
SET
    occupation = 'Community'
WHERE
    occupation IS NULL;

--updata the Demo id
UPDATE temp_interest t
SET
    t.demographic_id = (
        SELECT
            d.demographic_id
        FROM
            demographic_dim_v1 d
        WHERE
                t.age_group = d.age_group_name
            AND t.occupation = d.occupation_desc
            AND t.address_state = d.state
            AND t.person_marital_status = d.marital
    );

SELECT
    *
FROM
    temp_interest;

-- create final interest_fact table
drop table interest_fact_v1;
CREATE TABLE interest_fact_v1
    AS
        SELECT
            topic_id,
            demographic_id,
            COUNT(person_id) AS numofpeopleinterest
        FROM
            temp_interest
        GROUP BY
            topic_id,
            demographic_id;

SELECT
    *
FROM
    interest_fact_v1;

--a.14 create Regis_Fact_v1

-- create Regis_temp table
DROP TABLE regis_temp;

CREATE TABLE regis_temp
    AS
        SELECT
            p.person_id,
            p.person_age,
            p.person_job,
            p.person_marital_status,
            a.address_state,
            m.media_id,
            s.reg_id,
            s.reg_date
        FROM
            person2        p,
            address        a,
            registration2  s,
            media_channel  m
        WHERE
                p.person_id = s.person_id
            AND a.address_id = p.address_id
            AND s.media_id = m.media_id;

-- add columns
ALTER TABLE regis_temp ADD (
    demographic_id  NUMBER(3),
    age_group       VARCHAR2(20),
    occupation      VARCHAR2(20),
    time_id         VARCHAR2(20)
);

-- update the data of new columns
UPDATE regis_temp
SET
    age_group = 'Child'
WHERE
    person_age <= 16;

UPDATE regis_temp
SET
    age_group = 'Old-aged adults'
WHERE
    person_age > 45;

UPDATE regis_temp
SET
    age_group = 'Middle-aged adults'
WHERE
    age_group IS NULL;

UPDATE regis_temp
SET
    occupation = 'Student'
WHERE
    person_job = 'Student';

UPDATE regis_temp
SET
    occupation = 'Staff'
WHERE
    person_job = 'Staff';

UPDATE regis_temp
SET
    occupation = 'Community'
WHERE
    occupation IS NULL;

--updata time_id
UPDATE regis_temp
SET
    time_id = to_char(reg_date, 'mmyyyy');

--updata the Demo id
UPDATE regis_temp t
SET
    t.demographic_id = (
        SELECT
            d.demographic_id
        FROM
            demographic_dim_v1 d
        WHERE
                t.age_group = d.age_group_name
            AND t.occupation = d.occupation_desc
            AND t.address_state = d.state
            AND t.person_marital_status = d.marital
    );


-- create final Regis_fact table
DROP TABLE regis_fact_v1;

CREATE TABLE regis_fact_v1
    AS
        SELECT
            media_id,
            demographic_id,
            time_id,
            COUNT(person_id) AS numofpeopleregistered
        FROM
            regis_temp
        GROUP BY
            media_id,
            demographic_id,
            time_id;

SELECT
    *
FROM
    regis_temp;

SELECT
    *
FROM
    regis_fact_v1;

--a.15 create Subscri_Fact_v1
DROP TABLE subscri_temp;

CREATE TABLE subscri_temp
    AS
        SELECT
            p.person_id,
            p.person_age,
            p.person_job,
            p.person_marital_status,
            a.address_state,
            m.program_id,
            s.subscription_id,
            s.subscription_date
        FROM
            person2        p,
            address        a,
            subscription2  s,
            program        m
        WHERE
                p.person_id = s.person_id
            AND a.address_id = p.address_id
            AND s.program_id = m.program_id;

SELECT
    *
FROM
    subscri_temp;

-- add columns
ALTER TABLE subscri_temp ADD (
    demographic_id  NUMBER(3),
    age_group       VARCHAR2(20),
    occupation      VARCHAR2(20),
    time_id         VARCHAR2(20)
);

-- update the data of new columns
UPDATE subscri_temp
SET
    age_group = 'Child'
WHERE
    person_age <= 16;

UPDATE subscri_temp
SET
    age_group = 'Old-aged adults'
WHERE
    person_age > 45;

UPDATE subscri_temp
SET
    age_group = 'Middle-aged adults'
WHERE
    age_group IS NULL;

UPDATE subscri_temp
SET
    occupation = 'Student'
WHERE
    person_job = 'Student';

UPDATE subscri_temp
SET
    occupation = 'Staff'
WHERE
    person_job = 'Staff';

UPDATE subscri_temp
SET
    occupation = 'Community'
WHERE
    occupation IS NULL;

--updata time_id
UPDATE subscri_temp
SET
    time_id = to_char(subscription_date, 'mmyyyy');

--updata the Demo id
UPDATE subscri_temp t
SET
    t.demographic_id = (
        SELECT
            d.demographic_id
        FROM
            demographic_dim_v1 d
        WHERE
                t.age_group = d.age_group_name
            AND t.occupation = d.occupation_desc
            AND t.address_state = d.state
            AND t.person_marital_status = d.marital
    );


-- create final Subscri_fact table
DROP TABLE subscri_fact_v1;

CREATE TABLE subscri_fact_v1
    AS
        SELECT
            program_id,
            demographic_id,
            time_id,
            COUNT(person_id) AS numofpeoplesubscribed
        FROM
            subscri_temp
        GROUP BY
            program_id,
            demographic_id,
            time_id;


SELECT
    *
FROM
    subscri_fact_v1;


--a.16 create Attend_Fact_v1
DROP TABLE attend_temp;
--create attend_temp table
CREATE TABLE attend_temp
    AS
        SELECT
            p.person_id,
            p.person_age,
            p.person_job,
            p.person_marital_status,
            a.address_state,
            e.event_id,
            s.att_id,
            s.att_date,
            s.att_donation_amount
        FROM
            person2      p,
            address      a,
            attendance2  s,
            event        e
        WHERE
                p.person_id = s.person_id
            AND a.address_id = p.address_id
            AND s.event_id = e.event_id;

SELECT
    *
FROM
    attend_temp;

-- add columns
ALTER TABLE attend_temp ADD (
    demographic_id  NUMBER(3),
    age_group       VARCHAR2(20),
    occupation      VARCHAR2(20),
    time_id         VARCHAR2(20)
);

-- update the data of new columns
UPDATE attend_temp
SET
    age_group = 'Child'
WHERE
    person_age <= 16;

UPDATE attend_temp
SET
    age_group = 'Old-aged adults'
WHERE
    person_age > 45;

UPDATE attend_temp
SET
    age_group = 'Middle-aged adults'
WHERE
    age_group IS NULL;

UPDATE attend_temp
SET
    occupation = 'Student'
WHERE
    person_job = 'Student';

UPDATE attend_temp
SET
    occupation = 'Staff'
WHERE
    person_job = 'Staff';

UPDATE attend_temp
SET
    occupation = 'Community'
WHERE
    occupation IS NULL;

--updata time_id
UPDATE attend_temp
SET
    time_id = to_char(att_date, 'mmyyyy');

--updata the Demo id
UPDATE attend_temp t
SET
    t.demographic_id = (
        SELECT
            d.demographic_id
        FROM
            demographic_dim_v1 d
        WHERE
                t.age_group = d.age_group_name
            AND t.occupation = d.occupation_desc
            AND t.address_state = d.state
            AND t.person_marital_status = d.marital
    );


-- create final Attend_fact table
DROP TABLE attend_fact_v1;

CREATE TABLE attend_fact_v1
    AS
        SELECT
            event_id,
            demographic_id,
            time_id,
            COUNT(person_id) AS numofpeopleattended
        FROM
            attend_temp
        GROUP BY
            event_id,
            demographic_id,
            time_id;

SELECT
    *
FROM
    attend_fact_v1;

--b) SQL statements (e.g. create table, insert into, etc) to create the star/snowflakeschema Version-2
--b.1 Time_Dim_Level0
--create temporal time_dim,collect all time id
drop table Time_Temp_Dim_v2;
create table 
    Time_Temp_Dim_v2 as
  (select 
        SUBSCRIPTION_DATE as T 
    from 
        subscription2 )
  union
  (select 
        ATT_DATE as T 
    from 
        attendance2 )
  union
  (select 
        REG_DATE as T 
    from 
        registration2 );

--create the final time_dim, remove the repeat value
drop table time_dim_v2;
create table 
    Time_Dim_v2 as
Select 
    distinct to_char(T, 'ddmmyyyy') as Time_ID,
	to_char(T, 'yyyy') as year,
	to_char(T, 'mm') as Month,
	to_char(T, 'dd') as Day
from
	Time_Temp_Dim_v2;

--b.2 Program_Dim_v2
-- create the basic program_dim
drop table Program_Dim_v2;
create table 
    Program_Dim_v2 as
select
    program_id,
    program_name,
    program_details,
    program_fee,
    program_length
from
    program
order by
    program_id;

-- add the attribute 'Length_type_id'    
alter table 
    Program_Dim_v2 
add 
    (Length_Type_ID number(1));

-- update data for Length_type_id, 1 = less than three sessions, 2 = between three to six sessions, 3 = (more than six sessions)
UPDATE 
    Program_Dim_v2
set 
    Length_Type_ID = 1
where
    program_length in ('1 session', '2 sessions');
    
UPDATE 
    Program_Dim_v2
set 
    Length_Type_ID = 2
where
    program_length in ('3 sessions', '4 sessions', '5 sessions', '6 sessions');  
    
UPDATE 
    Program_Dim_v2
set 
    Length_Type_ID = 3
where
    Length_Type_ID is null;

--b.3 Event_Dim_v2
--create the basic event_dim
drop table Event_Dim_v2;
create table 
    Event_Dim_v2 as
select
    event_id,
    event_start_date,
    event_end_date,
    event_size,
    event_location,
    event_cost,
    program_id
from
    event
order by
    event_id;

--add the attibute event_size_id
alter table 
    Event_Dim_v2 
add 
    (Event_Size_ID number(1));

--update data for event_size_id, 1 = 'less than 10', 2 = 'between 11 and 30 people,', 3 = 'more than 30 people'
UPDATE 
    Event_Dim_v2
set 
    Event_Size_ID = 1
where
    event_size < 10;
    
UPDATE 
    Event_Dim_v2
set 
    Event_Size_ID = 3
where
    event_size > 30;
    
UPDATE 
    Event_Dim_v2
set 
    Event_Size_ID = 2
where
    Event_Size_ID is null;

--b.4 Person_Dim_v2
--create the temporal person_dim
drop table Person_Temp_Dim_v2;
create table 
    Person_Temp_Dim_v2 as
select
    p.person_id,
    p.person_name, 
    p.person_age,
    p.person_phone,
    p.person_email,
    p.address_id,
    p.person_marital_status,
    p.person_job,
    p.person_gender,
    a.address_state as STATE
from
    person2 p join address a on p.address_id = a.address_id ;
    
-- add a numeric attribute 'age_group'
alter table 
    Person_Temp_Dim_v2 
add 
    (Age_Group number(1));

-- update data 'age_group' , 1 = '0-16 years old', 2 = '17-30 years old', 3 = 'Over 45 years old'. 4 = 'Over 45 years old'
UPDATE 
    Person_Temp_Dim_v2
set 
    Age_Group = 1
where
    person_age < 17;
    
UPDATE 
    Person_Temp_Dim_v2
set 
    Age_Group = 4
where
    person_age > 45;
    
UPDATE 
    Person_Temp_Dim_v2
set 
    Age_Group = 2
where
    person_age between 17 and 30;
    
UPDATE 
    Person_Temp_Dim_v2
set 
    Age_Group = 3
where
    person_age between 31 and 45;
    
-- add a numeric attribute 'Martital_Status'
alter table 
    Person_Temp_Dim_v2 
add 
    (Martital_Status number(1));

--update data martial status, 1 = not married, 2 = divorced, 3 = married
UPDATE 
    Person_Temp_Dim_v2
set 
    Martital_Status = 1
where
    person_marital_status = 'Not married';
    
UPDATE 
    Person_Temp_Dim_v2
set 
    Martital_Status = 2
where
    person_marital_status = 'Divorced';

UPDATE 
    Person_Temp_Dim_v2
set 
    Martital_Status = 3
where
    person_marital_status = 'Married';
    
-- add a numeric attribute 'occupation'
alter table 
    Person_Temp_Dim_v2 
add 
    (Occupation number(1));

--update data 'occupation', 1 = 'student', 2 = 'staff', 3 ='Community'
UPDATE 
    Person_Temp_Dim_v2
set 
    occupation = 1
where
    person_job = 'Student';
    
UPDATE 
    Person_Temp_Dim_v2
set 
    occupation = 2
where
    person_job = 'Staff';
    
UPDATE 
    Person_Temp_Dim_v2
set 
    occupation = 3
where
    occupation is null;

--create the final person_dim
create table 
    Person_Dim_v2 as
select
    person_id,
    person_name, 
    age_group,
    person_phone,
    person_email,
    state,
    Martital_Status,
    occupation,
    person_gender
from
    Person_Temp_Dim_v2
order by
    person_id;

--b.5 Interest_Fact_v2
drop table Interest_Fact_v2;
create table 
    Interest_Fact_v2 as
(select
    d.topic_id,
    p.person_id,
    count(p.person_id) as NumOfPeopleInterested
from
    person_interest i,
    topic_dim_v1 d,
    person_dim_v2 p
where
    i.topic_id = d.topic_id
    and i.person_id = p.person_id
group by
    d.topic_id,
    p.person_id); 
    
--b.6 Subscri_Fact_v2
--create the temporal subscri_dim
drop table Subscri_Temp_Fact_v2;
create table 
    Subscri_Temp_Fact_v2 as
select
    p.person_id,
    g.program_id,
    s.subscription_date,
    count(p.person_id) as NumOfPeopleSubscribed
from
    person_dim_v2 p,
    program_dim_v2 g,
    subscription2 s
where
    p.person_id = s.person_id
    and s.program_id = g.program_id
group by
    p.person_id,
    g.program_id,
    s.subscription_date;
 
-- add string attibute time_id    
alter table 
    Subscri_Temp_Fact_v2
add 
    (Time_ID varchar2(50));

--update time_id through subscription_date
update 
    Subscri_Temp_Fact_v2
set
    Time_ID =  to_char(subscription_date, 'ddmmyyyy');

--create final subscri_fact
drop table Subscri_Fact_v2;
create table 
    Subscri_Fact_v2 as
select
    Time_ID,
    program_id,
    person_id,
    NumOfPeopleSubscribed
from
    Subscri_Temp_Fact_v2
order by
    Time_ID,
    program_id,
    person_id;


--b.7 Attend_Fact_v2
--create a temporal attend_dim
drop table Attend_Temp_Fact_v2;
create table 
    Attend_Temp_Fact_v2 as
select
    e.event_id,
    p.person_id,
    a.att_date,
    sum(a.att_donation_amount) as Total_donation,
    count(p.person_id) as NumOfPeopleAttended
from
    event_dim_v2 e,
    attendance2 a,
    person_dim_v2 p
where
    e.event_id = a.event_id
    and a.person_id = p.person_id
group by
    e.event_id,
    p.person_id,
    a.att_date;

--add string attribute time_id    
alter table 
    Attend_Temp_Fact_v2
add 
    (Time_ID  varchar2(50));

--update time_id through att_date
update 
    Attend_Temp_Fact_v2
set
    Time_ID = to_char(att_date,'ddmmyyyy');

--create the final attend_fact   
drop table Attend_Fact_v2;
create table 
    Attend_Fact_v2 as
select
    event_id,
    person_id,
    time_id,
    Total_donation,
    NumOfPeopleAttended
from
    attend_temp_fact_v2
order by
    event_id,
    person_id,
    time_id;


--b.8 Regis_Fact_v2
--create the temporal regis_fact
drop table Regis_Temp_Fact_v2;
create table 
    Regis_Temp_Fact_v2 as
(select
    p.person_id,
    e.event_id,
    m.media_id,
    r.reg_date,
    count(p.person_id) as NumOfPeopleRegistered
from
    person_dim_v2 p,
    media_dim_v1 m,
    event_dim_v2 e,
    registration2 r
where
    p.person_id = r.person_id
    and m.media_id = r.media_id
    and e.event_id = r.event_id
group by
    p.person_id,
    e.event_id,
    m.media_id,
    r.reg_date);

--add string attribute time_id    
alter table 
    Regis_Temp_Fact_v2
add 
    (time_id  varchar(50));

--update time_id through reg_date
update 
    Regis_Temp_Fact_v2
set
    time_id = to_char(reg_date, 'ddmmyyyy');

--create the final regis_dim
drop table Regis_Fact_v2;
create table 
    Regis_Fact_v2 as
select
    person_id,
    event_id,
    media_id,
    time_id,
    NumOfPeopleRegistered
from
    Regis_Temp_Fact_v2
order by
    person_id,
    event_id,
    media_id,
    time_id;
