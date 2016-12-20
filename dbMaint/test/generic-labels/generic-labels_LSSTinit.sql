-- First enumerate labelable objects
insert into Labelable (name, tableName, createdBy, creationTS) values ('run', 'RunNumber', 'jrb', UTC_TIMESTAMP());
insert into Labelable (name, tableName, createdBy, creationTS) values ('hardware', 'Hardware', 'jrb', UTC_TIMESTAMP());
insert into Labelable (name, tableName, createdBy, creationTS) values ('hardware_type', 'HardwareType', 'jrb', UTC_TIMESTAMP());
insert into Labelable (name, tableName, createdBy, creationTS) values ('NCR', 'Exception', 'jrb', UTC_TIMESTAMP());
insert into Labelable (name, tableName, createdBy, creationTS) values ('travelerType', 'TravelerType', 'jrb', UTC_TIMESTAMP());
insert into Labelable (name, tableName, createdBy, creationTS) values ('location', 'Location', 'jrb', UTC_TIMESTAMP());
insert into Labelable (name, tableName, createdBy, creationTS) values ('label', 'Label', 'jrb', UTC_TIMESTAMP());

-- Create stored procedures to get subsystem, hardware group(s) associated
-- with a label, one of each for each labelable type
source NCR_subsystemProc.sql;
source NCR_hardwareGroupsProc.sql;
source hardwareType_subsystemProc.sql;
source hardwareType_hardwareGroupsProc.sql;
source hardware_subsystemProc.sql;
source hardware_hardwareGroupsProc.sql;
source label_subsystemProc.sql;
source label_hardwareGroupsProc.sql;
source run_subsystemProc.sql;
source run_hardwareGroupsProc.sql;
source travelerType_subsystemProc.sql;
source travelerType_hardwareGroupsProc.sql;

-- and create the generic procedures which case on object type
source generic_subsystemProc.sql;
source generic_hardwareGroupsProc.sql;

