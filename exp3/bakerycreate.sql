
drop table item_list;
drop table receipts;
drop table products;
drop table customers;

create table customers(
cid number(2) constraint cust_pk primary key,
first_name varchar2(20),
last_name varchar2(20)
);

create table products(
pid varchar2(20) constraint pro_pk primary key, 
flavor varchar2(20),
food varchar2(20),
price decimal(3,2) constraint p_chk check(price>0)
);

create table receipts(
rno number(5) constraint rec_pk primary key,
rdate date,
cid constraint cid_fk references customers(cid) 
);

create table item_list(
rno constraint rno_fk references receipts(rno),
ordinal number constraint ch_k check(ordinal<=5),
item varchar2(20) constraint pid_fk references products(pid),
constraint item_pk primary key(rno,ordinal) 
);