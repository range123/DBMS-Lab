SQL> @exp2/nobelquery.sql
SQL> rem 1. Display the nobel laureate(s) who born after 1Jul1960.
SQL> select *
  2  from nobel
  3  where dob>'1-jul-1960';

LAUREATE_ID NAME                           G CAT FIELD                     YEAR_AWARD               
----------- ------------------------------ - --- ------------------------- ----------               
AFF_ROLE                       DOB       COUNTRY                                                    
------------------------------ --------- ----------                                                 
        111 Eric A Cornell                 m Phy Atomic physics                  2001               
University of Colorado         19-DEC-61 USA                                                        
                                                                                                    
        124 Carol W Greider                f Med Enzymes                         2009               
Johns Hopkins University       15-APR-61 USA                                                        
                                                                                                    
        125 Barack H Obama                 m Pea World organizing                2009               
President of USA               04-AUG-61 USA                                                        
                                                                                                    

SQL> 
SQL> rem 2.Display the Indian laureate (name, category, field, country, year awarded) who was awarded in the Chemistry category.
SQL> select name,category,field,country,year_award
  2  from nobel
  3  where country = 'India' and category = 'Che';

NAME                           CAT FIELD                     COUNTRY    YEAR_AWARD                  
------------------------------ --- ------------------------- ---------- ----------                  
Venkatraman Ramakrishnan       Che Biochemistry              India            2009                  

SQL> 
SQL> rem 3. Display the laureates (name, category,field and year of award) who was awarded between 2000 and 2005 for the Physics or Chemistry category.
SQL> select name,category,field,year_award
  2  from nobel
  3  where year_award between '2000' and '2005' and category in ('Phy','Che');

NAME                           CAT FIELD                     YEAR_AWARD                             
------------------------------ --- ------------------------- ----------                             
Eric A Cornell                 Phy Atomic physics                  2001                             
Carl E Wieman                  Phy Atomic physics                  2001                             
Ryoji Noyori                   Che Organic Chemistry               2001                             
K Barry Sharpless              Che Organic Chemistry               2001                             

SQL> 
SQL> rem 4. Display the laureates name with their age at the time of award for the Peace category.
SQL> select name,year_award - EXTRACT(year from dob) as "age"
  2  from nobel
  3  where category = 'Pea';

NAME                                  age                                                           
------------------------------ ----------                                                           
John Hume                              61                                                           
David Trimble                          54                                                           
Kofi Annan                             63                                                           
Barack H Obama                         48                                                           

SQL> 
SQL> rem 5. Display the laureates (name,category,aff_role,country) whose name starts with A or ends with a, but not from Isreal.
SQL> select name,category,aff_role,country
  2  from nobel
  3  where (name like 'A%' or name like '%a') and country<>'Isreal';

NAME                           CAT AFF_ROLE                       COUNTRY                           
------------------------------ --- ------------------------------ ----------                        
Amartya Sen                    Eco Trinity College                India                             
Barack H Obama                 Pea President of USA               USA                               

SQL> 
SQL> rem 6. Display the name, gender, affiliation, dob and country of laureates who was born in 1950's.Label the dob column as Born 1950.
SQL> select name,gender,aff_role,dob as "Born 1950",country
  2  from nobel
  3  where EXTRACT(year from dob) between 1950 and 1960;

NAME                           G AFF_ROLE                       Born 1950 COUNTRY                   
------------------------------ - ------------------------------ --------- ----------                
Robert B. Laughlin             m Stanford University            01-NOV-50 USA                       
Carl E Wieman                  m University of Colorado         26-MAR-51 USA                       
Venkatraman Ramakrishnan       m MRC Laboratory                 19-AUG-52 India                     
Herta Muller                   f                                17-AUG-53 Romania                   

SQL> rem 7. Display the laureates (name,gender,category,aff_role,country) whose name starts with A, D or H. Remove the laureate if he/she do not have any affiliation. Sort the results in ascending order of name.
SQL> select name,gender,category,aff_role,country
  2  from nobel
  3  where aff_role is not null and substr(name,1,1) in ('A','D','H')
  4  order by name;

NAME                           G CAT AFF_ROLE                       COUNTRY                         
------------------------------ - --- ------------------------------ ----------                      
Ada E Yonath                   f Che Weizmann Institute of Science  Isreal                          
Amartya Sen                    m Eco Trinity College                India                           
Daniel C. Tsui                 m Phy Princeton University           China                           
David Trimble                  m Pea Ulster Unionist party Leader   Ireland                         
Horst L Stormer                m Phy Columbia University            Germany                         

SQL> rem 8. Display the university name(s) that has to its credit by having at least 2 nobel laureate with them.
SQL> select aff_role,count(aff_role)
  2  from nobel
  3  where aff_role like 'University%'
  4  group by aff_role
  5  having count(aff_role)>=2;

AFF_ROLE                       COUNT(AFF_ROLE)                                                      
------------------------------ ---------------                                                      
University of California                     5                                                      
University of Colorado                       2                                                      

SQL> rem 9. List the date of birth of youngest and eldest laureates by countrywise. Label the column as Younger, Elder respectively. Include only the country having more than one laureate. Sort the output in alphabetical order of country.
SQL> select country,min(dob) as "elder" ,max(dob) as "younger"
  2  from nobel
  3  group by country
  4  having count(country)>1
  5  order by country;

COUNTRY    elder     younger                                                                        
---------- --------- ---------                                                                      
China      04-NOV-33 28-FEB-39                                                                      
India      03-NOV-33 19-AUG-52                                                                      
Ireland    18-JAN-37 15-OCT-44                                                                      
UK         31-OCT-25 17-AUG-32                                                                      
USA        10-MAY-30 19-DEC-61                                                                      

SQL> rem 10. Show the details (year award,category,field) where the award is shared among the laureates in the same category and field. Exclude the laureates from USA.
SQL> select year_award,category,field
  2  from nobel
  3  where country<>'USA'
  4  group by (year_award,category,field)
  5  having count(*)>1;

YEAR_AWARD CAT FIELD                                                                                
---------- --- -------------------------                                                            
      2009 Che Biochemistry                                                                         
      1998 Che Theoretical Chemistry                                                                
      1998 Phy Condensed matter                                                                     
      1998 Pea Negotiation                                                                          

SQL> @exp2/nobeltcl.sql
SQL> rem 11.Mark an intermediate point in the transaction (savepoint).
SQL> savepoint intermed;

Savepoint created.

SQL> 
SQL> rem 12.Insert a new tuple into the nobel relation.
SQL> insert into nobel
  2  values(140,'Vinod','m','Phy','Quantum Computing',2000,'SSN University','27-apr-2003','India');

1 row created.

SQL> 
SQL> rem 13.Update the aff_role of literature laureates as 'Linguists'.
SQL> rem before update
SQL> select *
  2  from nobel
  3  where category = 'Lit';

LAUREATE_ID NAME                           G CAT FIELD                     YEAR_AWARD               
----------- ------------------------------ - --- ------------------------- ----------               
AFF_ROLE                       DOB       COUNTRY                                                    
------------------------------ --------- ----------                                                 
        110 Jose Saramago                  m Lit Portuguese                      1998               
                               16-NOV-22 Portugal                                                   
                                                                                                    
        117 V S Naipaul                    m Lit English                         2001               
                               17-AUG-32 UK                                                         
                                                                                                    
        128 Herta Muller                   f Lit German                          2009               
                               17-AUG-53 Romania                                                    
                                                                                                    

SQL> 
SQL> update nobel
  2  set aff_role = 'Linguists'
  3  where category = 'Lit';

3 rows updated.

SQL> 
SQL> rem after update
SQL> select *
  2  from nobel
  3  where category = 'Lit';

LAUREATE_ID NAME                           G CAT FIELD                     YEAR_AWARD               
----------- ------------------------------ - --- ------------------------- ----------               
AFF_ROLE                       DOB       COUNTRY                                                    
------------------------------ --------- ----------                                                 
        110 Jose Saramago                  m Lit Portuguese                      1998               
Linguists                      16-NOV-22 Portugal                                                   
                                                                                                    
        117 V S Naipaul                    m Lit English                         2001               
Linguists                      17-AUG-32 UK                                                         
                                                                                                    
        128 Herta Muller                   f Lit German                          2009               
Linguists                      17-AUG-53 Romania                                                    
                                                                                                    

SQL> 
SQL> rem 14.Delete the laureate(s) who was awarded in Enzymes field.
SQL> delete from nobel
  2  where field = 'Enzymes';

2 rows deleted.

SQL> 
SQL> rem 15.Discard the most recent update operations (rollback).
SQL> rem before rollback
SQL> select *
  2  from nobel
  3  where field = 'Enzymes';

no rows selected

SQL> rollback to intermed;

Rollback complete.

SQL> rem after rollback
SQL> select *
  2  from nobel
  3  where field = 'Enzymes';

LAUREATE_ID NAME                           G CAT FIELD                     YEAR_AWARD               
----------- ------------------------------ - --- ------------------------- ----------               
AFF_ROLE                       DOB       COUNTRY                                                    
------------------------------ --------- ----------                                                 
        123 Elizabeth H Blackburn          f Med Enzymes                         2009               
University of California       26-NOV-48 Australia                                                  
                                                                                                    
        124 Carol W Greider                f Med Enzymes                         2009               
Johns Hopkins University       15-APR-61 USA                                                        
                                                                                                    

SQL> 
SQL> rem 16.Commit the changes.
SQL> commit;

Commit complete.

SQL> spool off;
