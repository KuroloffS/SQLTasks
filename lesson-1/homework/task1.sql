drop table if exists student; 
create table student (
	id int,
	name varchar(100) NULL,
	age int NULL
);

select * from student

alter table student 
alter column id int NOT NULL;