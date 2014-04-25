#  Do some inserts to get us started off
insert into Site (name, jhVirtualEnv, jhOutputRoot, createdBy, creationTS) values ('SLAC', '/nfs/farm/g/lsst/u1/jobHarness/jh_inst', '/nfs/farm/g/lsst/u1/jobHarness/jh_stage', 'jrb', NOW());
insert into HardwareType (name, description, createdBy, creationTS) values ('CCD', 'CCD, aka Sensor', 'jrb', NOW());
insert into HardwareType (name, description, createdBy, creationTS) values ('LCA-Raft_1', 'science raft', 'jrb', NOW());
insert into HardwareType (name, description, createdBy, creationTS) values ('LCA-Raft_2',  'corner raft', 'jrb', NOW());
insert into HardwareType (name, createdBy, creationTS) values ('Lens', 'jrb', NOW());
insert into HardwareType (name, createdBy, creationTS) values ('LCA-Filter', 'jrb', NOW());
insert into HardwareType (name, createdBy, creationTS) values ('LCA-ASPIC', 'jrb', NOW());
insert into HardwareType (name, createdBy, creationTS) values ('LCA-CABAC', 'jrb', NOW());

insert into HardwareIdentifierAuthority (name, createdBy, creationTS) values ('BNL', 'jrb', NOW());
insert into HardwareIdentifierAuthority (name, createdBy, creationTS) values ('SerialNumber', 'jrb', NOW());

insert into HardwareRelationshipType set name='Raft_CCD_0_0',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set name='Raft_CCD_0_1',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set name='Raft_CCD_0_2',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set name='Raft_CCD_1_0',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set name='Raft_CCD_1_1',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set name='Raft_CCD_1_2',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set name='Raft_CCD_2_0',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set name='Raft_CCD_2_1',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');
insert into HardwareRelationshipType set name='Raft_CCD_2_2',
createdBy='jrb', creationTS=NOW(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');


