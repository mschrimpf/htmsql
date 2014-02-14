use performance_schema;

update setup_consumers set enabled = 'no';
update setup_consumers set enabled = 'yes' where name like '%instr%';
-- update setup_consumers set enabled = 'yes' where name like '%waits%curr%';
update setup_instruments set enabled = 'no', timed = 'no';
update setup_instruments set enabled = 'yes', timed = 'yes' where name like '%wait/synch%';


