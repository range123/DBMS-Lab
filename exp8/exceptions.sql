rem 1. For the given receipt number, if there are no rows then display as �No order with the
rem given receipt <number>�. If the receipt contains more than one item, display as
rem �The given receipt <number> contains more than one item�. If the receipt contains
rem single item, display as �The given receipt <number> contains exactly one item�. Use
rem predefined exception handling.
create or replace procedure exp1(rnum in receipts.rno%type)
Is
  rows item_list%rowtype;
  one_row exception;
begin
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
call exp1(121);
call exp1(17947);
call exp1(21040);
rem 121 17947 21040

rem 2. While inserting the receipt details, raise an exception when the receipt date is greater
rem than the current date.
create or replace procedure dt1(rnum in receipts.rno%type,rdt in receipts.rdate%type,cno in receipts.cid%type)
is
 curr_date date;
 rows receipts%rowtype;
 invalid_date_exception exception;
begin
  select sysdate into curr_date from dual;
  rows.rno  := rnum;
  rows.rdate := rdt;
  rows.cid := cno;
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
call dt1(121,'24-dec-2020',5);
call dt1(121,'12-dec-2000',5);
select * from receipts where rno = 121;
