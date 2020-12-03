use _team25_dispo;

#stored function that defines tiers of product by potentcy

DELIMITER //

create function tier (potent varchar(3)) returns varchar(20)
deterministic
Begin
Declare tier varchar(20);
    CASE
		when CAST(potent as dec) > 20 THEN SET tier = "Dankness";
        when CAST(potent as dec) > 15 THEN SET tier = "Your dad's ish";
        else SET tier = "Shake";
	END CASE;
RETURN (tier);
END //

DELIMITER ;


#Find the tiers for our current products using the stored tier function
select ProductName, tier(Potency)
from product as p
join productdetails as pd on pd.Product_ProductID = p.ProductID;

#Stored function to calculate profit

DELIMITER //

create function profit (qty double, sprice double, vprice double) RETURNS dec(10,2)
deterministic
Begin
		declare profit dec(10,2);
        set profit = qty * sprice - vprice;
Return (profit);
END //

DELIMITER ;

#Find the profit by transaction and order by most profitable using stored profit function
select TransactionID, SUM(profit(QuantityPurchased, SalePrice, VendorPrice)) as profit
from product as p
join transactiondetails as td on td.Product_ProductID = p.ProductID
join transactions as t on t.TransactionID = td.Transactions_TransactionID
group by TransactionID
order by 2 DESC;

#stored procedure in which you enter a customer number and returns if the customer is rec or med.

DELIMITER //

create procedure cust_type (IN custnum INT, OUT custype varchar(5))
BEGIN
	select ct.TypeChar
    INTO custype
	from customers as c
	join custtype as ct on ct.TypeInt = c.CustType_TypeInt
    where CustomerID = custnum;
END //
DELIMITER ;

#Determine if customer 15 is a med or rec customer

CALL cust_type(15, @custype);
select @custype;

								#Create trigger to update customer audit table with a update
Delimiter $$

CREATE TRIGGER cust_upd_old
after update on customers
for each row
	Begin
		insert into cust_audit(when_updated,CustomerID, CustomerName, 
						Email, Phone, custType, DoctorID,
                        who_updated, row_value)
		values(curdate(), old.CustomerID, old.CustomerName, 
						old.Email, old.Phone,
						old.custType_TypeInt, old.Doctor_DoctorID,
                        current_user(),'old info');
	End $$
    
Delimiter ;

Delimiter $$

CREATE TRIGGER cust_upd_new
after update on customers
for each row
follows cust_upd_old
	Begin
		insert into cust_audit(when_updated,CustomerID, CustomerName, 
						Email, Phone, custType, DoctorID,
                        who_updated, row_value)
		values(curdate(), new.CustomerID, new.CustomerName, 
						new.Email, new.Phone,
						new.custType_TypeInt, new.Doctor_DoctorID,
                        current_user(),'New info');
	End $$
    
Delimiter ;

	
update customers set Doctor_DoctorID = 8 where customerID = 90;

								
#Find the average sale price for each product compared to the total average sale price.
								
select ProductName,Product_ProductID, format(avg(salePrice), 2) as avg_product_sale_price,

format((select avg(salePrice) 
	from transactiondetails),2) as avg_sale

from transactiondetails
join product on transactiondetails.Product_ProductID = product.ProductID
group by Product_ProductID;
				 
#Avg potency per strain
				 
select strain, format(avg(potency),0) as_strain_avg_potency from product
join productdetails on productdetails.Product_ProductID = product.ProductID
group by strain;
				 
#Max potency by strain

select ProductName, Max(Potency)
from (select productName, strain, potency from product
			join productdetails on productdetails.Product_ProductID = product.ProductID
			order by strain, potency desc) as sub
group by Strain;
				 

#min potency by strain
				 
select ProductName, Min(Potency)
from (select productName, strain, potency from product
			join productdetails on productdetails.Product_ProductID = product.ProductID
			order by strain, potency desc) as sub
group by Strain;
				 
				 
				 
								
								
