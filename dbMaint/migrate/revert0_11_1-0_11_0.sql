alter table MultiRelationshipSlot add index ix302 (minorId);
alter table MultiRelationshipSlot drop key ix303;

alter table InputPattern modify column description varchar(255) NULL COMMENT "if label is not sufficient" after units;

alter table MultiRelationshipHistory modify column minorId int NULL COMMENT 'batch from which 1 or nBatchedItems come or regular tracked hardware instance' after multiRelationshipSlotId;

delete from DbRelease where major='0' and minor='11' and patch='1';
