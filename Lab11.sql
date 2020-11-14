DELIMITER //

create procedure orderTotal (IN ordernum INT, OUT Total INT)
BEGIN
	select sum(quantityOrdered * priceEach)
    INTO Total
    from orderdetails
    where orderNumber = ordernum
    group by orderNumber;
    
END //
DELIMITER ;

CALL orderTotal(10100, @Total);

select @Total as order_total;

DELIMITER //

create procedure gbSaleP (IN ordernum INT, OUT result varchar(20))
BEGIN
	declare act_profit int;
    declare po_profit int;
	select
	SUM(quantityOrdered*MSRP - quantityOrdered * buyPrice) INTO po_profit
	from orderDetails
	join orders using(orderNumber)
	join products using(productCode)
    where orderNumber = ordernum
	group by orderNumber;
    
    select
    SUM(quantityOrdered*priceEach - quantityOrdered * buyPrice) INTO act_profit
	from orderDetails
	join orders using(orderNumber)
	join products using(productCode)
    where orderNumber = ordernum
	group by orderNumber;
    
    IF act_profit <= 0 THEN set result = "we are loosing money";
    ELSEIF (po_profit - act_profit) < 2500 THEN set result = "good sale";
    ELSE set result = "bad sale";
    END IF;
END //
DELIMITER ;

CALL gbSaleP(10408, @result);
select @result;

CALL gbSaleP(10421, @result);
select @result;

CALL gbSaleP(10212, @result);
select @result;