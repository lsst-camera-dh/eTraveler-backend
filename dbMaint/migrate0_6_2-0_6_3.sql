# new tables
CREATE TABLE JobHarness
( id int NOT NULL AUTO_INCREMENT,
  jhVirtualEnv varchar(255) NOT NULL,
  jhOutputRoot varchar(255) NOT NULL,
  jhCfg varchar(255) NULL COMMENT "path to installation-wide cfg (if any) relative to jhVirtualEnv",
  siteId    int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk260 FOREIGN KEY(siteId) REFERENCES Site(id),
  INDEX ix260 (siteId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Information pertaining to a job harness installation';

# new or modified columns
alter table Site modify jhVirtualEnv varchar(255) NULL;
alter table Site modify jhOutputRoot varchar(255) NULL;

# get rid of old int newLocationId field; add varchar(255) newLocation.
# if null with location internal action bit set, etraveler will ask
alter table Process drop foreign key fk44;
alter table Process drop newLocationId;
alter table Process add newLocation varchar(255) NULL after newHardwareStatusId;

alter table HardwareLocationHistory add activityId int NULL after hardwareId;
alter table HardwareLocationHistory add constraint fk212 foreign key (activityId) references Activity(id);
alter table HardwareLocationHistory add index ix212 (activityId);

alter table HardwareStatusHistory add activityId int NULL after hardwareId;
alter table HardwareStatusHistory add constraint fk202 foreign key (activityId) references Activity(id);
alter table HardwareStatusHistory add index ix202 (activityId);


alter table Activity add jobHarnessId int NULL after parentActivityId;
alter table Activity add constraint fk76 foreign key (jobHarnessId) references JobHarness(id);
alter table Activity add index ix76 (jobHarnessId);

# inserts

INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 6, 3, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Upgrades for setting new location in traveler step; addition of JobHarness table');
