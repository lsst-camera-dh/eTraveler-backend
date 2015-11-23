ALTER TABLE TravelerType drop foreign key fk193;
ALTER TABLE TravelerType drop index ix193;
ALTER TABLE TravelerType drop subsystemId;

ALTER TABLE HardwareType drop foreign key fkk2;
ALTER TABLE HardwareType drop index ixx2;
ALTER TABLE HardwareType drop subsystemId;

drop table Subsystem;

ALTER TABLE HardwareLocationHistory drop reason;

delete from DbRelease where major='0' and minor='9' and patch='0';

