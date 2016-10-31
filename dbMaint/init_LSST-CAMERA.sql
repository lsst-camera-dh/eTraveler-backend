#  Do some inserts to get us started off
insert into Site (name, jhVirtualEnv, jhOutputRoot, createdBy, creationTS) values ('SLAC', '/nfs/farm/g/lsst/u1/jobHarness/jh_inst', '/nfs/farm/g/lsst/u1/jobHarness/jh_archive', 'jrb', UTC_TIMESTAMP());
##insert into Site (name, jhVirtualEnv, jhOutputRoot, createdBy, creationTS) values ('SLAC_TestBed', '/mnt/ccs/jobHarness/jh_inst', '/mnt/ccs/jh_archive', 'jrb', UTC_TIMESTAMP());

# Do not yet have official hardware type or hardware group names except for CCDs

insert into HardwareType (name, description, createdBy, creationTS) values ('ITL-CCD', 'CCD manufactured by ITL', 'jrb', UTC_TIMESTAMP());
insert into HardwareType (name, description, createdBy, creationTS) values ('e2v-CCD', 'CCD manufactured by e2v', 'jrb', UTC_TIMESTAMP());

insert into Subsystem (name, shortName, description, parentId, createdBy, creationTS) values ("Camera", "Cam", "Full camera", NULL, 'jrb', UTC_TIMESTAMP());


insert into HardwareGroup (name, description, createdBy, creationTS) values ('ITL-CCD', 'singleton group for ITL-CCD htype', 'jrb', UTC_TIMESTAMP());
insert into HardwareGroup (name, description, createdBy, creationTS) values ('e2v-CCD', 'singleton group for  e2v-CCD htype', 'jrb', UTC_TIMESTAMP());
insert into HardwareGroup (name, description, createdBy, creationTS) values ('Generic-CCD', 'includes all CCDs', 'jrb', UTC_TIMESTAMP());


# Mapping for singleton groups
insert into HardwareTypeGroupMapping (hardwareTypeId, hardwareGroupId) select HardwareType.id, HardwareGroup.id from HardwareType join HardwareGroup where HardwareType.name=HardwareGroup.name;

# Mapping for Generic-CCD
insert into HardwareTypeGroupMapping (hardwareTypeId, hardwareGroupId) select HardwareType.id, HardwareGroup.id from HardwareType join HardwareGroup where HardwareType.name="ITL-CCD" and HardwareGroup.name="Generic-CCD";
insert into HardwareTypeGroupMapping (hardwareTypeId, hardwareGroupId) select HardwareType.id, HardwareGroup.id from HardwareType join HardwareGroup where HardwareType.name="e2v-CCD" and HardwareGroup.name="Generic-CCD";

# Hardware types also have to go into group 'Anything'
insert into HardwareTypeGroupMapping (hardwareTypeId, hardwareGroupId) select HardwareType.id, HardwareGroup.id from HardwareType join HardwareGroup where HardwareType.name="ITL-CCD" and HardwareGroup.name="Anything";
insert into HardwareTypeGroupMapping (hardwareTypeId, hardwareGroupId) select HardwareType.id, HardwareGroup.id from HardwareType join HardwareGroup where HardwareType.name="e2v-CCD" and HardwareGroup.name="Anything";

update HardwareTypeGroupMapping set createdBy="jrb", creationTS=UTC_TIMESTAMP();

insert into HardwareIdentifierAuthority (name, createdBy, creationTS) values ('BNL', 'jrb', UTC_TIMESTAMP());
insert into HardwareIdentifierAuthority (name, createdBy, creationTS) values ('SerialNumber', 'jrb', UTC_TIMESTAMP());

# Relationship types TBD

# Sites
insert into Site (name, createdBy, creationTS) values ('BNL', "jrb", UTC_TIMESTAMP());
insert into Site (name, createdBy, creationTS) values ('SLAC', "jrb", UTC_TIMESTAMP());
insert into Site (name, createdBy, creationTS) values ('LPNHE', "jrb", UTC_TIMESTAMP());
insert into Site (name, createdBy, creationTS) values ('LLNL', "jrb", UTC_TIMESTAMP());
insert into Site (name, createdBy, creationTS) values ('Harvard', "jrb", UTC_TIMESTAMP());

# Locations
insert into Location (name, siteId, createdBy, creationTS) select "Storage Room",id,"jrb",UTC_TIMESTAMP() from Site where name="BNL"; 
insert into Location (name, siteId, createdBy, creationTS) select "Anteroom",id,"jrb",UTC_TIMESTAMP() from Site where name="BNL"; 
insert into Location (name, siteId, createdBy, creationTS) select "TS1",id,"jrb",UTC_TIMESTAMP() from Site where name="BNL"; 
insert into Location (name, siteId, createdBy, creationTS) select "TS2",id,"jrb",UTC_TIMESTAMP() from Site where name="BNL"; 
insert into Location (name, siteId, createdBy, creationTS) select "TS3-1",id,"jrb",UTC_TIMESTAMP() from Site where name="BNL"; 
insert into Location (name, siteId, createdBy, creationTS) select "TS3-2",id,"jrb",UTC_TIMESTAMP() from Site where name="BNL"; 
insert into Location (name, siteId, createdBy, creationTS) select "Long-term Storage",id,"jrb",UTC_TIMESTAMP() from Site where name="BNL"; 
insert into Location (name, siteId, createdBy, creationTS) select "ITL Vendor",id,"jrb",UTC_TIMESTAMP() from Site where name="BNL"; 
insert into Location (name, siteId, createdBy, creationTS) select "e2v Vendor",id,"jrb",UTC_TIMESTAMP() from Site where name="BNL"; 
insert into Location (name, siteId, createdBy, creationTS) select "Receiving",id,"jrb",UTC_TIMESTAMP() from Site where name="BNL"; 
insert into Location (name, siteId, createdBy, creationTS) select "In Transit to BNL",id,"jrb",UTC_TIMESTAMP() from Site where name="BNL"; 
insert into Location (name, siteId, createdBy, creationTS) select "Laminar Flow Hood",id,"jrb",UTC_TIMESTAMP() from Site where name="BNL"; 


