
rem 7.It is identified that the following attributes are to be included in respective relations:Parts (reorder level), Employees (hiredate)
describe parts;
alter table parts
add reorder_level number(2);
describe parts;
describe employee;
alter table employee
add hiredate date;
describe employee;

rem 8.The width of a customer name is not adequate for most of the customers.
describe customer;
alter table customer
modify(name varchar2(50));
describe customer;

rem 9.The dateofbirth of a customer can be addressed later / removed from the schema.
describe customer;
alter table customer
drop column dob;
describe customer;

rem 10.An order can not be placed without the receive date.
describe orders;
alter table orders
modify(rec_date constraint rec_check not null);
describe orders;

rem 11.A customer may cancel an order or ordered part(s) may not be available in a stock. Hence on removing the details of the order, ensure that all the corresponding details are also deleted.
rem Before delete.
select * from orders;
select * from order_details;
alter table order_details
drop constraint order_fk
drop constraint part_fk;
alter table order_details
add constraint order_fk foreign key(order_no) references orders(order_no) on delete cascade
add constraint part_fk foreign key(part_no) references parts(part_no) on delete cascade;
delete from orders
where order_no='O1';
rem After delete
select * from orders;
select * from order_details;