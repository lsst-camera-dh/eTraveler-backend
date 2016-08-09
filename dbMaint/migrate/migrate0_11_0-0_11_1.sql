-- Little fixes
alter table MultiRelationshipSlot drop index ix302;
alter table MultiRelationshipSlot add unique key ix303 (hardwareId, multiRelationshipSlotTypeId);

alter table InputPattern modify column description text NULL COMMENT "if label is not sufficient" after units;

alter table MultiRelationshipHistory modify column minorId int NOT NULL COMMENT 'batch from which 1 or nBatchedItems come or regular tracked hardware instance' after multiRelationshipSlotId;

INSERT into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '11', '1', 'TEST', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Increase input description size; minor clean-up of relationship support');
