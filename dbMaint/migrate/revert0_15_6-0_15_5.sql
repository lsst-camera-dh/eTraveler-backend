
alter table ProcessEdge drop foreign key fk33;
alter table ProcessEdge drop column branchHardwareTypeId;

-- Might not be able to take out ne value 'HARDWARE_SELECTION' if it's been used
-- alter table Process modify column substeps ENUM('NONE', 'SEQUENCE', 'SELECTION', default 'NONE' COMMENT 'determines where and how we go next' after instructionURL;
delete from DbRelease where major=0 and minor=15 and patch=6;
update DbRelease set status='CURRENT' where major=0 and minor=15 and patch=5;
