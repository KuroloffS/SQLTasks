drop table if exists orders;
create table orders (
	order_id int,
	customer_name nvarchar(55),
	order_date date, 
	constraint PK_Person primary key (order_id)
);

alter table orders
drop constraint PK_Person;

alter table orders
add primary key (orders_id);

select * from orders;