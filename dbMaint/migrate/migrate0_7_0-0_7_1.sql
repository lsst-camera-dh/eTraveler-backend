# Batched hardware, second (final) stage, supporting relationships

# Tables to be added: 
# MultiRelationshipType
CREATE TABLE MultiRelationshipType 
( id int NOT NULL AUTO_INCREMENT, 
  name varchar(255) NOT NULL,
  hardwareTypeId int NOT NULL,
  minorTypeId int NOT NULL,
  description varchar(255) DEFAULT NULL,
  singleBatch tinyint NOT NULL default "1" COMMENT "By default batched relationship is satisfied with a single batch",
  nMinorItems int NOT NULL default "1" COMMENT "By default use just one subordinate item in a relationship but may be more",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk280 FOREIGN KEY (hardwareTypeId) REFERENCES HardwareType(id),
  CONSTRAINT fk281 FOREIGN KEY (minorTypeId) REFERENCES HardwareType(id),
  INDEX ix280 (hardwareTypeId),
  INDEX ix281 (minorTypeId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='describes relationship between two hardware types, one batched and subsidiary to the other';

# MultiRelationshipSlotType  (references a MultiRelationshipType)
# if relationship type has singleBatch=1 (true), just need one of these to
# represent all slots.  Otherwise slots may be distinguishable, so need
# nBatchedItems of them
CREATE TABLE MultiRelationshipSlotType
( id int NOT NULL AUTO_INCREMENT,
  multiRelationshipTypeId int NOT NULL,
  slotname varchar(255) NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk286 FOREIGN KEY (mutliRelationshipTypeId) REFERENCES MultiRelationshipType(id),
  INDEX ix286 (multiRelationshipTypeId),
  CONSTRAINT ix287 UNIQUE (multiRelationshipTypeId, slotname)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='names for slots for each subsidiary batched item';

CREATE TABLE MultiRelationship 
( id int NOT NULL AUTO_INCREMENT, 
  hardwareId int NOT NULL, 
  begin timestamp NULL, 
  end timestamp NULL, 
  multiRelationshipTypeId int NOT NULL, 
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk290 FOREIGN KEY (hardwareId) REFERENCES Hardware (id) , 
  CONSTRAINT fk291 FOREIGN KEY (multiRelationshipTypeId) REFERENCES MultiRelationshipType (id), 
  INDEX ix290 (hardwareId), 
  INDEX ix291 (multiRelationshipTypeId),
  INDEX ix292 (begin),
  INDEX ix293 (end),
  INDEX ix294 (creationTS)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Instance of MultiRelationshipType';

# MultiRelationshipSlot (instance.  May represent one or many batched items
# or one "regular" item)
CREATE TABLE MultiRelationshipSlot
( id int NOT NULL AUTO_INCREMENT,
  multiRelationshipSlotTypeId int NOT NULL,
  hardwareId int NOT NULL COMMENT "batch from which 1 or nBatchedItems come or regular tracked hardware instance",
  multiRelationshipId int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk300 FOREIGN KEY (multiRelationshipSlotTypeId) REFERENCES MultiRelationshipSlotType(id),
  CONSTRAINT fk301 FOREIGN KEY (hardwareId) REFERENCES Hardware(id),
  CONSTRAINT fk302 FOREIGN KEY (multiRelationshipId) REFERENCES MultiRelationship(id),
  INDEX ix300 (multiRelationshipSlotTypeId),
  INDEX ix301 (hardwareId),
  INDEX ix302 (multiRelationshipId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='batched slot instance. May represent 1 or several items';

# Tables to be altered
#   Add field to Process multiRelationshipTypeId, 
#   analogous to relationshipTypeId
ALTER TABLE Process ADD multiRelationshipTypeId int NULL AFTER hardwareRelationshipTypeId;
ALTER TABLE Process ADD CONSTRAINT fk46 FOREIGN KEY (multiRelationshipTypeId) REFERENCES MultiRelationshipType(id);
ALTER TABLE Process ADD INDEX ix46 (multiRelationshipTypeId);
ALTER TABLE Activity ADD multiRelationshipId int NULL after hardwareRelationshipId;
ALTER TABLE Activity ADD CONSTRAINT fk77 FOREIGN KEY (multiRelationshipId) REFERENCES BatchedRelationship(id);
ALTER TABLE Activity ADD INDEX ix77 (multiRelationshipId);

# Inserts
#   New internal action bits for making/breaking batched relationship
insert into InternalAction (name, maskBit,createdBy, creationTS) values ('makeMultiRelationship', '512', 'jrb', UTC_TIMESTAMP());
insert into InternalAction (name, maskBit,createdBy, creationTS) values ('breakMultiRelationship', '1024', 'jrb', UTC_TIMESTAMP());
# New prerequisite type
insert into PrerequisiteType set name='IMPLICIT_BATCHED', createdBy='jrb', creationTS=UTC_TIMESTAMP();

#   Insert new DbRelease row for 0.7.1
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 7, 1, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Complete support of batched hardware');
