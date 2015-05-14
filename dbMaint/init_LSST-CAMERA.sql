#  Do some inserts to get us started off
insert into Site (name, jhVirtualEnv, jhOutputRoot, createdBy, creationTS) values ('SLAC', '/nfs/farm/g/lsst/u1/jobHarness/jh_inst', '/nfs/farm/g/lsst/u1/jobHarness/jh_archive', 'jrb', UTC_TIMESTAMP());
##insert into Site (name, jhVirtualEnv, jhOutputRoot, createdBy, creationTS) values ('SLAC_TestBed', '/mnt/ccs/jobHarness/jh_inst', '/mnt/ccs/jh_archive', 'jrb', UTC_TIMESTAMP());

# Do not yet have official hardware type or hardware group names except for CCDs

insert into HardwareType (name, description, createdBy, creationTS) values ('ITL-CCD', 'CCD manufactured by ITL', 'jrb', UTC_TIMESTAMP());
insert into HardwareType (name, description, createdBy, creationTS) values ('e2v-CCD', 'CCD manufactured by e2v', 'jrb', UTC_TIMESTAMP());

insert into HardwareGroup (name, description, createdBy, creationTS) values ('ITL-CCD', 'singleton group for ITL-CCD htype', 'jrb', UTC_TIMESTAMP());
insert into HardwareGroup (name, description, createdBy, creationTS) values ('e2v-CCD', 'singleton group for  e2v-CCD htype', 'jrb', UTC_TIMESTAMP());
insert into HardwareGroup (name, description, createdBy, creationTS) values ('Generic-CCD', 'includes all CCDs', 'jrb', UTC_TIMESTAMP());


# Mapping for singleton groups
insert into HardwareTypeGroupMapping (hardwareTypeId, hardwareGroupId) select HardwareType.id, HardwareGroup.id from HardwareType join HardwareGroup where HardwareType.name=HardwareGroup.name;

# Mapping for Generic-CCD
insert into HardwareTypeGroupMapping (hardwareTypeId, hardwareGroupId) select HardwareType.id, HardwareGroup.id from HardwareType join HardwareGroup where HardwareType.name="ITL-CCD" and HardwareGroup.name="Generic-CCD";
insert into HardwareTypeGroupMapping (hardwareTypeId, hardwareGroupId) select HardwareType.id, HardwareGroup.id from HardwareType join HardwareGroup where HardwareType.name="e2v-CCD" and HardwareGroup.name="Generic-CCD";

update HardwareTypeGroupMapping set createdBy="jrb", creationTS=UTC_TIMESTAMP();




insert into HardwareIdentifierAuthority (name, createdBy, creationTS) values ('BNL', 'jrb', UTC_TIMESTAMP());
insert into HardwareIdentifierAuthority (name, createdBy, creationTS) values ('SerialNumber', 'jrb', UTC_TIMESTAMP());

# Cannot add relationship types when we do not yet have official hardware types
#insert into HardwareRelationshipType set name='LCA-Raft_1andCCD', slot='1',createdBy='jrb', creationTS=UTC_TIMESTAMP(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');

#insert into HardwareRelationshipType set name='LCA-Raft_1andCCD', slot='2',createdBy='jrb', creationTS=UTC_TIMESTAMP(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');

#insert into HardwareRelationshipType set name='LCA-Raft_1andCCD', slot='3',createdBy='jrb', creationTS=UTC_TIMESTAMP(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');

#insert into HardwareRelationshipType set name='LCA-Raft_1andCCD', slot='4',createdBy='jrb', creationTS=UTC_TIMESTAMP(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');

#insert into HardwareRelationshipType set name='LCA-Raft_1andCCD', slot='5',createdBy='jrb', creationTS=UTC_TIMESTAMP(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');

#insert into HardwareRelationshipType set name='LCA-Raft_1andCCD', slot='6',createdBy='jrb', creationTS=UTC_TIMESTAMP(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');

#insert into HardwareRelationshipType set name='LCA-Raft_1andCCD', slot='7',createdBy='jrb', creationTS=UTC_TIMESTAMP(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');

#insert into HardwareRelationshipType set name='LCA-Raft_1andCCD', slot='8',createdBy='jrb', creationTS=UTC_TIMESTAMP(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');

#insert into HardwareRelationshipType set name='LCA-Raft_1andCCD', slot='9',createdBy='jrb', creationTS=UTC_TIMESTAMP(), hardwareTypeId=(select id from HardwareType where HardwareType.name='LCA-Raft_1'),componentTypeId=(select id from HardwareType where HardwareType.name='CCD');



