rem 1. For the given receipt number, if there are no rows then display as “No order with the
rem given receipt <number>”. If the receipt contains more than one item, display as
rem “The given receipt <number> contains more than one item”. If the receipt contains
rem single item, display as “The given receipt <number> contains exactly one item”. Use
rem predefined exception handling.
declare
  rows item_list%rowtype;
  rnum receipts.rno%type;
begin
  rnum :=&rno;
  select * into rows
  from item_list
  where rno = rnum;
  if SQL%rowcount =1 then
    dbms_output.put_line('The given receipt '|| to_char(rnum)||' has exactly one item');
  end if;
exception
  when no_data_found then
    dbms_output.put_line('The given receipt '|| to_char(rnum)||' has no orders');
  when too_many_rows then
    dbms_output.put_line('The given receipt '|| to_char(rnum)||' contains more than one item');
end;
/
rem 121 17947 21040
