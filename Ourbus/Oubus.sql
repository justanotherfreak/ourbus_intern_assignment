-- Create table orders
CREATE TABLE orders (
Order_no VARCHAR(10), 
Order_id INT,
Order_time VARCHAR(30),
Pick_up_time VARCHAR(10),
Drop_down_time VARCHAR(10), 
Pick_stop INT,
Drop_stop INT,
Travel_date DATE,
Gross_sale FLOAT,
Net_sale FLOAT,
Is_cancelled BOOL,
Cancellation_reason VARCHAR(50),
Trip_id INT);

-- Load data into table orders
LOAD DATA LOCAL INFILE '/home/db/Downloads/Order.csv' INTO TABLE orders FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- create table trips
CREATE TABLE trips ( Trip_id INT,
Route_id INT,
Transport_provider INT,
Trip_date DATE,
Trip_status VARCHAR(10));

-- load data into table trips
LOAD DATA LOCAL INFILE '/home/db/Downloads/Trips.csv' INTO TABLE trips FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- Question 1 : avg. no of days tickets booked before travel 
Select avg(datediff(date(travel_date), date(order_time))) from orders;

-- Question 2 : Distribution of passenges by departure time and route_id
Select a.pick_up_time, b.route_id, count(a.order_id) from orders a left join trips b on a.trip_id = b.trip_id group by a.pick_up_time, b.route_id;

-- Question 3 : No of orders with 2 order_ids stop combination wise

-- First count the no of order_ids for each order_no
Create temporary table order_count as Select count(order_id) as co, order_no from orders group by order_no;

/* Joining the two tables, total no. of desired order_no. Grouping has been done by order_no, pick_stop and dropstop
so as to see if there is any order_no with two order_ids having same pick_stop and drop_stop. This is so that such order is 
not counted twice for a particular drop combination */
Create temporary table newt as 
Select sum( case when co = 2 then 1 else 0 end) as dup_order, pick_stop,drop_stop,order_no 
from orders a left join order_count b on a.order_no = b.order_no 
group by pick_stop, drop_stop, order_no;

-- Filter so that a order no. having same drop combination is not counted twice
Select sum(case when dup_order > 0 then 1 else 0 end) as order_cou, pick_stop, drop_stop from newt group by pick_stop,drop_stop;


-- Question 4: no of complete for different stop combinations
Select a.pick_stop, a.drop_stop, count(DISTINCT a.trip_id) from orders a left join trips b on a.trip_id = b.trip_id where b.trip_status="COMPLETED" group by a.pick_stop, a.drop_stop;


-- Question 5: Some observations
/* 
1. Adults column is missing(intead of it Timestamp column is there). Therefore, the assignment is done assuming
   tickets are booked for 1 passenger for each ticket_id
1. Orders.csv contains Ourbus ticket orders from 1st August 2019 to 29th August 2019
2. Trips.csv doesn't contains data for all trip_ids. Some trip_ids are in Orders.csv but not in Trips.csv.






