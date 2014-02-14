drop user 'dim'@'%';
drop user dim@localhost;
drop user dim;
create user 'dim'@'localhost' identified by 'dimitri';
create user 'dim'@'%' identified by 'dimitri';
grant all on *.* to 'dim'@'localhost' with grant option;
grant all on *.* to 'dim'@'%' with grant option;
flush privileges;
