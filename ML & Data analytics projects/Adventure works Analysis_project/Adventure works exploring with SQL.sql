use AdventureWorks2022

select * from Production.Product

select * from Sales.SalesOrderDetail

select * from Sales.SalesOrderHeader

-------------------------------------------------------------------------------------------
-- sold product 
with sold_products as( select p.Name ,
                              sum(s.OrderQty) as totalQty,
                              round(SUM(s.UnitPrice * s.OrderQty),2) as revenue 
                       from Sales.SalesOrderDetail s inner join Production.Product p 
                       on s.ProductID = p.ProductID 
                       GROUP BY p.Name
                       )

select * from sold_products

select Name ,totalQty ,revenue from sold_products order by totalQty desc

------------------------------------------------------------------------
-- products not sold
with products_not_sold as (select p.Name ,sum(s.OrderQty) as totalqty 
    from Sales.SalesOrderDetail s right JOIN Production.Product p 
    on s.ProductID = p.ProductID
    GROUP by p.Name
    having sum(s.OrderQty) is null)


select * from products_not_sold
--------------------------------------------------------------------------
select * from Person.Address
select * from Sales.SalesOrderHeader
select * from HumanResources.Employee

-- cities of customers
select city from Person.Address p join Sales.SalesOrderHeader s
on p.AddressID = s.BillToAddressID

-- cities of employees
select city from Person.Address p join HumanResources.Employee h 
on p.AddressID = h.BusinessEntityID

-- onion
select city from Person.Address p join Sales.SalesOrderHeader s
on p.AddressID = s.BillToAddressID

union

select city from Person.Address p join HumanResources.Employee h 
on p.AddressID = h.BusinessEntityID

-----------------------------------------------------------
-----------------------------------------------------------
-- count of products
select count(*) from Production.Product 
-----------------------------------------------------------
-- count of sold products

select count(distinct p.Name) as count_of_sold_products from Production.Product p INNER JOIN Sales.SalesOrderDetail s 
on p.ProductID = s.ProductID

SELECT COUNT(DISTINCT ProductID) AS UniqueSoldProducts 
FROM Sales.SalesOrderDetail
-------------------------------------------------------------
-- top 5 of qty
select top 5 p.Name, sum(s.OrderQty) as total_qty from Production.Product p INNER JOIN Sales.SalesOrderDetail s 
on p.ProductID = s.ProductID
GROUP by p.Name
ORDER by total_qty DESC
-----------------------------------------------------------------
-- top 5 of total line
select top 5 p.Name, sum(s.LineTotal) as total_line from Production.Product p INNER JOIN Sales.SalesOrderDetail s 
on p.ProductID = s.ProductID
GROUP by p.Name
ORDER by total_line DESC
------------------------------------------------------------------
-- avg of unitPrice of all products
select avg(s.UnitPrice) as avg_price from Production.Product p INNER JOIN Sales.SalesOrderDetail s 
on p.ProductID = s.ProductID

---------------------------------------------------------------------
---------------------------------------------------------------------
-- total revenue of categories
select 
        p2.Name,  
        cast(sum(s.LineTotal) as int) as revenue
from Sales.SalesOrderDetail s 
        INNER join Production.Product p on s.ProductID = p.ProductID
        inner join Production.ProductSubcategory p1 on p.ProductSubcategoryID = p1.ProductSubcategoryID
        left join Production.ProductCategory p2 on p1.ProductCategoryID = p2.ProductCategoryID
GROUP by p2.Name
ORDER by revenue DESC
--------------------------------------------------------------------------------
-- total profit of categories
select 
        p2.Name,
        cast(sum(s.LineTotal) as int) as revenue,
        cast(sum(s.LineTotal - s.OrderQty * p.StandardCost) as int) as profit
from Sales.SalesOrderDetail s 
        INNER join Production.Product p on s.ProductID = p.ProductID
        inner join Production.ProductSubcategory p1 on p.ProductSubcategoryID = p1.ProductSubcategoryID
        left join Production.ProductCategory p2 on p1.ProductCategoryID = p2.ProductCategoryID
GROUP by p2.Name
ORDER by profit DESC
----------------------------------------------------------------------------------
-- Year by revenue
SELECT * from Sales.SalesOrderDetail
SELECT * from Sales.SalesOrderHeader

select 
        YEAR(h.OrderDate), 
        cast(sum(d.LineTotal) as int) as revenue
from Sales.SalesOrderDetail d inner join Sales.SalesOrderHeader h 
on d.SalesOrderID = h.SalesOrderID
GROUP by YEAR(h.OrderDate)
order by revenue desc

----------------------------------------------------------------------------------
-- unsold products
SELECT * from Sales.SalesOrderDetail
SELECT * from Production.Product

select p.Name
from Production.Product p left JOIN Sales.SalesOrderDetail s 
on p.ProductID = s.ProductID
WHERE s.ProductID is null
GROUP by p.Name

-- count of unsold products
select count(p.Name)
from Production.Product p left JOIN Sales.SalesOrderDetail s 
on p.ProductID = s.ProductID
where s.ProductID is null



select * from Sales.





