# SQL Templar 0.1 - light weight, language-agnostic, backend-agnostic parameterized queries

**SQL Templar** is SQL Template + Moustache + (some) conditional logic


`sql.template` provides a light weight, language-agnostic, server-agnostic 
method for building parameterizaed queries.  It allows some minimal logic.


sqltemplar


## Example(s)

Some basic examples showing SQL Templar abilities

    SELECT *
    FROM CUSTOMER
    WHERE CUSTOMER.AGE >= 21
    
SQL Templar passes simple queries unaltered
    
    SELECT *
    FROM CUSTOMER
    WHERE CUSTOMER.AGE >={{AGE}}
    
Values in {{expr}} are evaluated in the defined scope. The variable 
    
    SELECT *
    FROM CUSTOMER
    --! : WHERE CUSTOMER.AGE >= {{age}}
    --! : AGE: WHERE CUSTOMER.AGE >= {{age}}
    
Special comments allow denoted by `--!:` are activated, interpre     
    
    #
    customer = TRUE
    SELECT *
    FROM CUSTOMER
    --!customer: WHERE CUSTOMER.AGE >= 18
       
    #
    customer = TRUE
    age = 18
    SELECT *
    FROM CUSTOMER
    --!customer: WHERE CUSTOMER.AGE >= {{age}}


## Features 

 - Language agnostic (i.e. sharable by many languages)
 - Backend/server agnostic
 - Light-weight
 - Works for all SQL Statements: `SELECT`, `INSERT`, `DELETE`, `REPLACE`, ....
 - Simple ... using it in 5min or less.  
 -   

## Ports 

SQL Templar has been ported to the following languages

 - [R](https://cran.r-project.org/package=sql.templar)
 - [Python]()
 
 
    
## How it works

SQL Templar works by de/activating individual lines from otherwise valid SQL 
statements. 


## Justification 

There are many situations in which SQL queries vary only slightly from various
aspects of a software application. These multiple queries are supported in 
various ways, one


    
## Standards

 * whisker parameters are respected
 * `--! :` comment is uncommented if all whisker parameters are present
 * `--!logic`:  

...
```

tag


## See Also 

The *dplyr* packages provides and automated way of building SQL -- but that SQL 
is generally generic and requires specific backend drivers.

## TODO 

- Find a good name: SQL, Mustache, SQLstache
