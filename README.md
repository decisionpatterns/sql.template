# SQL Templar 0.1 - Language-, Server-, Agnostic Template Solutions for SQL Queries

**SQL Templar** is template standard for SQL. It uses mustache + SQL comments 
to implement a lightweight and powerful template solution for SQL.  


`sql.templar` provides a light weight, language-agnostic, implementation-agnostic 
method for building parameterizaed queries.  It allows some minimal logic.

sqltemplar is best demonstrated by some examples.


## Features 

 - Language agnostic (i.e. sharable by many languages)
 - Backend/server agnostic.
 - Light-weight
 - Works for all SQL Statements: `SELECT`, `INSERT`, `DELETE`, `REPLACE`, ....
 - Simple ... using it in 5min or less.  
 - Query reuse. Encourages query reuse and removing queries from  

    
## How it works

SQL Templar works by de/activating individual lines from otherwise valid SQL 
statements. 


## Justification 

There are many situations in which SQL queries vary only slightly from various
aspects of a software application. These multiple queries are supported in 
various ways, one


## Example(s)

Some basic examples showing SQL Templar abilities:

### Standard SQL is unchanged 

    SELECT *
    FROM CUSTOMER
    WHERE CUSTOMER.AGE >= 21
    
SQL is unchanged. 


### Parameter Substitition: `{{expr}}`

Values in {{expr}} are evaluated in the defined scope. 

    AGE=18
    
    SELECT *
    FROM CUSTOMER
    WHERE CUSTOMER.AGE >={{AGE}}
    
The variable `AGE` is substitued.  If `AGE` is undefined, an error is issued. 


### Conditional Parameter Substitution: `--! :`

Apply line only when variable is evaluated in the defined scope.

    AGE=18 
    
    SELECT *
    FROM CUSTOMER
    --! : WHERE CUSTOMER.AGE >= {{AGE}}
    --! : AGE: WHERE CUSTOMER.AGE >= {{AGE}}
    
Special comments denoted by `--!:` are **activated** when those 
variables/expressions are defined.  Otherwise, the SQL passes unaltered. No 
error is thrown.


### Conditional activation: `--!expr:`

Only activation the line when the `expr` is defined.  The preceeding example
can also be written as this.

    SELECT *
    FROM CUSTOMER
    --!AGE: WHERE CUSTOMER.AGE >= {{AGE}} 


Conditional activation can be based on a different variable than what is used.

    customer = TRUE
    
    SELECT *
    FROM CUSTOMER
    --!customer: WHERE CUSTOMER.AGE >= 18
       

Use conditional activation with conditional 

    customer = TRUE
    age = 18
    
    SELECT *
    FROM CUSTOMER
    --!customer: WHERE CUSTOMER.AGE >= {{age}}


### JOINS Multiple Tables 

SQL Templar can be used for multiple tables by using conditional logic on both
the 


## Standards

 * mustache parameters are respected
 * `--! :` comment is uncommented if all whisker parameters are present
 * `--!logic`:  


## Ports 

SQL Templar has been ported to the following languages

 - [SQL](...)
 - [R](https://cran.r-project.org/package=sql.templar)
 - [Python](...)
 

## See Also 

The *dplyr* packages provides and automated way of building SQL -- but that SQL 
is generally generic and requires specific backend drivers.


