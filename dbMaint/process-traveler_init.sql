#  Do some inserts to get us started off
insert into HardwareType (name, createdBy, creationTS) values ('CCD', 'jrb', NOW());
insert into HardwareType (name, createdBy, creationTS) values ('Raft', 'jrb', NOW());
insert into HardwareType (name, createdBy, creationTS) values ('Lens', 'jrb', NOW());
insert into HardwareType (name, createdBy, creationTS) values ('Filter', 'jrb', NOW());
insert into HardwareType (name, createdBy, creationTS) values ('ASPIC chip', 'jrb', NOW());
insert into HardwareType (name, createdBy, creationTS) values ('CABAC Chip', 'jrb', NOW());

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
