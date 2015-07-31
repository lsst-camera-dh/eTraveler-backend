CREATE TABLE HardwareGroup
( id int NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  description varchar(255) DEFAULT "",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY(id),
  CONSTRAINT cui10 UNIQUE (name)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Allows grouping of hardware types';

CREATE TABLE HardwareTypeGroupMapping
( id int NOT NULL AUTO_INCREMENT,
  hardwareTypeId int NOT NULL,
  hardwareGroupId int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk240 FOREIGN KEY (hardwareTypeId) REFERENCES HardwareType (id), 
  CONSTRAINT fk241 FOREIGN KEY (hardwareGroupId) REFERENCES HardwareGroup (id),
  CONSTRAINT cui20 UNIQUE(hardwareTypeId, hardwareGroupId)
) ENGINE =InnoDB DEFAULT CHARSET=latin1
COMMENT='Many-to-many mapping of hardware types, groups';



## At end of this file, change column to NOT NULL
alter table Process add hardwareGroupId int NULL COMMENT "kinds of components the process may execute on";


alter table Process add CONSTRAINT fk44 FOREIGN KEY (newLocationId) REFERENCES Location(id);

alter table Process add CONSTRAINT fk45 FOREIGN KEY (hardwareGroupId) REFERENCES HardwareGroup(id);




INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 6, 0, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'support hw groups');

## Populate new tables based on contents of HardwareType
insert into HardwareGroup (name) SELECT HardwareType.name from HardwareType order by HardwareType.id;
update HardwareGroup set description="entry copied from HardwareType", createdBy="jrb", creationTS=UTC_TIMESTAMP();

insert into HardwareTypeGroupMapping (hardwareTypeId, hardwareGroupId) select HardwareType.id, HardwareGroup.id from HardwareType join HardwareGroup where HardwareType.name=HardwareGroup.name;
update HardwareTypeGroupMapping set createdBy="jrb", creationTS=UTC_TIMESTAMP();

## Set Process.hardwareGroupId for pre-existing Process entries
update Process set hardwareGroupId=(select HardwareGroup.id from HardwareType,HardwareGroup where Process.hardwareTypeId=HardwareType.id and HardwareType.name=HardwareGroup.name);

# Now can set constraints the way we want
alter table Process modify hardwareGroupId int NOT NULL COMMENT "kinds of components the process may execute on";

alter table Process add CONSTRAINT ix44 UNIQUE INDEX (name, hardwareGroupId, version);
#  Also need the following to support new ingest
alter table Process drop key ix43;
alter table Process modify hardwareTypeId int NULL COMMENT 'deprecated field';

# Get rid of unneeded entries
delete from InternalAction where name="componentLocation";
delete from InternalAction where name="componentStatus";
