-- Add a field to BatchedInventoryHistory for new hardware id
-- Eliminate obsolete HardwareRelationshipType, HardwareRelationship,
--  and foreign keys pointing to them in Process and Activity
ALTER TABLE Process drop hardwareRelationshipTypeId;
ALTER TABLE Activity drop hardwareRelationshipId;
DROP  TABLE HardwareRelationship;
DROP  TABLE HardwareRelationshipType;

ALTER TABLE MultiRelationshipSlot drop FOREIGN KEY fk302;
ALTER TABLE MultiRelationshipSlot modify minorId int NULL COMMENT "obsolete; moved to MultiRelationshipHistory" after hardwareId;
ALTER TABLE MultiRelationshipHistory add minorId int NULL COMMENT "batch from which 1 or nBatchedItems come or regular tracked hardware instance" after multiRelationshipSlotId;
ALTER TABLE MultiRelationshipHistory add CONSTRAINT fk313 FOREIGN KEY (minorId) REFERENCES Hardware(id);

ALTER TABLE BatchedInventoryHistory add column sourceBatchId int NULL COMMENT 'batch items came from, if any' after hardwareId;
ALTER TABLE BatchedInventoryHistory  add CONSTRAINT fk272 FOREIGN KEY (sourceBatchId) REFERENCES Hardware(id);

INSERT into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '11', '0', 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Support for uninstall batches; clean up obsolete stuff');
