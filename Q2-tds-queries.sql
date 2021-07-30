--****PLEASE ENTER YOUR DETAILS BELOW****
--Q2-tds-queries.sql
--Student ID:30759277
--Student Name:LUDAI
--Tutorial No: Tutorial 9

/* Comments for your marker:




*/


/*
2(i) Query 1
*/
--PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
SELECT DEM_POINTS AS "Demerit Points",DEM_DESCRIPTION AS "Demerit Description"
FROM DEMERIT
WHERE DEM_DESCRIPTION LIKE 'Exceed%' OR DEM_DESCRIPTION LIKE  '%heavy%' OR DEM_DESCRIPTION LIKE  '%Heavy%'
ORDER BY "Demerit Points","Demerit Description";






/*
2(ii) Query 2
*/
--PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
SELECT VEH_MAINCOLOR AS"Main Colour",VEH_VIN AS VIN, TO_CHAR(veh_yrmanuf,'YYYY') AS "Year Manufactured"
FROM VEHICLE
WHERE VEH_MODNAME IN ('Range Rover','Range Rover Sport') AND TO_CHAR(veh_yrmanuf,'YYYY') >= '2012'
AND TO_CHAR(veh_yrmanuf,'YYYY') <= '2014'
ORDER BY "Year Manufactured" DESC,"Main Colour";





/*
2(iii) Query 3
*/
--PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
SELECT d.LIC_NO as "Licence No.", lic_fname ||' '|| lic_lname as "Driver Fullname" ,lic_dob as "DOB", 
lic_street ||' '|| lic_town ||' '|| lic_postcode as "Driver Address",
sus_date as "Suspended On", sus_enddate as "Suspended Till"
FROM driver d join suspension s on d.lic_no = s.lic_no
WHERE  sus_date > add_months(sysdate, -30) 
ORDER BY "Licence No.", sus_date DESC;





/*
2(iv) Query 4
*/
--PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
select o1.dem_code as "Demerit Code",d.dem_description as "Demerit Description",count(*) as "Total Offences (All Months)",
(select count(*) from offence o2 where
to_char(o2.off_datetime,'MON') = 'JAN' and o2.dem_code = o1.dem_code) as Jan ,
(select count(*) from offence o2 where
to_char(o2.off_datetime,'MON') = 'FEB' and o2.dem_code = o1.dem_code) as Feb ,
(select count(*) from offence o2 where
to_char(o2.off_datetime,'MON') = 'MAR' and o2.dem_code = o1.dem_code) as Mar ,
(select count(*) from offence o2 where
to_char(o2.off_datetime,'MON') = 'APR' and o2.dem_code = o1.dem_code) as Apr ,
(select count(*) from offence o2 where
to_char(o2.off_datetime,'MON') = 'MAY' and o2.dem_code = o1.dem_code) as May ,
(select count(*) from offence o2 where
to_char(o2.off_datetime,'MON') = 'JUN' and o2.dem_code = o1.dem_code) as Jun ,
(select count(*) from offence o2 where
to_char(o2.off_datetime,'MON') = 'JUL' and o2.dem_code = o1.dem_code) as Jul ,
(select count(*) from offence o2 where
to_char(o2.off_datetime,'MON') = 'AUG' and o2.dem_code = o1.dem_code) as Aug ,
(select count(*) from offence o2 where
to_char(o2.off_datetime,'MON') = 'SEP' and o2.dem_code = o1.dem_code) as Sep ,
(select count(*) from offence o2 where
to_char(o2.off_datetime,'MON') = 'OCT' and o2.dem_code = o1.dem_code) as Oct ,
(select count(*) from offence o2 where
to_char(o2.off_datetime,'MON') = 'NOV' and o2.dem_code = o1.dem_code) as Nov,
(select count(*) from offence o2 where
to_char(o2.off_datetime,'MON') = 'DEC' and o2.dem_code = o1.dem_code) as Dec
from offence o1 join demerit d on o1.dem_code = d.dem_code
group by o1.dem_code,d.dem_description
order by "Total Offences (All Months)" desc,"Demerit Code";




/*
2(v) Query 5
*/
--PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE

select veh_manufname as "Manufacturer Name", sum(dem_points) as "Total No. of Offences"
from vehicle v join offence o on v.veh_vin = o.veh_vin
    join demerit d on o.dem_code = d.dem_code
group by v.veh_manufname
having sum(d.dem_points) = (select max(sum(dem_points))
                    from vehicle v join offence o on v.veh_vin = o.veh_vin
                    join demerit d on o.dem_code = d.dem_code
                    group by v.veh_manufname)
order by "Total No. of Offences" desc,"Manufacturer Name";


/*
2(vi) Query 6
*/
--PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
select o.lic_no as "Licence No.", d.lic_fname ||' '|| d.lic_lname as "Driver Name",
        o.officer_id as "Officer ID", f.officer_fname ||' '|| f.officer_lname as "Officer Name"
from offence o join driver d on o.lic_no = d.lic_no
               join officer f on o.officer_id = f.officer_id
where d.lic_lname = f.officer_lname 
group by o.lic_no,d.lic_fname ||' '|| d.lic_lname,o.officer_id, o.officer_id, f.officer_fname ||' '|| f.officer_lname
having count(o.off_no) > 1 
order by o.lic_no;



/*
2(vii) Query 7
*/
--PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE

select o.dem_code as "Demerit Code", de.dem_description as "Demerit Description",
    o.lic_no as "Licence No.",  d.lic_fname ||' '|| d.lic_lname as "Driver Fullname",count(o.off_no) as "Total Times Booked"
from offence o join driver d on o.lic_no = d.lic_no
    join demerit de on o.dem_code = de.dem_code
group by o.dem_code, de.dem_description, o.lic_no, d.lic_fname ||' '|| d.lic_lname

order by o.dem_code, o.lic_no ;







/*
2(viii) Query 8
*/
--PLEASE PLACE REQUIRED SQL STATEMENT FOR THIS PART HERE
select REGION AS "Region", MANU_COUNT AS "Total Vehicles Manufactured", PERCENTAGE AS "Percentage of Vehicles Manufactured"
from(
select (case 
            when REGEXP_LIKE(veh_vin, '^[A-C]') then 'Africa'
            when REGEXP_LIKE(veh_vin, '^[J-R]') then 'Asia'
            when REGEXP_LIKE(veh_vin, '^[S-Z]') then 'Europe'
            when REGEXP_LIKE(veh_vin, '^[1-5]') then 'North America'
            when REGEXP_LIKE(veh_vin, '^[6-7]') then 'Oceania'
            when REGEXP_LIKE(veh_vin, '^[8-9]') then 'South America'
        else 'Unknown'
        end) as Region, count(veh_vin) as manu_count,
       concat(to_char(round(count(veh_vin)/(select count(veh_vin)from vehicle)*100,2),'990.99'),'%') as percentage
from vehicle
group by (case 
            when REGEXP_LIKE(veh_vin, '^[A-C]') then 'Africa'
            when REGEXP_LIKE(veh_vin, '^[J-R]') then 'Asia'
            when REGEXP_LIKE(veh_vin, '^[S-Z]') then 'Europe'
            when REGEXP_LIKE(veh_vin, '^[1-5]') then 'North America'
            when REGEXP_LIKE(veh_vin, '^[6-7]') then 'Oceania'
            when REGEXP_LIKE(veh_vin, '^[8-9]') then 'South America'
        else 'Unknown'
        end)
order by manu_count) union all
select 'TOTAL' as region, sum(temp_table.manu_count) as manu_count,concat(to_char(sum (temp_table.percentage),'990.99'),'%') as percentage
from
(select (case 
            when REGEXP_LIKE(veh_vin, '^[A-C]') then 'Africa'
            when REGEXP_LIKE(veh_vin, '^[J-R]') then 'Asia'
            when REGEXP_LIKE(veh_vin, '^[S-Z]') then 'Europe'
            when REGEXP_LIKE(veh_vin, '^[1-5]') then 'North America'
            when REGEXP_LIKE(veh_vin, '^[6-7]') then 'Oceania'
            when REGEXP_LIKE(veh_vin, '^[8-9]') then 'South America'
        else 'Unknown'
        end) as Regain1, count(veh_vin) as manu_count,
       round(count(veh_vin)/(select count(veh_vin)from vehicle)*100,2) as percentage
from vehicle
group by (case 
            when REGEXP_LIKE(veh_vin, '^[A-C]') then 'Africa'
            when REGEXP_LIKE(veh_vin, '^[J-R]') then 'Asia'
            when REGEXP_LIKE(veh_vin, '^[S-Z]') then 'Europe'
            when REGEXP_LIKE(veh_vin, '^[1-5]') then 'North America'
            when REGEXP_LIKE(veh_vin, '^[6-7]') then 'Oceania'
            when REGEXP_LIKE(veh_vin, '^[8-9]') then 'South America'
        else 'Unknown'
        end)
        order by manu_count) temp_table;

























