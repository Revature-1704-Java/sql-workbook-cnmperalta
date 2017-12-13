-- 2.0 SQL Queries
-- select all records in employee table
select * from employee;
-- select all records in employee table with the last name King
select * from employee where lastname='King';
-- select all records in employee table with the first namen Andrew and with a null reportsto field
select * from employee where firstname='Andrew' and reportsto is null;

-- order album in  descending order by title
select * from album order by title desc;
-- order first names in customer by city in ascending order
select firstname from customer order by city asc;

-- insert two new records into the Genre table
insert into genre values(26, 'KPOP');
insert into genre values(27, 'OPM');

-- insert two new records into Employee table
insert into employee values (
9,
'Recario',
'Reginald',
'IT  Manager',
1,
TO_DATE('1987-5-20 00:00:00','yyyy-mm-dd hh24:mi:ss'),
TO_DATE('2008-6-11 00:00:00','yyyy-mm-dd hh24:mi:ss'),
'11730 Plaza America Dr Suite 205',
'Reston',
'VA',
'United States',
'20190',
'+1 (703) 513-1251',
'+1 (703) 513-1251',
'rncrecario@chinookcorp.com'
);
insert into employee values (
10,
'Pelaez',
'Kristine',
'IT  Staff',
9,
TO_DATE('1993-8-2 00:00:00','yyyy-mm-dd hh24:mi:ss'),
TO_DATE('2014-6-11 00:00:00','yyyy-mm-dd hh24:mi:ss'),
'11730 Plaza America Dr Suite 205',
'Reston',
'VA',
'United States',
'20190',
'+1 (703) 723-9655',
'+1 (703) 723-9655',
'kbppelaez@chinookcorp.com'
);

-- insert two new entries in the customer table
insert into customer (customerid, firstname, lastname, company, address, city, state, country, postalcode, phone, fax, email) values (
60,
'Katherine',
'Tan',
'UPLB',
'Harold Cuzner Avenue',
'Los Banos',
'Laguna',
'Philippines',
'4031',
'+63 977 512 5124',
'+63 49 536 2302',
'ktan@gmail.com'
);

insert into customer (customerid, firstname, lastname, company, address, city, state, country, postalcode, phone, fax, email) values (
61,
'Dyanara',
'Dela Rosa',
'UPLB',
'Harold Cuzner Avenue',
'Los Banos',
'Laguna',
'Philippines',
'4031',
'+63 933 512 5122',
'+63 49 536 2302',
'ddelarosa@gmail.com'
);

-- Update customer row Aaron Mitchell to have the name Robert Walter
update customer set
firstname='Robert',
lastname='Walter'
where firstname='Aaron' and lastname='Mitchell';

-- Update artist with name Creedence Clearwater Revival to name CCR
update artist set name='CCR' where name='Creedence Clearwater Revival';

--  select all invoices with billing address like "T%"
select * from invoice where billingaddress like 'T%';

-- select all invoices that have a total between 15 and 50
select * from invoice where total between 15 and 50;

-- select all employees hired between 1st of June 2003 and 1st of March 2004
select * from employee where hiredate between TO_DATE('2003-6-1 00:00:00','yyyy-mm-dd hh24:mi:ss') and TO_DATE('2004-1-3 00:00:00','yyyy-mm-dd hh24:mi:ss');

-- delete a record in customer table where the name is Robert Walter
-- delete all invoiceline records that reference the invoices that reference Robert Walter which deletes 38 rows
delete from invoiceline where invoiceid in (
    select invoiceid from invoice where customerid=(
        select customerid from customer where firstname='Robert' and lastname='Walter'
    )
);

-- delete all invoice records that reference Robert Walter in the customer table which deletes 7 rows
delete from invoice where customerid=(
    select customerid from customer where firstname='Robert' and lastname='Walter'
);

-- finally, delete Robert Walters from the customer table which only deletes 1 row
delete from customer where firstname='Robert' and lastname='Walter';

-- function that returns the current time
--create or replace function getmysystemtime return timestamp with time zone is mysystemtime timestamp with time zone;
--begin
--    mysystemtime := systimestamp;
--    dbms_output.put_line(mysystemtime);
--    return mysystemtime;
--end;

-- function that returns the length of a mediatype from the mediatype table



-- 7.0 JOINS
-- inner join that joins customers and orders and specifies the name of the customer and the invoiceid
select c.firstname, c.lastname, i.invoiceid from customer c inner join invoice i on i.customerid=c.customerid;

-- outer join that joins the customer and invoice table, specifying customerid, firstname, lastname, invoiceid, and total
select c.customerid, c.firstname, c.lastname, i.invoiceid, i.total from customer c left join invoice i on i.customerid=c.customerid;

-- right join that joins the albums and artist specifying artist name and title
select ar.name, al.title from artist ar right join album al on ar.artistid=al.artistid;

-- cross join that joins the album and artist and sorts by artist name in ascending order
select * from album cross join artist order by artist.name asc;

-- self join on the employee table joining on the reportsto column
select * from employee e1 inner join employee e2 on e1.reportsto=e2.employeeid;

-- complicated join assignment that joins all tables in the chinook database
