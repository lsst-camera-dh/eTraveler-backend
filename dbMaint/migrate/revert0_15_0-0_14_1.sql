drop table LabelHistory;
drop table Label;
drop table LabelGroup;
drop table Labelable;

-- Drop all the stored procedures
drop procedure generic_hardwareGroups;
drop procedure generic_subsystem;

drop procedure NCR_hardwareGroups;
drop procedure NCR_subsystem;

drop procedure hardwareType_hardwareGroups;
drop procedure hardwareType_subsystem;

drop procedure hardware_hardwareGroups;
drop procedure hardware_subsystem;

drop procedure label_hardwareGroups;
drop procedure label_subsystem;

drop procedure run_hardwareGroups;
drop procedure run_subsystem;

drop procedure travelerType_hardwareGroups;
drop procedure travelerType_subsystem;



alter table TravelerType drop column standaloneNCR;

-- Make path fields in ExceptionType non-nullable
alter table ExceptionType modify column exitProcessPath varchar(2000)  NOT NULL DEFAULT '' COMMENT 'period separated list of processEdge ids from traveler root to exit process' after conditionString;

alter table ExceptionType modify column returnProcessPath varchar(2000)  NOT NULL DEFAULT '' COMMENT 'period separated list of processEdge ids from traveler root to return process' after exitProcessPath;

alter table Process drop column jobname;

delete from DbRelease where major='0' and minor='15' and patch='0';
update DbRelease set status='CURRENT' where major='0' and minor='14' and patch='1';


