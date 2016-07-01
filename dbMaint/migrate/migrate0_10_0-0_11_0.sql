-- Add a field to BatchedInventoryHistory for new hardware id
-- Eliminate obsolete HardwareRelationshipType, HardwareRelationship,
--  and foreign keys pointing to them in Process and Activity
ALTER TABLE Process drop hardwareRelationshipTypeId;
ALTER TABLE Activity drop hardwareRelationshipId;
DROP  TABLE HardwareRelationship;
DROP  TABLE HardwareRelationshipType;

ALTER TABLE BatchedInventoryHistory add column sourceBatchId int NULL COMMENT 'batch items came from, if any' after hardwareId;
ALTER TABLE BatchedInventoryHistory  add CONSTRAINT fk272 FOREIGN KEY (sourceBatchId) REFERENCES Hardware(id);

INSERT into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '11', '0', 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Support for uninstall batches; clean up obsolete stuff');
