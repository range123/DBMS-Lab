 rem dropping tables
 drop table order_details;  
 drop table orders;
 drop table parts;
 drop table customer;
 drop table employee;
 drop table city;



 rem creating tables

 create table city(
 pincode number(6) constraint pc_k primary key,
 city varchar2(20)
 );
describe city;

 create table employee(
 emp_no varchar2(6) constraint p_fk6 primary key,
 name varchar2(20),
 dob date,
 pincode constraint pincode_fk references city(pincode)
 ,
 constraint e_check check(emp_no like 'E%')
 );
describe employee;
 
create table customer(
customer_no varchar2(6) constraint p_fk1 primary key,
name varchar2(20),
street_name varchar2(20),
pincode constraint p_fk references city(pincode),
phone_number number(10) constraint un unique,
dob date,
constraint customerchk check(customer_no like 'C%')
);
describe customer;

 create table parts(
 part_no varchar2(6) constraint p_fk2 primary key,
 part_name varchar2(20),
 price number(6) constraint nn not null,
 quantity number(3),
 constraint part_chk check(part_no like 'P%')
 );
describe parts;

 create table orders(
 order_no varchar2(6) constraint p_fk3 primary key,
 emp_no varchar2(6),
 customer_no varchar2(6),
 rec_date date,
 ship_date date,
 constraint ord_chk check(order_no like 'O%'),
 constraint date_chk check(ship_date > rec_date),
 constraint emp_fk foreign key(emp_no) references employee(emp_no),
 constraint cus_fk foreign key(customer_no) references customer(customer_no) 
 );
describe orders;

 create table order_details(
 order_no varchar2(6),
 part_no varchar2(6),
 quantity number(2),
 constraint quantity_chk check(quantity>0),
 constraint pk primary key(order_no,part_no),
 constraint order_fk foreign key(order_no) references orders(order_no),
 constraint part_fk foreign key(part_no) references parts(part_no)
 );
describe order_details;

rem inserting values

insert into city values(600041,'Thiruvanmiyur');
insert into city values(600090,'Besant Nagar');
insert into city values(600096,'Perungudi');
select * from city;

insert into employee values('E1','harish','12-apr-2000',600041);
insert into employee values('E2','clement','12-apr-2000',600090);
insert into employee values('E3','jayaraman','24-dec-2000',600096);
select * from employee;

insert into customer values('C1','arvind','rajiv street',600090,1234567890,'08-dec-1999');
insert into customer values('C2','arumugam','kalavakam',600041,7562539684,'06-oct-1999');
insert into customer values('C3','gerard','perungalathur',600090,3453136482,'08-dec-1999');
select * from customer;

insert into parts values('P1','mobile phone',13000,4);
insert into parts values('P2','computer',22000,11);
insert into parts values('P3','Cricket bat',7000,3);
select * from parts;

insert into orders values('O1','E2','C1','12-oct-2018','16-oct-2018');
insert into orders values('O2','E1','C1','12-jan-2018','16-feb-2018');
insert into orders values('O3','E3','C3','18-jun-2018','21-jul-2018');
select * from orders;

insert into order_details values('O1','P1',2);
insert into order_details values('O2','P2',1);
insert into order_details values('O3','P3',2);
select * from order_details;



