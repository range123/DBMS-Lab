rem 1. Check whether the given combination of food and flavor is available. If any one or
rem both are not available, display the relevant message.
declare
  rows products%rowtype;
  f1 products%
  cursor c1 is
  select * from products
  where food = '&food' and flavor = '&flavor';


begin
  open c1;
  fetch c1 into rows;
  if c1%FOUND then
    dbms_output.put_line('Both Found');
  elsif c1%NOTFOUND then
    dbms_output.put_line('Both Not Found');
  END IF;
  close c1;
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
  row1 products%rowtype;
  flag number;
  counter number;
  dp decimal(5,2);
  minprice decimal(5,2);
  maxprice decimal(5,2);
  cursor c1 is
  select * from products
  where price = dp;

begin
  dp := &price;
  flag := 0;
  counter:=0;
  select min(price) into minprice from products
  where price>dp;
  select max(price) into maxprice from products
  where price<dp;

  dbms_output.put_line('ProductID' ||'      '||'Food'||'      '||'Flavor'||'      '||'Price');
  dbms_output.put_line('---------------------------------------------------------------------');

  open c1;
  fetch c1 into row1;
  while c1%found loop
    counter:=counter+1;
    flag:=1;
    dbms_output.put_line(row1.pid ||'   '||row1.food ||'    '|| row1.flavor ||'   '|| row1.price);
    fetch c1 into row1;
  end loop;
  close c1;

  if flag=0 and abs(minprice-dp)<abs(maxprice-dp) then
    dp := minprice;
    open c1;
    fetch c1 into row1;
    while c1%found loop
      counter:=counter+1;
      dbms_output.put_line(row1.pid ||'   '||row1.food ||'    '|| row1.flavor ||'   '|| row1.price);
      fetch c1 into row1;
    end loop;
    close c1;
  elsif flag = 0 and abs(minprice-dp)>abs(maxprice-dp) then
    dp := maxprice;
    open c1;
    fetch c1 into row1;
    while c1%found loop
      counter:=counter+1;
      dbms_output.put_line(row1.pid ||'   '||row1.food ||'    '|| row1.flavor ||'   '|| row1.price);
      fetch c1 into row1;
    end loop;
    close c1;
  elsif flag = 0 and abs(minprice-dp) = abs(maxprice-dp) then
    dp := maxprice;
    open c1;
    fetch c1 into row1;
    while c1%found loop
      counter:=counter+1;
      dbms_output.put_line(row1.pid ||'   '||row1.food ||'    '|| row1.flavor ||'   '|| row1.price);
      fetch c1 into row1;
    end loop;
    close c1;

    dp := minprice;
    open c1;
    fetch c1 into row1;
    while c1%found loop
      counter:=counter+1;
      dbms_output.put_line(row1.pid ||'   '||row1.food ||'    '|| row1.flavor ||'   '|| row1.price);
      fetch c1 into row1;
    end loop;
    close c1;

  end if;

  dbms_output.put_line('---------------------------------------------------------------------');
  dbms_output.put_line(to_char(counter) || ' product(s) found EQUAL/CLOSEST to given price');

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