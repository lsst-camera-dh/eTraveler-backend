# Batched hardware, second (final) stage, supporting relationships

# Tables to be added: 
# BatchedRelationshipType
CREATE TABLE BatchedRelationshipType 
( id int NOT NULL AUTO_INCREMENT, 
  name varchar(255) NOT NULL,
  hardwareTypeId int NOT NULL,
  batchedTypeId int NOT NULL,
  description varchar(255) DEFAULT NULL,
  singleBatch tinyint NOT NULL default "1" COMMENT "By default batched relationship is satisfied with a single batch",
  nBatchedItems int NOT NULL default "1" COMMENT "By default use just one batched item in a relationship but may be more",
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk280 FOREIGN KEY (hardwareTypeId) REFERENCES HardwareType(id),
  CONSTRAINT fk281 FOREIGN KEY (batchedTypeId) REFERENCES HardwareType(id),
  INDEX ix280 (hardwareTypeId),
  INDEX ix281 (batchedTypeId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='describes relationship between two hardware types, one batched and subsidiary to the other';

# BatchedRelationshipSlotType  (references a BatchedRelationshipType)
# if relationship type has singleBatch=1 (true), just need one of these to
# represent all slots.  Otherwise slots may be distinguishable, so need
# nBatchedItems of them
CREATE TABLE BatchedRelationshipSlotType
( id int NOT NULL AUTO_INCREMENT,
  batchedRelationshipTypeId int NOT NULL,
  slotname varchar(255) NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk286 FOREIGN KEY (batchedRelationshipTypeId) REFERENCES BatchedRelationshipType(id),
  INDEX ix286 (batchedRelationshipTypeId),
  CONSTRAINT ix287 UNIQUE (batchedRelationshipTypeId, slotname)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='names for slots for each subsidiary batched item';

CREATE TABLE BatchedRelationship 
( id int NOT NULL AUTO_INCREMENT, 
  hardwareId int NOT NULL, 
  begin timestamp NULL, 
  end timestamp NULL, 
  batchedRelationshipTypeId int NOT NULL, 
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id), 
  CONSTRAINT fk290 FOREIGN KEY (hardwareId) REFERENCES Hardware (id) , 
  CONSTRAINT fk291 FOREIGN KEY (batchedRelationshipTypeId) REFERENCES BatchedRelationshipType (id), 
  INDEX ix290 (hardwareId), 
  INDEX ix291 (batchedRelationshipTypeId),
  INDEX ix292 (begin),
  INDEX ix293 (end),
  INDEX ix294 (creationTS)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='Instance of BatchedRelationshipType';

# BatchedRelationshipSlot (instance.  May represent one or many batched items)
CREATE TABLE BatchedRelationshipSlot
( id int NOT NULL AUTO_INCREMENT,
  batchedRelationshipSlotTypeId int NOT NULL,
  batchId int NOT NULL COMMENT "batch from which 1 or nBatchedItems come",
  batchedRelationshipId int NOT NULL,
  createdBy varchar(50) NOT NULL,
  creationTS timestamp NULL,
  PRIMARY KEY (id),
  CONSTRAINT fk300 FOREIGN KEY (batchedRelationshipSlotTypeId) REFERENCES BatchedRelationshipSlotType(id),
  CONSTRAINT fk301 FOREIGN KEY (batchId) REFERENCES Hardware(id),
  CONSTRAINT fk302 FOREIGN KEY (batchedRelationshipId) REFERENCES BatchedRelationship(id),
  INDEX ix300 (batchedRelationshipSlotTypeId),
  INDEX ix301 (batchId),
  INDEX ix302 (batchedRelationshipId)
) ENGINE=InnoDB DEFAULT CHARSET=latin1
COMMENT='batched slot instance. May represent 1 or several items';

# Tables to be altered
#   Add field to Process batchedRelationshipTypeId, 
#   analogous to relationshipTypeId
ALTER TABLE Process ADD batchedRelationshipTypeId int NULL AFTER hardwareRelationshipTypeId;
ALTER TABLE Process ADD CONSTRAINT fk46 FOREIGN KEY (batchedRelationshipTypeId) REFERENCES BatchedRelationshipType(id);
ALTER TABLE Process ADD INDEX ix46 (batchedRelationshipTypeId);
ALTER TABLE Activity ADD batchedRelationshipId int NULL after hardwareRelationshipId;
ALTER TABLE Activity ADD CONSTRAINT fk77 FOREIGN KEY (batchedRelationshipId) REFERENCES BatchedRelationship(id);
ALTER TABLE Activity ADD INDEX ix77 (batchedRelationshipId);

# Inserts
#   New internal action bits for making/breaking batched relationship
#    - or can we use existing bits when batchedRelationshipTypeId is non-null?
#      can a step involve both kinds of relationships?
#   Go ahead and define new bits, so as not to exclude possibility
insert into InternalAction (name, maskBit,createdBy, creationTS) values ('makeBatchedRelationship', '512', 'jrb', UTC_TIMESTAMP());
insert into InternalAction (name, maskBit,createdBy, creationTS) values ('breakBatchedRelationship', '1024', 'jrb', UTC_TIMESTAMP());

#   Insert new DbRelease row for 0.7.1
INSERT into DbRelease  (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 7, 1, 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Complete support of batched hardware');
