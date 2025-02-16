-- Drop existing tables if they exist
drop table if exists item;
drop table if exists category;

-- Create category table
create table category (
    category_id int primary key,
    category_name nvarchar(100)
);

-- Create item table with foreign key reference
create table item (
    item_id int primary key,
    item_name nvarchar(100),
    category_id int,
    constraint FK_Item foreign key (category_id) references category(category_id)
);

-- Drop foreign key constraint (if needed)
alter table item drop constraint FK_Item;

-- Re-add foreign key constraint
alter table item 
add constraint FK_Item foreign key (category_id) references category(category_id);

-- Select data
select * from category;
select * from item;
