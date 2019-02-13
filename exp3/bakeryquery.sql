rem 1. Display the food details that is not purchased by any of customers.
select * 
from products p
where p.pid not in (select item 
					from item_list);

rem 2. Show the customer details who had placed more than 2 orders on the same date.
select * 
from customers c
where c.cid in (select cid 
				from receipts
				group by (cid,rdate)
				having count(rno)>2);

rem 3. Display the products details that has been ordered maximum by the customers. (use ALL)
select * 
from products
where pid = (select item 
			from item_list
			group by item
			having count(item) >= all(select count(item) 
									  from item_list
									  group by item));

-- rem alternate
-- select * from products
-- where pid = (select item from item_list
-- 	group by item
-- 	having count(item) > all(select max(count(item)) from item_list
-- group by item));

rem 4. Show the number of receipts that contain the product whose price is more than the
rem average price of its food type.
select count(unique(rno)) 
from item_list
where item in (select pid 
			   from products p
where price > (select avg(price) 
				from products
				where food = p.food
				group by food));

rem 5. Display the customer details along with receipt number and date for the receipts that
rem are dated on the last day of the receipt month.
select * 
from customers
join receipts using(cid)
where last_day(rdate) = rdate;

rem 6. Display the receipt number(s) and its total price for the receipt(s) that contain Twist
rem as one among five items. Include only the receipts with total price more than $25.
select i.rno,sum(price)
 from item_list i
 join products p on(i.item = p.pid)
 where i.rno in(select it.rno 
 				from item_list it
 				join products pr on(it.item = pr.pid)
 				where food = 'Twist'
 				group by it.rno)
group by i.rno
having count(*) = 5 and sum(price)>25;

rem 7. Display the details (customer details, receipt number, item) for the product that was
rem purchased by the least number of customers.
 select c.*,r.rno,i.item 
from receipts r join item_list i on(i.rno=r.rno) 
join customers c on(r.cid=c.cid) 
where i.item in (select item 
				from item_list 
				group by (item) 
				having count(item) <= all(select count(item) 
										  from item_list 
										  group by (item)));

rem 8. Display the customer details along with the receipt number who ordered all the
rem flavors of Meringue in the same receipt.
select c.*,r1.rno
from receipts r1 
join customers c on(c.cid = r1.cid)
where r1.rno = 
		(select r2.rno 
		from receipts r2
		join item_list i on(r2.rno = i.rno)
		join products p on (p.pid = i.item)
		where p.food = 'Meringue'
		group by r2.rno
		having count(distinct(flavor)) = (select count(distinct(flavor)) 
										  from products
										  where food = 'Meringue')
		);


rem 9. Display the product details of both Pie and Bear Claw.
(select * 
from products
where food = 'Pie')
union
(select * 
from products
where food = 'Bear Claw');

rem 10.Display the customers details who havent placed any orders.
select * 
from customers
where cid in ((select cid 
			  from customers)
			minus
			(select cid 
			from receipts));

rem 11.Display the food that has the same flavor as that of the common flavor between the
rem Meringue and Tart.
select food 
from products p
where p.flavor in ((select flavor 
					from products
					where food = 'Meringue')
					intersect
					(select flavor 
					from products
					where food = 'Tart'))
and p.food not in ('Meringue','Tart');
