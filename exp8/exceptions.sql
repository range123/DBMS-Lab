rem 1. For the given receipt number, if there are no rows then display as No order with the
rem given receipt <number>. If the receipt contains more than one item, display as
rem The given receipt <number> contains more than one item. If the receipt contains
rem single item, display as The given receipt <number> contains exactly one item. Use
rem predefined exception handling.
declare
  rows item_list%rowtype;
  rnum receipts.rno%type;
  one_row exception;
begin
  rnum :=&rno;
  select * into rows
  from item_list
  where rno = rnum;
  if SQL%rowcount =1 then
    raise one_row;
  end if;
exception
  when no_data_found then
    dbms_output.put_line('The given receipt '|| to_char(rnum)||' has no orders');
  when one_row then
    dbms_output.put_line('The given receipt '|| to_char(rnum)||' has exactly one item');
  when too_many_rows then
    dbms_output.put_line('The given receipt '|| to_char(rnum)||' contains more than one item');
end;
/
rem Use these rnumbers
rem 121 17947 21040

rem 2. While inserting the receipt details, raise an exception when the receipt date is greater
rem than the current date.

declare
 curr_date date;
 rows receipts%rowtype;
 invalid_date_exception exception;
begin
  select sysdate into curr_date from dual;
  rows.rno  := &rno;
  rows.rdate := '&rdate';
  rows.cid := &cid;
  if rows.rdate>curr_date then
    raise invalid_date_exception;
  else
    insert into receipts(rno,rdate,cid) values(rows.rno,rows.rdate,rows.cid);
  end if;
  exception
    when invalid_date_exception then
      dbms_output.put_line('The rdate is greater than the current date!');
      return;
end;
/
