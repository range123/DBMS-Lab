drop table employee_payroll;
create table employee_payroll(
eid number(6) constraint eid_pk primary key,
ename varchar2(30),
dob date,
sex char,
designation varchar2(30),
basic number(10,2),
da number(10,2),
hra number(10,2),
pf number(10,2),
mc number(10,2),
gross number(10,2),
tot_deduc number(10,2),
netpay number(10,2)
);
insert into employee_payroll(eid,ename,dob,sex,designation,basic) values(11111,'PJK','13-aug-2000','M','Manager',20000);
create or replace procedure cal_pay(eno employee_payroll.eid%type,bas in employee_payroll.basic%type)
is
rows employee_payroll%rowtype;

begin
	rows.basic :=bas;
	rows.da := 0.6*bas;
	rows.hra := 0.11*bas;
	rows.pf := 0.04*bas;
	rows.mc := 0.03*bas;
	rows.gross := bas+rows.da+rows.hra;
	rows.tot_deduc := rows.pf + rows.mc;
	rows.netpay := rows.gross - rows.tot_deduc;

	update employee_payroll
	set da = rows.da,hra = rows.hra,pf = rows.pf,
	mc = rows.mc,gross = rows.gross,tot_deduc = rows.tot_deduc,
	netpay = rows.netpay
	where eid = eno;
end;
/


