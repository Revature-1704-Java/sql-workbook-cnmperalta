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
create or replace function getmysystemtime return timestamp with time zone is mysystemtime timestamp with time zone;
begin
    mysystemtime := current_timestamp;
    return mysystemtime;
end;
/

-- function that returns the length of a mediatype from the mediatype table
create or replace function getmediatypelength (gmediatype in varchar2) return number
is gmediatypelength number;
begin
    gmediatypelength:=length(gmediatype);
    return gmediatypelength;
end;
/

-- function that returns the average total of all invoices
create or replace function getinvoicetotalavg return number
is invoicetotalavg number;
begin
    select avg(total) into invoicetotalavg from invoice;
    return invoicetotalavg;
end;
/

begin
dbms_output.put_line(getinvoicetotalavg());
end;

-- create types to hold the results from a query
create or replace type track_tabtype is object (
    trackid number,
    name varchar2(200),
    albumid number,
    mediatypeid number,
    genreid number,
    composer varchar2(200),
    milliseconds number,
    bytes number,
    unitprice number(10,2)
);
/
create or replace type track_collection is table of track_tabtype;
/
-- function that returns the most expensive tracks
-- returns the most expensive tracks as a collection of type track_collection
create or replace function getmostexpensivetracks return track_collection
is mostexpensivetracks track_collection;
begin
mostexpensivetracks:=track_collection();
select track_tabtype(TRACKID, NAME, ALBUMID, MEDIATYPEID, GENREID, COMPOSER, MILLISECONDS, BYTES, UNITPRICE) bulk collect into mostexpensivetracks from track where track.unitprice=(select max(track.unitprice) from track);
return mostexpensivetracks;
end;
/

select * from table(getmostexpensivetracks());

-- function that returns the average price of invoiceline items in the invoiceline
create or replace function getinvoicelineaverage return number
is
    invoicelineaverage number;
    n_invoicelines number;
begin
    invoicelineaverage:=0;
    n_invoicelines:=0;
    for i in (select unitprice, quantity from invoiceline)
    loop
        invoicelineaverage:=invoicelineaverage + i.unitprice * i.quantity;
        n_invoicelines:=n_invoicelines+1;
    end loop;
    invoicelineaverage:=invoicelineaverage/n_invoicelines;
    return invoicelineaverage;
end;
/
begin
    dbms_output.put_line(getinvoicelineaverage);
end;

-- function that returns all employees born after 1968
create or replace type emp_born_after_68 is object (
    firstname varchar2(20),
    lastname varchar2(20),
    birthdate date
);

create or replace type tab_emp_born_after_68 is table of emp_born_after_68;

create or replace function getemployeesbornafter68 return tab_emp_born_after_68
is
emps_born_after_68 tab_emp_born_after_68;
begin
emps_born_after_68:=tab_emp_born_after_68();
select emp_born_after_68(firstname, lastname, birthdate) bulk collect into emps_born_after_68 from employee where birthdate>'31-DEC-68';
return emps_born_after_68;
end;

select * from table(getemployeesbornafter68());

-- 4.0 Stored Procedures
-- 4.1 Stored procedure that selects the first and last names of all employees
create or replace procedure showemployeenames (s out SYS_REFCURSOR) is
begin
    open s for select firstname, lastname from employee;
end;
/
declare
s sys_refcursor;
fname employee.firstname%type;
lname employee.lastname%type;
begin
showemployeenames(s);
loop
    fetch s into fname, lname;
    exit when s%notfound;
    dbms_output.put_line(fname||' '||lname);
end loop;
close s;
end;

-- 4.2 
-- stored procedure that updates the personal information of an employee
create or replace procedure updateemployeename (eid in number, fname in varchar2, lname in varchar2) is
begin
    update employee set firstname=fname where employeeid=eid;
    update employee set lastname=lname where employeeid=eid;
    dbms_output.put_line('Personal information update for employee with ID: '||eid);
    commit;
    
    exception
        when others
        then dbms_output.put_line('Failed to update employee information.');
        rollback;
end;
/
begin
updateemployeename(10, 'Katherine', 'Tan');
end;

-- procedure that returns the manager of an employee
create or replace procedure getemployeemanager(mfname out varchar2, mlname out varchar2, eid in number) is
reportstoid number;
begin
    select reportsto into reportstoid from employee where employeeid=eid;
    select firstname into mfname from employee where employeeid=reportstoid;
    select lastname into mlname from employee where employeeid=reportstoid;
end;
/
declare
fname employee.firstname%type;
lname employee.lastname%type;
begin
getemployeemanager(fname, lname, 10);
dbms_output.put_line(fname||' '||lname);
end;

-- 4.3
create or replace procedure getcustomernameandcompany (cfname out varchar2, clname out varchar, ccompany out varchar2, cid in number) is
begin
    select firstname into cfname from customer where customerid=cid;
    select lastname into clname from customer where customerid=cid;
    select company into ccompany from customer where customerid=cid;
end;
/
declare
    fname customer.firstname%type;
    lname customer.lastname%type;
    company customer.company%type;
begin
    getcustomernameandcompany(fname, lname, company, 19);
    dbms_output.put_line(fname||' '||lname||' '||company);
end;

-- 5.0 TRANSACTIONS
-- transaction that deletes an invoice given an id
create or replace procedure deleteinvoicewithid (iid in number) is
begin
    delete from invoiceline where invoiceid=iid;
    delete from invoice where invoiceid=iid;
    commit;
    
    exception
        when others
        then dbms_output.put_line('Failed to delete invoice.');
        rollback;
end;
/
begin
deleteinvoicewithid(319);
end;

-- transaction that inserts a new customer
create or replace procedure addnewcustomer (cid in number, cfname in varchar2, clname in varchar2, cemail in varchar2) is
begin
    insert into customer (customerid, firstname, lastname, email) values (cid, cfname, clname, cemail);
    commit;
    
    exception
        when others
        then dbms_output.put_line('Failed to add customer.');
        rollback;
end;
/
begin
    addnewcustomer(62, 'Juan', 'Bawagan', 'jbawagan@gmail.com');
end;

-- 6.0 TRIGGERS
-- after insert trigger on the employee table fired after a new record is inserted into the table
create or replace trigger tr_after_insert_employee
after insert on employee
begin
dbms_output.put_line('Handle aftermath of employee insertion.');
end;

-- after update trigger on the album table
create or replace trigger tr_after_update_album
after update on album
begin
dbms_output.put_line('Handle aftermath of album update.');
end;

-- after delete trigger on the customer table fired after a row is deleted from the table
create or replace trigger tr_after_delete_customer
after delete on customer
begin
dbms_output.put_line('Handle aftermath of customer delete.');
end;

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
select * from album
inner join artist on album.artistid=artist.artistid
inner join track on track.albumid=album.albumid
inner join genre on track.genreid=genre.genreid
inner join mediatype on track.mediatypeid=mediatype.mediatypeid
inner join playlisttrack on track.trackid=playlisttrack.trackid
inner join playlist on playlisttrack.playlistid=playlist.playlistid
inner join invoiceline on invoiceline.trackid=track.trackid
inner join invoice on invoiceline.invoiceid=invoice.invoiceid
inner join customer on invoice.customerid=customer.customerid
inner join employee on customer.supportrepid=employee.employeeid;