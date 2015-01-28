#  Do some inserts to get us started off
insert into Site (name, jhVirtualEnv, jhOutputRoot, createdBy, creationTS) values ('SLAC', '/nfs/farm/g/lsst/u1/jobHarness/jh_inst', '/nfs/farm/g/lsst/u1/jobHarness/jh_stage', 'jrb', UTC_TIMESTAMP());
insert into HardwareType (name, description, createdBy, creationTS) values ('CCD', 'CCD, aka Sensor', 'jrb', UTC_TIMESTAMP());
insert into HardwareType (name, description, createdBy, creationTS) values ('LCA-Raft_1', 'science raft', 'jrb', UTC_TIMESTAMP());
insert into HardwareType (name, description, createdBy, creationTS) values ('LCA-Raft_2',  'corner raft', 'jrb', UTC_TIMESTAMP());
insert into HardwareType (name, createdBy, creationTS) values ('Lens', 'jrb', UTC_TIMESTAMP());
insert into HardwareType (name, createdBy, creationTS) values ('LCA-Filter', 'jrb', UTC_TIMESTAMP());
insert into HardwareType (name, createdBy, creationTS) values ('LCA-ASPIC', 'jrb', UTC_TIMESTAMP());
insert into HardwareType (name, createdBy, creationTS) values ('LCA-CABAC', 'jrb', UTC_TIMESTAMP());

insert into HardwareIdentifierAuthority (name, createdBy, creationTS) values ('BNL', 'jrb', UTC_TIMESTAMP());
insert into HardwareIdentifierAuthority (name, createdBy, creationTS) values ('SerialNumber', 'jrb', UTC_TIMESTAMP());

insert into HardwareRelationshipType set name='LCA-Raft_1andCCD', slot='1',
createdBy='jrb', creationTS=UTC_TIMESTAMP(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');

insert into HardwareRelationshipType set name='LCA-Raft_1andCCD', slot='2',
createdBy='jrb', creationTS=UTC_TIMESTAMP(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');

insert into HardwareRelationshipType set name='LCA-Raft_1andCCD', slot='3',
createdBy='jrb', creationTS=UTC_TIMESTAMP(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');

insert into HardwareRelationshipType set name='LCA-Raft_1andCCD', slot='4',
createdBy='jrb', creationTS=UTC_TIMESTAMP(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');

insert into HardwareRelationshipType set name='LCA-Raft_1andCCD', slot='5',
createdBy='jrb', creationTS=UTC_TIMESTAMP(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');

insert into HardwareRelationshipType set name='LCA-Raft_1andCCD', slot='6',
createdBy='jrb', creationTS=UTC_TIMESTAMP(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');

insert into HardwareRelationshipType set name='LCA-Raft_1andCCD', slot='7',
createdBy='jrb', creationTS=UTC_TIMESTAMP(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');

insert into HardwareRelationshipType set name='LCA-Raft_1andCCD', slot='8',
createdBy='jrb', creationTS=UTC_TIMESTAMP(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');

insert into HardwareRelationshipType set name='LCA-Raft_1andCCD', slot='9',
createdBy='jrb', creationTS=UTC_TIMESTAMP(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');



