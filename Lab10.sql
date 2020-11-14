use salesshort;

delimiter //

create function days_since_shipped (shippedDate date, orderDate date) RETURNS int(3)
deterministic
Begin
		declare ship_diff int (3);
        set ship_diff = datediff(shippedDate, orderDate);
Return (ship_diff);
END //

delimiter ;

select orderNumber, orderDate, shippedDate, days_since_shipped(shippedDate, orderDate) as days_since_shipped
from orders
where status = "Shipped";

delimiter //

create function line_revenue (quantity int, price dec(10,2)) RETURNS dec(10,2)
deterministic
Begin
		declare revenue dec(10,2);
        set revenue = quantity * price;
Return (revenue);
END //

delimiter ;

select *, quantityOrdered*priceEach, line_revenue(quantityOrdered, priceEach)
from orderdetails;

delimiter //

create function sales_type (qty int, bp dec(10,2), MSRP dec(10,2), pe dec(10,2)) RETURNS varchar(20)
    Deterministic
    Begin
		Declare sales_type varchar(20);
        CASE
			WHEN (qty * pe)-(qty*bp) <= 0 THEN SET sales_type = "we are loosing money";
            WHEN ((qty * MSRP)-(qty*bp)) - ((qty * pe)-(qty*bp)) > 1000 THEN
				SET sales_type = 'bad sale';
			ELSE SET sales_type = 'good sale';
            END CASE;
	RETURN (sales_type);
    END //

delimiter ;


select sales_type(quantityOrdered, buyPrice, MSRP, priceEach) as sales_cat,
count(sales_type(quantityOrdered, buyPrice, MSRP, priceEach)),
count(sales_type(quantityOrdered, buyPrice, MSRP, priceEach)) / 
	(select count(*)
		from orderDetails
		join products using(productCode)) * 100 pct_total
from orderDetails
join products using(productCode)
group by sales_type(quantityOrdered, buyPrice, MSRP, priceEach);


	