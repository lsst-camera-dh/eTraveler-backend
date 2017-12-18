alter table Process modify column substeps ENUM('NONE', 'SEQUENCE', 'SELECTION','HARDWARE_SELECTION') default 'NONE' COMMENT 'determines where we go next' after instructionsURL;

alter table ProcessEdge add column branchHardwareTypeId int  NULL COMMENT 'use if selection is by hardware type';

alter table ProcessEdge add CONSTRAINT fk33 FOREIGN KEY (branchHardwareTypeId) REFERENCES HardwareType(id);

update DbRelease set status='OLD' where major='0' and minor='15' and patch='5';
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values ('0', '15', '6', 'CURRENT', 'jrb', UTC_TIMESTAMP(), UTC_TIMESTAMP(), 'Support branch by hardware type');


