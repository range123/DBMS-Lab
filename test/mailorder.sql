 drop table order_details;  
 drop table orders;
 drop table parts;
 drop table customer;
 drop table employee;
 drop table city;




 create table city(
 pincode number(6) primary key,
 city varchar2(20)
 );
 describe city;

 create table employee(
 emp_no varchar2(6) primary key,
 name varchar2(20),
 dob date,
 pincode constraint pincode_fk references city(pincode)
 ,
 constraint e_check check(emp_no like 'E%')
 );
 describe employee;

create table customer(
customer_no varchar2(6) primary key,
name varchar2(20),
street_name varchar2(20),
pincode constraint p_fk references city(pincode),
phone_number number(10) unique,
dob date,
constraint customerchk check(customer_no like 'C%')
);
 describe customer;


 create table parts(
 part_no varchar2(6) primary key,
 part_name varchar2(20),
 price number(6) not null,
 quantity number(3),
 constraint part_chk check(part_no like 'P%'),
 constraint quant_chk check(quantity>0)
 );
 describe parts;

 create table orders(
 order_no varchar2(6) primary key,
 emp_no references employee(emp_no),
 customer_no references customer(customer_no),
 rec_date date,
 ship_date date,
 constraint ord_chk check(order_no like 'O%'),
 constraint date_chk check(ship_date < rec_date)
 );
 describe orders;

 create table order_details(
 order_no references orders(order_no),
 part_no references parts(part_no),
 quantity number(2),
 constraint quantity_chk check(quantity>0),
 constraint pk primary key(order_no,part_no)
 );
 describe order_details;