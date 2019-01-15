rem 1. Display the food details that is not purchased by any of customers.
select * 
from products p
where p.pid not in (select item from item_list);

rem 2. Show the customer details who had placed more than 2 orders on the same date.
select * 
from customers c
where c.cid in (select cid from receipts
				group by (cid,rdate)
				having count(rno)>2);

rem 3. Display the products details that has been ordered maximum by the customers. (use ALL)
select * from products
where pid = (select item from item_list
	group by item
	having count(item) >= all(select count(item) from item_list
group by item));

rem alternate
-- select * from products
-- where pid = (select item from item_list
-- 	group by item
-- 	having count(item) > all(select max(count(item)) from item_list
-- group by item));

rem 4. Show the number of receipts that contain the product whose price is more than the
rem average price of its food type.
select count(unique(rno)) from item_list
where item in (select pid from products p
where price > (select avg(price) from products q
					where food = p.food
					group by food));

rem 5. Display the customer details along with receipt number and date for the receipts that
rem are dated on the last day of the receipt month.
select * from customers
join receipts using(cid)
where last_day(rdate) = rdate;

rem 6. Display the receipt number(s) and its total price for the receipt(s) that contain Twist
rem as one among five items. Include only the receipts with total price more than $25.
select rno,sum(price) from item_list i
 join products p on(i.item = p.pid)
 where food = 'Twist'
group by rno
having sum(price)>25;

rem 7. Display the details (customer details, receipt number, item) for the product that was
rem purchased by the least number of customers.
select c.cid,rno,item from customers c,(select * from receipts
join item_list using(rno))
group by c.cid;

rem 8. Display the customer details along with the receipt number who ordered all the
rem flavors of Meringue in the same receipt.
select * from item_list 
join products using(pid)
where food = 'Meringue' 
group by rno
all(select flavor from products
where food = 'Meringue');


rem 9. Display the product details of both Pie and Bear Claw.
(select * from products
where food = 'Pie')
union
(select * from products
where food = 'Bear Claw');

rem 10.Display the customers details who haven't placed any orders.
select * from customers
where cid in ((select cid from customers)
minus
(select cid from receipts));

rem 11.Display the food that has the same flavor as that of the common flavor between the
rem Meringue and Tart.
select food from products p
where p.flavor in ((select flavor from products
where food = 'Meringue')
intersect
(select flavor from products
where food = 'Tart'));


