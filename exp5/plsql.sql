rem 1. Check whether the given combination of food and flavor is available. If any one or
rem both are not available, display the relevant message.
declare
  fd products.food%type;
  fl products.flavor%type;
  rows products%rowtype;
  c1 number;
  c2 number;
  c3 number;
begin
  fd := '&food';
  fl :='&flavor';
  begin
    select pid into rows.pid from products
    where food = fd and flavor = fl;
    exception when no_data_found then
    c1 := 0;
  end;
  if SQL%found then
    c1 :=1;
  end if;

  begin
    select distinct food into rows.food from products
    where food = fd;
    exception when no_data_found then
    c2 := 0;
  end;
  if sql%found then
  c2:=1;
  end if;
  begin
    select distinct flavor into rows.flavor from products
    where flavor = fl;
    exception when no_data_found then
    c3:=0;
  end;
  if sql%found then
    c3 := 1;
  end if;
  if c1=1 then
    dbms_output.put_line('Combination found');
  elsif c2=1 and c3=1 then
   dbms_output.put_line('Both food and flavor found');
  elsif c2=1 then
    dbms_output.put_line('Food found');
  elsif c3=1 then
    dbms_output.put_line('Flavor found');
  else
    dbms_output.put_line('Both not found');
  end if;
END;
/

rem 2. On a given date, find the number of receipts sold (Use Implicit cursor).
declare
  buy_date varchar2(20);
begin
  buy_date:='&date';
  update receipts
  set rno = rno
  where rdate = buy_date;

  dbms_output.put_line('No. of receipts sold on ' || to_char(buy_date) || ' = ' ||to_char(SQL%rowcount));


end;
/

rem 3. An user desired to buy the product with the specific price. Ask the user for a price,
rem find the food item(s) that is equal or closest to the desired price. Print the product
rem number, food type, flavor and price. Also print the number of items that is equal or
rem closest to the desired price.

declare
  ip_price products.price%type;
  cursor c1 is select * from products
  where abs(price-ip_price) =
  (select min(abs(price-ip_price)) from products);
  pro products%rowtype;
  c integer;
begin
  ip_price := &input_price;
	open c1;
	c := 0;
  dbms_output.put_line('ProductID' ||'      '||'Food'||'      '||'Flavor'||'      '||'Price');
  dbms_output.put_line('---------------------------------------------------------------------');
	loop
		fetch c1
		into pro.pid, pro.flavor, pro.food, pro.price;
		exit when c1%notfound;
		dbms_output.put_line(pro.pid||'      '||pro.flavor||'      '||pro.food||'      '||pro.price);
		c := c+1;
	end loop;
  dbms_output.put_line('---------------------------------------------------------------------');
  dbms_output.put_line(to_char(c) || ' product(s) found EQUAL/CLOSEST to given price');
end;
/



rem 4.Display the customer name along with the details of item and its quantity ordered for
rem the given order number. Also calculate the total quantity ordered as shown below:
declare
  counter number(2);
  rid receipts.rno%TYPE;
  food products.food%TYPE;
  flavor products.flavor%TYPE;
  fname customers.first_name%TYPE;
  lname customers.last_name%TYPE;
  qty number;

  cursor g_name is
  select c.first_name,c.last_name from receipts r
  join customers c on(r.cid = c.cid)
  where r.rno = rid;

  cursor c1 is
  select p.food,p.flavor,count(*) from receipts r
  join customers c on(r.cid = c.cid)
  join item_list i on(i.rno = r.rno)
  join products p on(p.pid = i.item)
  where r.rno = rid
  group by (p.food,p.flavor);
begin
  rid:=&rno;
  counter:=0;
  open g_name;
  fetch g_name into fname,lname;
  dbms_output.put_line('Customer Name: '||fname||' '||lname);
  close g_name;

  dbms_output.put_line('FOOD     FLAVOR     QTY');
  dbms_output.put_line('------------------------');
  open c1;
  fetch c1 into food,flavor,qty;
  while c1%Found loop
    counter:=counter+qty;
    dbms_output.put_line(food || '    ' || flavor || '    ' || to_char(qty));
    fetch c1 into food,flavor,qty;
    end loop;
  close c1;
  dbms_output.put_line('------------------------');
  dbms_output.put_line('Total Quantity = '|| to_char(counter));
end;
/
