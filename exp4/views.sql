rem 1. Create a view named Blue_Flavor, which display the product details (product id,
rem food, price) of Blueberry flavor.

create or replace view Blue_Flavor as
select pid,food,price
from products
where flavor = 'Blueberry';
select * from Blue_Flavor;

rem check updatable
select COLUMN_NAME,UPDATABLE 
from USER_UPDATABLE_COLUMNS 
where table_name = 'BLUE_FLAVOR';

rem 2. Create a view named Cheap_Food, which display the details (product id, flavor,
rem food, price) of products with price lesser than $1. Ensure that, the price of these
rem food(s) should never rise above $1 through view.

create or replace view Cheap_Food as
select pid,flavor,food,price
from products
where price<1
with check option;
select * from Cheap_Food;

rem check updatable
select COLUMN_NAME,UPDATABLE 
from USER_UPDATABLE_COLUMNS 
where table_name = 'CHEAP_FOOD';

rem try to update price>1
update Cheap_Food
set price = price+5
where pid = '70-W';

rem 3. Create a view called Hot_Food that show the product id and its quantity where the
rem same product is ordered more than once in the same receipt.

create or replace view Hot_Food as
select i.item,count(i.item) as "quantity" 
from item_list i
group by (i.rno,i.item)
having count(i.item)>1;
select * from Hot_Food;

rem check updatable
select COLUMN_NAME,UPDATABLE 
from USER_UPDATABLE_COLUMNS 
where table_name = 'HOT_FOOD';


rem 4. Create a view named Pie_Food that will display the details (customer lname, flavor,
rem receipt number and date, ordinal) who had ordered the Pie food with receipt details.

create or replace view Pie_Food as
select c.last_name,p.flavor,r.rno,r.rdate,i.ordinal 
from customers c
join receipts r on(c.cid = r.cid)
join item_list i on(i.rno = r.rno)
join products p on(p.pid = i.item)
where p.food = 'Pie';
select * from Pie_Food;

rem check updatable
select COLUMN_NAME,UPDATABLE 
from USER_UPDATABLE_COLUMNS 
where table_name = 'PIE_FOOD';

rem 5. Create a view Cheap_View from Cheap_Food that shows only the product id, flavor
rem and food.

create or replace view Cheap_View as
select pid,flavor,food
from Cheap_Food;
select * from Cheap_View;

rem check updatable
select COLUMN_NAME,UPDATABLE 
from USER_UPDATABLE_COLUMNS 
where table_name = 'CHEAP_VIEW';


rem 6. Create a sequence named Ordinal_No_Seq which generates the ordinal number
rem starting from 1, increment by 1, to a maximum of 10. Include the options of cycle,
rem cache and order. Use this sequence to populate the item_list table for a new order.

create sequence Ordinal_No_Seq
start with 1
increment by 1
maxvalue 10
cycle
order
cache 5;

insert into receipts values(12121,'24-dec-2018',9);
insert into item_list values(12121,Ordinal_No_Seq.nextval,'70-MAR');
insert into item_list values(12121,Ordinal_No_Seq.nextval,'70-TU');
insert into item_list values(12121,Ordinal_No_Seq.nextval,'90-BLU-11');

rem after insert

select * 
from item_list
where rno = 12121;

rem 7. Create a synonym named Product_details for the item_list relation. Perform the
rem DML operations on it.

create or replace synonym Product_details
for item_list;

rem perform DML
select item
from Product_details p
where rno = 12121;


rem 8. Drop all the above created database objects.

drop view Blue_Flavor;
drop view Cheap_Food;
drop view Hot_Food;
drop view Pie_Food;
drop view Cheap_View;
drop sequence Ordinal_No_Seq;
drop synonym Product_Details;

delete from item_list
where rno = 12121;

delete from receipts
where rno = 12121;