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
