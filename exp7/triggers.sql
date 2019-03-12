rem adding amt to receipts and calculating the amount for each receipt
alter table receipts
add (amt decimal(5,2));
declare
  r number(6);
  cursor c1 is
  select rno from receipts;
begin
  open c1;
  fetch c1 into r;
  while c1%found loop
    update receipts
    set amt = (select sum(p.price) from products p
                join item_list i on(p.pid = i.item)
                join receipts r on(r.rno = i.rno)
                where r.rno = r
                group by r.rno)
    where rno = r;
    fetch c1 into r;
  end loop;
  close c1;
end;
/

rem 1. The combination of Flavor and Food determines the product id. Hence, while
rem inserting a new instance into the Products relation, ensure that the same combination
rem of Flavor and Food is not already available.

create or replace trigger unique_food
before insert on products
for each row
declare
  pro varchar2(30);
  cursor c1 is
  select pid into pro from products
  where food = :new.food and flavor = :new.flavor;
begin
  open c1;
  fetch c1 into pro;
  if c1%found then
      RAISE_APPLICATION_ERROR( -20001, 'The Combination of Food and Flavor already exists' );
  end if;
  close c1;
end;
/
savepoint q;
insert into products values('1-21-1','Chocolate','Cake',20.01);
insert into products values('1-AB-1','Apricot','Muffin',2.21);
rollback to q;



rem 2. While entering an item into the item_list relation, update the amount in Receipts with
rem the total amount for that receipt number.

create or replace trigger updt
after insert on item_list
for each row
begin
  update receipts
  set amt = (select amt from receipts
            where rno = :new.rno) + (select price from products
            where pid = :new.item)
  where rno = :new.rno;

end;
/
savepoint t;
select amt from receipts where rno = 17947;
rem item costs 1.15
insert into item_list values(17947,2,'51-BLU');
rem result = 1.45 + 1.15 = 2.6
select amt from receipts where rno = 17947;
rollback to t;




rem 3. Implement the following constraints for Item_list relation:

rem a. A receipt can contain a maximum of five items only.

create or replace trigger max_items
before insert or update on item_list
for each row
declare
  counter number;
  cursor c1 is
  select count(*) into counter
  from item_list
  where rno = :new.rno
  group by rno;
begin
  open c1;
  fetch c1 into counter;
  if counter>=5 then
    RAISE_APPLICATION_ERROR( -20001, 'Can Order only 5 Items maximum' );
  end if;
  close c1;
end;
/

savepoint s;
insert into receipts(rno,rdate,cid) values(9999,'24-dec-1999',5);
insert into item_list values(9999,1,'26-8x10');
insert into item_list values(9999,2,'26-8x10');
insert into item_list values(9999,3,'90-APP-11');
insert into item_list values(9999,4,'70-LEM');
insert into item_list values(9999,5,'70-LEM');
insert into item_list values(9999,6,'70-LEM');
rollback to s;

rem b. A receipt should not allow an item to be purchased more than thrice.

create or replace trigger max_item
before insert or update on item_list
for each row
declare
  counter number;
  cursor c1 is
  select count(*) from item_list
  where rno = :new.rno and item = :new.item
  group by (rno,item);
begin
  open c1;
  fetch c1 into counter;
  if counter>=3 then
    RAISE_APPLICATION_ERROR( -20001, 'You have already bought this item 3 times ' );
  end if;
  close c1;
end;
/

savepoint s1;
insert into receipts(rno,rdate,cid) values(9999,'24-dec-1999',5);
insert into item_list values(9999,1,'26-8x10');
insert into item_list values(9999,2,'26-8x10');
insert into item_list values(9999,3,'26-8x10');
insert into item_list values(9999,4,'26-8x10');
rollback to s1;
