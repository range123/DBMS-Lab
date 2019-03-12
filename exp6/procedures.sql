rem 1. For the given receipt number, calculate the Discount as follows:
rem For total amount > $10 and total amount < $25: Discount=5%
rem For total amount > $25 and total amount < $50: Discount=10%
rem For total amount > $50: Discount=20%
rem Calculate the amount (after the discount) and update the same in Receipts table.
rem Print the receipt as shown below:
create or replace procedure discount(rnum IN receipts.rno%type)
IS
  amt1 products.price%type;
  rows products%rowtype;
  c number;
  disc number;
  cursor list is
  select  p.* from receipts r
  join item_list i on (i.rno= r.rno)
  join products p on (p.pid= i.item)
  where r.rno = rnum;
  f_name customers.first_name%type;
  l_name customers.last_name%type;
  r_date receipts.rdate%type;

begin
  c:=0;
  open list;
  select c.first_name,c.last_name,r.rdate into f_name,l_name,r_date
  from receipts r
  join customers c on(c.cid = r.cid)
  where r.rno = rnum;
  dbms_output.put_line('****************************************************************************');
  dbms_output.put_line('Receipt Number : '||to_char(rnum)||'                 Customer name : '||to_char(f_name)||' '||to_char(l_name));
  dbms_output.put_line('receipt date : '||to_char(r_date));
  dbms_output.put_line('****************************************************************************');
  dbms_output.put_line(' SNO   FLAVOR   FOOD   PRICE ');
  fetch list into rows;
  while list%found loop
    c:=c+1;
    dbms_output.put_line(to_char(c)||'  '||to_char(rows.flavor)||'  '||to_char(rows.food)||'  '||to_char(rows.price));
    fetch list into rows;
  end loop;
  dbms_output.put_line('--------------------------------------------------------------------------------');
  select sum(p.price) into amt1 from receipts r
  join item_list i on(r.rno = i.rno)
  join products p on(p.pid = i.item)
  where r.rno = rnum
  group by r.rno;
  if amt1 > 10 and amt1 <=  25 then
    disc := 5;
  elsif amt1>25 and amt1 <= 50 then
     disc:=10;
  elsif amt1 >50 then
    disc:= 20;
  end if;
  dbms_output.put_line('					Total =  '|| to_char(amt1));
  dbms_output.put_line('--------------------------------------------------------------------------------');
  dbms_output.put_line('Total amount = '||to_char(amt1));
  dbms_output.put_line('--------------------------------------------------------------------------------');
  amt1 := amt1 - disc*amt1/100;
  dbms_output.put_line('discount('||to_char(disc)||') = '||to_char(disc*amt1/100));
  dbms_output.put_line('Amount to be paid = '||to_char(amt1));
  dbms_output.put_line('****************************************************************************');
  dbms_output.put_line('Great Offers! Discount up to 25% on DIWALI Festival Day...');
  dbms_output.put_line('****************************************************************************');
  update receipts
  set amt = amt1
  where rno = rnum;
  close list;
  end;
  /
call discount(13355);
select * from receipts where rno = 13355;

rem 2. Ask the user for the budget and his/her preferred food type. You recommend the best
rem item(s) within the planned budget for the given food type. The best item is
rem determined by the maximum ordered product among many customers for the given
rem food type.
rem Print the recommended product that suits your budget as below:

create or replace procedure recommend(budget in number , foodtype in varchar)
AS
	flavorp products.flavor%type;
	foodp products.food%type;
	pricep products.price%type;
	item_id products.pid%type;
	it_id varchar2(20);
	it_flavor varchar2(20);
	it_price decimal(5,3);
	quantity number(4);

	CURSOR c2 IS
		select pid,flavor,food,price
		from products
		where food =foodtype;
	begin
		select pid,flavor,price into it_id ,it_flavor,it_price from
		products where pid in (select item from item_list group by item having count(item) >= ALL (select max(count(item))
				from products p JOIN item_list it ON(p.pid=it.item)
				where food = foodtype group by item) and food = foodtype);

		dbms_output.put_line ('*******************************************************************');
		dbms_output.put_line ('Budget : $' || budget || rpad('  ',6,'  ') || 'Food Type :  ' || foodtype);
		dbms_output.put_line ('*******************************************************************');

		dbms_output.put_line ('Item ID'|| rpad(' ',8,' ') ||'Flavor'|| rpad(' ',8,' ') ||'Food'|| rpad(' ',8,' ') ||'Price');
		dbms_output.put_line ('------------------------------------------------------------------');
		open c2;
			loop
				FETCH c2 into item_id,flavorp,foodp,pricep;
				exit when c2%notfound;
				dbms_output.put_line (item_id || rpad('  ',9,' ') ||flavorp|| rpad(' ',9,'  ') ||foodp|| rpad('  ',8,'  ') ||pricep);
			end loop;
			dbms_output.put_line ('------------------------------------------------------------------');

			dbms_output.put_line (it_id || ' with '||it_flavor || ' flavor is the best item in ' || foodtype || ' type!');

			quantity := budget/it_price;

			if quantity >1 then
				dbms_output.put_line('You are entitled to purchase '||quantity||rpad('  ',1,' ')||foodtype||rpad('  ',1,' ')||it_flavor|| 's for the');
				dbms_output.put_line('given budget type!!!');
			else
				dbms_output.put_line ('You can not buy any food. You are out of budget.');
			end if;
			dbms_output.put_line ('*******************************************************************');
		close c2;

	end;
/


declare
  budget decimal(5,2);
  foodtype varchar2(30);
begin
  budget := &Budget;
  foodtype := '&FoodType';
  recommend(budget,foodtype);

end;
/



create or replace procedure get_cid1(cid out customers.cid%type)
  is
  begin
    cid := &cid;
  end;
  /
create or replace procedure check_found(rnum in receipts.rno%type,ord out item_list.ordinal%type)
is
  rdt receipts.rdate%type;
  cno receipts.cid%type;
begin
  ord:=0;
  select max(ordinal) into ord
  from item_list
  where rno =rnum;
  ord:=ord+1;
end;
/
create or replace procedure ins_item(rnum in receipts.rno%type,ord in item_list.ordinal%type,it in item_list.item%type)
  is
  begin
    insert into item_list values(rnum,ord,it);
  end;
  /
create or replace procedure ins_receipt(rnum in receipts.rno%type,rdt in receipts.rdate%type,cno in receipts.cid%type,it in item_list.item%type )
  is
  begin
    insert into receipts(rno,rdate,cid) values(rnum,rdt,cid);
    ins_item(rnum,1,it);
  end;
  /
declare
  rnum receipts.rno%type;
  it item_list.item%type;
  ord item_list.ordinal%type;
  cid varchar2(30);
  rdt date;
begin
  rnum:=&rno;
  it :=&it;
  check_found(rnum,ord);
  if ord > 1 then
    ins_item(rnum,ord,it)
  else
    select sysdate into rdt from dual;
    ins_receipt(rnum,rdt,)
  end if;
end;
/


rem 4. Write a stored function to display the customer name who ordered maximum for the
rem given food and flavor.

create or replace function get_Customer
  (fd in varchar2,fl in varchar2)
  return varchar2
  is
    ans varchar2(100);
    fname varchar2(30);
    lname varchar2(30);
    c number;
    cursor maxcust is
    select first_name,last_name from customers
    where cid in (select c.cid from products p
                join item_list i on(p.pid = i.item)
                join receipts r on(r.rno = i.rno)
                join customers c on(r.cid = c.cid)
                where food = fd and flavor = fl
                group by c.cid
                having count(*) = (select max(count(*)) from products p
                                  join item_list i on(p.pid = i.item)
                                  join receipts r on(r.rno = i.rno)
                                  join customers c on(r.cid = c.cid)
                                 where food = fd and flavor = fl
                                  group by c.cid));
  begin
    open maxcust;
    c:=0;
    fetch maxcust into fname,lname;
    while maxcust%FOUND loop
      if c = 0 then
        ans:=fname || ' ' || lname;
      else
        ans:=ans||','||fname || ' ' || lname;
      end if;
      c:=c+1;
      fetch maxcust into fname,lname;
      end loop;
    return ans;
    close maxcust;
  end;
  /

declare
  food varchar2(30);
  flavor varchar2(30);
begin
  food := '&food';
  flavor := '&flavor';
  dbms_output.put_line(to_char(get_Customer(food,flavor)) || ' are(is) The customer(s) who bought the maximum number of '|| to_char(flavor)||' '||to_char(food));
end;
/
