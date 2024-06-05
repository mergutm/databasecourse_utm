# Profiling

*El análisis de rendimiento o profiling* es un proceso de evaluación y optimización que busca identificar y resolver los cuellos de botella y las ineficiencias que afectan la rapidez y eficacia de las operaciones de la base de datos. 
Mediante el uso de diversas herramientas y técnicas, se examinan las consultas, el uso de índices, las configuraciones del servidor y otros factores que influyen en el desempeño del sistema. 


## Ejemplo de consulta 

```sql
SELECT c.CustomerID, c.CustomerName, c.Email, 
       s.SaleID, s.SaleDate, s.TotalAmount,
       si.Quantity, si.Price as Price_vta,
       p.ProductID, p.ProductName, p.Price as Price_db
FROM   Customers as c, Products as p, SaleItems as si, Sales as s
WHERE  s.CustomerID = c.CustomerID 
       AND si.SaleID = s.SaleID
       AND si.ProductID = p.ProductID      
```


##  Tabla de salida


 |   CustomerID |  CustomerName |  Email |  SaleID |  SaleDate |  TotalAmount |  Quantity |  Price_vta |  ProductID |  ProductName |  Price_db  | 
 |  --------- |  --------- |  --------- |  --------- |  --------- |  --------- |  --------- |  --------- |  --------- |  --------- |  ---------  | 
 |   103 |  Bob Johnson |  bob@example.com |  3.0 |  2024-06-03 |  60.0 |  3.0 |  10.0 |  1.0 |  Widget A |  10.0  | 
 |   101 |  John Doe |  john@example.com |  1.0 |  2024-06-01 |  32.5 |  2.0 |  10.0 |  1.0 |  Widget A |  10.0  | 
 |   103 |  Bob Johnson |  bob@example.com |  3.0 |  2024-06-03 |  60.0 |  2.0 |  15.0 |  2.0 |  Gadget B |  15.0  | 
 |   102 |  Jane Smith |  jane@example.com |  2.0 |  2024-06-02 |  15.0 |  1.0 |  15.0 |  2.0 |  Gadget B |  15.0  | 
 |   101 |  John Doe |  john@example.com |  4.0 |  2024-06-04 |  40.0 |  1.0 |  15.0 |  2.0 |  Gadget B |  15.0  | 
 |   104 |  Alice Brown |  alice@example.com |  5.0 |  2024-06-05 |  12.5 |  1.0 |  12.5 |  3.0 |  Widget C |  12.5  | 
 |   101 |  John Doe |  john@example.com |  4.0 |  2024-06-04 |  40.0 |  2.0 |  12.5 |  3.0 |  Widget C |  12.5  | 
 |   101 |  John Doe |  john@example.com |  1.0 |  2024-06-01 |  32.5 |  1.0 |  12.5 |  3.0 |  Widget C |  12.5  | 



## Ejemplo de benchmark 

```sql
SELECT BENCHMARK (100000000,
      (SELECT count(*) AS cc
       FROM   (
              SELECT c.CustomerID, c.CustomerName, c.Email, 
                     s.SaleID, s.SaleDate, s.TotalAmount,
                     si.Quantity, si.Price as Price_vta,
                     p.ProductID, p.ProductName, p.Price as Price_db
              FROM   Customers as c, Products as p, SaleItems as si, Sales as s
              WHERE  s.CustomerID = c.CustomerID 
                     AND si.SaleID = s.SaleID
                     AND si.ProductID = p.ProductID         
       ) AS tmp
	)
)
```
