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


CALL cust_type(15, @custype);
select @custype;