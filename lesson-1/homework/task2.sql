drop table if exists product;
create table product(
	product_id int unique,
	product_name varchar(255),
	price decimal(10, 2)
);

--alter table product 
--drop constraint UQ__product__47027DF40803B592;

alter table product 
add unique(product_id, product_name);

select * from product;