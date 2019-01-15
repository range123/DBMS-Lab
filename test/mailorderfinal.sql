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

 create table employee(
 emp_no varchar2(6) primary key,
 name varchar2(20),
 dob date,
 pincode constraint pincode_fk references city(pincode)
 ,
 constraint e_check check(emp_no like 'E%')
 );
 
create table customer(
customer_no varchar2(6) primary key,
name varchar2(20),
street_name varchar2(20),
pincode constraint p_fk references city(pincode),
phone_number number(10) unique,
dob date,
constraint customerchk check(customer_no like 'C%')
);

 create table parts(
 part_no varchar2(6) primary key,
 part_name varchar2(20),
 price number(6) not null,
 quantity number(3),
 constraint part_chk check(part_no like 'P%'),
 constraint quant_chk check(quantity>0)
 );

 create table orders(
 order_no varchar2(6) primary key,
 emp_no varchar2(6),
 customer_no varchar2(6),
 rec_date date,
 ship_date date,
 constraint ord_chk check(order_no like 'O%'),
 constraint date_chk check(ship_date < rec_date),
 constraint emp_fk foreign key(emp_no) references employee(emp_no),
 constraint cus_fk foreign key(customer_no) references customer(customer_no) 
 );

 create table order_details(
 order_no varchar2(6),
 part_no varchar2(6),
 quantity number(2),
 constraint quantity_chk check(quantity>0),
 constraint pk primary key(order_no,part_no),
 constraint order_fk foreign key(order_no) references orders(order_no),
 constraint part_fk foreign key(part_no) references parts(part_no)
 );

alter table parts
add reorder_level number(2);
alter table employee
add hiredate date;

alter table customer
modify(name varchar2(50));

alter table customer
drop column dob;

alter table orders
modify(rec_date constraint rec_check not null);

alter table order_details
drop constraint order_fk
drop constraint part_fk;
alter table order_details
add constraint order_fk foreign key(order_no) references orders(order_no) on delete cascade
add constraint part_fk foreign key(part_no) references parts(part_no) on delete cascade;
