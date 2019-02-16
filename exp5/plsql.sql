rem 1. Check whether the given combination of food and flavor is available. If any one or
rem both are not available, display the relevant message.
declare
  cursor c1 is
  select * from products
  where food = '&food' and flavor = '&flavor';
  rows products%rowtype;
begin
  open c1;
  fetch c1 into rows;
  if c1%FOUND then
    dbms_output.put_line('Found');
  elsif c1%NOTFOUND then
    dbms_output.put_line('Not Found');
  END IF;
  close c1;
END;
/

rem 2. On a given date, find the number of items sold (Use Implicit cursor).
declare
  counter number(2);
  buy_date varchar2(20);
begin
  buy_date:='&date';
  select count(*) into counter from receipts r
  join item_list i on(i.rno = r.rno)
  where r.rdate = buy_date;
  dbms_output.put_line('Number of items sold on '|| buy_date ' are = ' || counter);
end;
/
