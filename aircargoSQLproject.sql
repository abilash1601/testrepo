create database aircargo;
use aircargo;
create table route_details1(
route_id int primary key,
flight_num int,
origin_airport varchar(50),
destination_airport varchar(50),
aircraft_id varchar(50),
distance_miles int check(distance_miles>0));

drop table route_details;

select c.customer_id,concat(c.first_name,c.last_name),pa.route_id from passengers_on_flights as pa inner join customer as c on pa.customer_id=c.customer_id where route_id between 1 and 25;

select count(customer_id),sum(price_per_ticket) from ticket_details where class_id like '%bussiness%';

select concat(first_name,' ',last_name) as 'name of customer' from customer;

select * from customer inner join ticket_details using(customer_id); 

  select c.* from customer c join ticket_details t on c.customer_id=t.customer_id; 
  # use "[aliasname].* from" if you need details of just one table while joining
  
  select c.customer_id,c.first_name,c.last_name,t.brand from ticket_details t join customer c on t.customer_id=c.customer_id
  where brand like '%emirates%';
  
  select count(*),customer_id from passengers_on_flights where class_id='economy plus' group by customer_id  ;
  
  select if(sum(price_per_ticket*no_of_tickets)>10000,'yes','no') as revenue from ticket_details ;
  
  CREATE USER 'new_user'@'localhost' IDENTIFIED BY 'password';
  GRANT ALL PRIVILEGES ON database_name.* TO 'new_user'@'localhost';
  
  select class_id, max(price_per_ticket) over(partition by class_id) as maxprice from ticket_details ;
  
 create index route on passengers_on_flights(route_id);
 select * from passengers_on_flights where route_id=4;
 
 explain select * from passengers_on_flights where route_id=4;
 select * from ticket_details;
 
SELECT customer_id, aircraft_id, 
       SUM(price_per_ticket * no_of_tickets) as totalprice
FROM ticket_details
GROUP BY  customer_id, aircraft_id with rollup;

create view brand as select customer_id,class_id,brand from ticket_details where class_id like '%bussiness%';
select * from brand;

delimiter :
CREATE PROCEDURE GetPassengersByRoutes(min_route INT, max_route INT)
BEGIN 
SELECT * FROM passengers_on_flights WHERE route_id BETWEEN min_route AND max_route;
END :
DELIMITER ;

call getpassengersbyroutes(10,40);

delimiter :
create procedure getdistance()
begin
select * from routes where distance_miles > 2000;
end:

call getdistance()
delimiter :
create procedure getnewdistance2()
begin
select route_id,flight_num,distance_miles,
case 
when distance_miles>=0 and distance_miles <=2000 then 'short travel distance'
when distance_miles>2000 and distance_miles<=6500 then 'intermiate travel distance'
when distance_miles>=6500 then 'long distance travel'
end as 'distance travel'
 from routes;
end:
delimiter ;
call getnewdistance2();


drop procedure if exists getnewdistance;



DELIMITER //

CREATE FUNCTION CheckComplimentaryServices(class_id VARCHAR(50)) 
RETURNS VARCHAR(3)
DETERMINISTIC
BEGIN
    DECLARE result VARCHAR(3);
    
    IF class_id IN ('Business', 'Economy Plus') THEN
        SET result = 'Yes';
    ELSE
        SET result = 'No';
    END IF;
    
    RETURN result;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE GetTicketDetailsWithComplimentaryServices()
BEGIN
    SELECT 
        p_date,
        customer_id,
        class_id,
        CheckComplimentaryServices(class_id) AS complimentary_services
    FROM 
        ticket_details;
END //

DELIMITER ;

call GetTicketDetailsWithComplimentaryServices();

DELIMITER //

CREATE PROCEDURE GetFirstCustomerWithLastNameScott3()
BEGIN
    DECLARE done INT DEFAULT 0;
    DECLARE customer_id INT;
    DECLARE first_name VARCHAR(50);
    DECLARE last_name VARCHAR(50);
     -- Adjust based on your table structure

    -- Declare a cursor to select customers whose last name ends with "Scott"
    DECLARE cur CURSOR FOR
        SELECT customer_id, first_name, last_name -- Replace other_columns with actual columns
        FROM customer
        WHERE last_name LIKE '%scott%';

    -- Declare a handler for when no more rows are found
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Open the cursor
    OPEN cur;

    -- Fetch the first record
    FETCH cur INTO customer_id, first_name, last_name;

    -- Check if a record was found
    IF done = 0 THEN
        -- Return the first matching record
        SELECT customer_id, first_name, last_name;
    ELSE
        -- No record found
        SELECT 'No customer found with last name ending with "Scott".' AS message;
    END IF;

    -- Close the cursor
    CLOSE cur;
END //

DELIMITER ;
 call GetFirstCustomerWithLastNameScott3();


select * from customer where last_name like '%scott%';
