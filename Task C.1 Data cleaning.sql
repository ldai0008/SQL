--FIT5195 Major Assignment
--Task C.1 Data cleaning



--1 The null value in Topic
--1.1 Explore Code:
select * from topic;
--1.2 Modify Code:
delete from 
    topic 
where 
    topic_id = 'T010';

--2 The program has a total of 19 IDs. When program_id is used as FK in the Event 
--table, the value of ID PR020 appears, which is greater than the value of the main table.
--2.1 Explore Code:
select 
    distinct program_id 
from 
    event;
--2.2 Modify Code:
insert into program values ('PR020', 'fencing', 'Learn basic skills in heancing',0, '1 session', 'Twice a year', 'T005');

--3 The number of size in the event cannot be negative and needs to be processed.
--3.1 Explore Code:
select * from event;
--3.2 Modify Code:
update 
    event
set 
    event_size = 10
where 
    event_id = 11;

UPDATE 
    EVENT
SET 
    EVENT_SIZE = 75
WHERE 
    EVENT_ID = 47;

--4 The recorded start date of the event is later than the end date
--4.1 Explore Code:
select * 
from 
    event 
where 
    event_start_date > event_end_date;
--4.2 Modify Code:
update 
    event
set 
    event_start_date = '17/OCT/20'
where 
    event_id = 163;

--5 The empty value of media_channel needs to be processed
--5.1 Explore Code:
select * from media_channel;
--5.2 Modify Code:
delete from 
    media_channel 
where 
    media_cost = 0;
    
--6 Person has duplicate data
--6.1 Explore Code:
select 
    person_name, 
    count(person_name) 
from 
    person 
group by 
    person_name;
--6.2 Modify Code:
CREATE TABLE PERSON2 AS
select 
    DISTINCT * 
from 
    person;
    
--7 In Volunteer, start date is later than end date
--7.1 Explore Code:
select * 
from 
    volunteer 
where 
    vol_start_date > vol_end_date; 
--7.2 Modify Code:
update 
    volunteer
set 
    vol_end_date = '16/MAY/20'
where 
    person_id = 'PE110';
    
--8 Unreasonable ID appears in the Volunteer table: PE000
--8.1  Explore Code:
select * from volunteer order by person_id; 
--8.2 Modify Code:
delete from 
    volunteer
where 
    person_id = 'PE000'; 
    
--9 Record in Volunteer does not exist in person
--9.1 Explore Code:
SELECT * 
from 
    volunteer
where 
    person_id not in (select 
                        person_id 
                    from 
                        person2);
--9.2 Modify Code:
delete from 
    volunteer
where 
    person_id = 'PE110' 
    or person_id = 'PE000'; 
    
--10 There is no pk of ‘T010?in the table person_interest
--10.1 Explore Code:
SELECT * 
from 
    person_interest
where 
    topic_id not in (select 
                        topic_id 
                    from 
                        topic);
--10.2 Modify Code:
update 
    person_interest
set 
    topic_id = 'T001'
where
    person_id = 'PE035'
    OR person_id = 'PE051'; 

--11 Duplicate data in Subscription form
--11.1 Explore Code:
SELECT 
    subscription_id, 
    count(subscription_id) 
from 
    subscription
group by 
    subscription_id
having 
    count(subscription_id) > 2;
--11.2 Modify Code:
create table subscription2
as
select 
    distinct *
from
    Subscription;
    
--12 In Registration, the same person, the same event, and the same channel have registered multiple times
--12.1 Explore Code:
select
    event_id,
    person_id,
    media_id,
    count(*)
from
    registration
group by
    event_id,
    person_id,
    media_id
having
    count(*)>1;
--12.2 Modify Code:
create table registration2 as
(select
    REG_ID,
    REG_NUM_OF_PEOPLE_REGISTERED,
    REG_DATE,
    EVENT_ID,
    PERSON_ID,
    MEDIA_ID
from
    (select
        REG_ID,
        REG_NUM_OF_PEOPLE_REGISTERED,
        REG_DATE,
        EVENT_ID,
        PERSON_ID,
        MEDIA_ID,
        rank() over (partition by 
                        EVENT_ID, PERSON_ID
                    order by
                        reg_id desc) as Rank
    from 
        registration
    order by
        event_id, 
        person_id
    ) r
where
    r.rank = 1);
    
--13 There is a record of the same person attending the same event twice on the same date in Attendance
--13.1 Explore Code:
select
    event_id,
    person_id,
    att_date,
    count(*)
from
    attendance
group by
    event_id,
    person_id,
    att_date
having
    count(*)>1;
--13.2 
create table 
    attendance2 as
(select
    ATT_ID,
    ATT_DATE,
    ATT_DONATION_AMOUNT,
    ATT_NUM_OF_PEOPLE_ATTENDED,
    PERSON_ID,
    EVENT_ID
from
    (select
        ATT_ID,
        ATT_DATE,
        ATT_DONATION_AMOUNT,
        ATT_NUM_OF_PEOPLE_ATTENDED,
        PERSON_ID,
        EVENT_ID,
        rank() over (partition by 
                        EVENT_ID, PERSON_ID
                    order by
                        ATT_ID desc) as Rank
    from 
        attendance
    order by
        event_id, 
        person_id
    ) a
where
    a.rank = 1);

commit;












