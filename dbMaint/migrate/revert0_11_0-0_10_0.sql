CREATE TABLE HardwareRelationshipType
( id int NOT NULL AUTO_INCREMENT, 
  name varchar(255) NOT NULL,
  hardwareTypeId int NOT NULL,
  componentTypeId int NOT NULL,
  slot int unsigned NOT NULL DEFAULT '1',
  slotname varchar(255) COMMENT "identify slot in user friendly fashion",
  description varchar(255) DEFAULT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  constraint fk8 FOREIGN KEY (hardwareTypeId) REFERENCES HardwareType(id),
  constraint fk9 FOREIGN KEY (componentTypeId) REFERENCES HardwareType(id),
  constraint cui1 UNIQUE INDEX (name, slot),
  INDEX fk8 (hardwareTypeId),
  INDEX fk9 (componentTypeId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='describes relationship between two hardware types, one subsidiary to the other';

CREATE TABLE HardwareRelationship 
( id int NOT NULL AUTO_INCREMENT, 
  hardwareId int NOT NULL, 
  componentId int NOT NULL, 
  begin timestamp NULL, 
  end timestamp NULL, 
  hardwareRelationshipTypeId int NOT NULL, 
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk10 FOREIGN KEY (hardwareId) REFERENCES Hardware (id) , 
  CONSTRAINT fk11 FOREIGN KEY (componentId) REFERENCES Hardware (id) , 
  INDEX fk10 (hardwareId), 
  INDEX fk11 (componentId), 
  INDEX fk12 (hardwareRelationshipTypeId),
  INDEX ix10 (begin),
  INDEX ix11 (end),
  INDEX ix12 (creationTS)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Instance of HardwareRelationshipType between actual pieces of hardware';

ALTER TABLE Process add hardwareRelationshipTypeId int NULL;

ALTER TABLE Activity add hardwareRelationshipId int NULL;

ALTER TABLE BatchedInventoryHistory drop foreign key fk272;
ALTER TABLE BatchedInventoryHistory drop sourceBatchId;

DELETE from DbRelease where major='0' and minor='11' and patch='0';
