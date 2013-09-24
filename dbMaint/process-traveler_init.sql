#  Do some inserts to get us started off
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 1, 0, 'TEST', 'jrb', NOW(), NOW(), 'Adding prerequisite tables');
insert into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 2, 0, 'TEST', 'jrb', NOW(), NOW(), 'Adding history, result tables');
insert into Site (name, jhVirtualEnv, jhOutputRoot, createdBy, creationTS) values ('SLAC', '/nfs/farm/g/lsst/u1/jobHarness/jh_inst', '/nfs/farm/g/lsst/u1/jobHarness/jh_stage', 'jrb', NOW());
insert into HardwareType (name, drawing, createdBy, creationTS) values ('CCD', 'DRAWING_CCD', 'jrb', NOW());
insert into HardwareType (name, drawing, createdBy, creationTS) values ('Raft', 'DRAWING_Raft', 'jrb', NOW());
insert into HardwareType (name, drawing, createdBy, creationTS) values ('Lens', 'DRAWING_Lens', 'jrb', NOW());
insert into HardwareType (name, drawing, createdBy, creationTS) values ('Filter', 'DRAWING_Filter', 'jrb', NOW());
insert into HardwareType (name, drawing, createdBy, creationTS) values ('ASPIC chip', 'DRAWING_ASPIC', 'jrb', NOW());
insert into HardwareType (name, drawing, createdBy, creationTS) values ('CABAC Chip', 'DRAWING_CABAC', 'jrb', NOW());

insert into HardwareIdentifierAuthority (name, createdBy, creationTS) values ('BNL', 'jrb', NOW());
insert into HardwareIdentifierAuthority (name, createdBy, creationTS) values ('SerialNumber', 'jrb', NOW());

insert into HardwareRelationshipType set name='Raft_CCD_0_0',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='Raft'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set name='Raft_CCD_0_1',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='Raft'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set name='Raft_CCD_0_2',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='Raft'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set name='Raft_CCD_1_0',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='Raft'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set name='Raft_CCD_1_1',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='Raft'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set name='Raft_CCD_1_2',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='Raft'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set name='Raft_CCD_2_0',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='Raft'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set name='Raft_CCD_2_1',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='Raft'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set name='Raft_CCD_2_2',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='Raft'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into PrerequisiteType set name='PROCESS_STEP', createdBy='jrb', creationTS=NOW();
insert into PrerequisiteType set name='COMPONENT', createdBy='jrb', creationTS=NOW();
insert into PrerequisiteType set name='TEST_EQUIPMENT', createdBy='jrb', creationTS=NOW();
insert into PrerequisiteType set name='CONSUMABLE', createdBy='jrb', creationTS=NOW();
insert into HardwareStatus set name='NEW', description='Available for preparation and testing', createdBy='jrb', creationTS=NOW();
insert into HardwareStatus set name='IN_PROGRESS', description='At least one traveler begun; at least one applicable traveler not complete', createdBy='jrb', creationTS=NOW();
insert into HardwareStatus set name='REJECTED', description='Beyond hope', createdBy='jrb', creationTS=NOW();
insert into HardwareStatus set name='READY', description='Testing/preparation complete; ready for integration', createdBy='jrb', creationTS=NOW();
insert into HardwareStatus set name='USED', description='Fully tested component has been integrated', createdBy='jrb', creationTS=NOW();
insert into HardwareStatus set name='PENDING', description='Component has irregularities; acceptance under review', createdBy='jrb', creationTS=NOW();
insert into InputSemantics set name="int", createdBy='jrb', creationTS=NOW();
insert into InputSemantics set name="float", createdBy='jrb', creationTS=NOW();
insert into InputSemantics set name="boolean", createdBy='jrb', creationTS=NOW();
insert into InputSemantics set name="checkbox", createdBy='jrb', creationTS=NOW();
insert into InputSemantics set name="filepath", createdBy='jrb', creationTS=NOW();
insert into InputSemantics set name="timestamp", createdBy='jrb', creationTS=NOW();
insert into InputSemantics set name="string", createdBy='jrb', creationTS=NOW();

insert into JobHarnessStep set name="registered", createdBy='jrb', creationTS=NOW();
insert into JobHarnessStep set name="configured", createdBy='jrb', creationTS=NOW();
insert into JobHarnessStep set name="staged", createdBy='jrb', creationTS=NOW();
insert into JobHarnessStep set name="produced", createdBy='jrb', creationTS=NOW();
insert into JobHarnessStep set name="validated", createdBy='jrb', creationTS=NOW();
insert into JobHarnessStep set name="archived", createdBy='jrb', creationTS=NOW();
insert into JobHarnessStep set name="purged", createdBy='jrb', creationTS=NOW();
insert into JobHarnessStep set name="ingested", createdBy='jrb', creationTS=NOW();
insert into ActivityFinalStatus set name="success", createdBy='jrb', creationTS=NOW();
insert into ActivityFinalStatus set name="failure", createdBy='jrb', creationTS=NOW();
insert into InternalAction set name='harnessedJob', maskBit='1', createdBy='jrb', creationTS=NOW();
insert into InternalAction set name='makeHardwareRelationship', maskBit='2', createdBy='jrb', creationTS=NOW();
insert into InternalAction set name='breakHardwareRelationship', maskBit='4', createdBy='jrb', creationTS=NOW();
insert into InternalAction set name='setHardwareStatus', maskBit='8', createdBy='jrb', creationTS=NOW();
insert into InternalAction set name='setHardwareLocation', maskBit='16', createdBy='jrb', creationTS=NOW();

