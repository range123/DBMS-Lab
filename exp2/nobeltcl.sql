rem 11.Mark an intermediate point in the transaction (savepoint).
savepoint intermed;

rem 12.Insert a new tuple into the nobel relation.
insert into nobel
values(140,'Vinod','m','Phy','Quantum Computing',2000,'SSN University','27-apr-2003','India');

rem 13.Update the aff_role of literature laureates as 'Linguists'.
rem before update
select * 
from nobel
where category = 'Lit';

update nobel
set aff_role = 'Linguists'
where category = 'Lit';

rem after update
select * 
from nobel
where category = 'Lit';

rem 14.Delete the laureate(s) who was awarded in Enzymes field.
delete from nobel
where field = 'Enzymes';

rem 15.Discard the most recent update operations (rollback).
rem before rollback
select * 
from nobel
where field = 'Enzymes';
rollback to intermed;
rem after rollback
select * 
from nobel
where field = 'Enzymes';

rem 16.Commit the changes.
commit;