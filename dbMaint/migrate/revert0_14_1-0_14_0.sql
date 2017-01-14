alter table FloatResultHarnessed modify column value float after name;
alter table FloatResultManual modify column value float after name;

alter table Process add hardwareTypeId int DEFAULT NULL COMMENT 'deprecated field';
alter table Process add key fk40 (hardwareTypeId);
alter table Process add constraint fk40 foreign key (hardwareTypeId) references HardwareType(id);

CREATE TABLE Result 
( id int NOT NULL AUTO_INCREMENT, 
  activityId int NOT NULL, 
  status int NOT NULL, 
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk90 FOREIGN KEY (activityId) REFERENCES Activity (id), 
  INDEX fk90 (activityId) 
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE NextProcessVersion
(id int NOT NULL AUTO_INCREMENT,
 name varchar(50) NOT NULL COMMENT 'will match something in Process.name',
 nextVersion int DEFAULT 0,
 createdBy varchar(50) NOT NULL,
 creationTS timestamp NULL,
 PRIMARY KEY (id),
 UNIQUE INDEX(name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Serve up next available version number for NextProcessVersion.name';

alter table IntResultHarnessed drop key ix156;
alter table IntResultHarnessed add constraint ix156 unique (activityId, name, schemaName, schemaVersion, schemaInstance);

alter table FloatResultHarnessed drop key ix166;
alter table FloatResultHarnessed add constraint ix166 unique (activityId, name, schemaName, schemaVersion, schemaInstance);

alter table StringResultHarnessed drop key ix186;
alter table StringResultHarnessed add constraint ix186 unique (activityId, name, schemaName, schemaVersion, schemaInstance);

delete from DbRelease where major='0' and minor='14' and patch='1';

update DbRelease set status='CURRENT' where major='0' and minor='14' and patch='0';
