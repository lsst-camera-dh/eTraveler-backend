## Make up a couple fake hardware types and a group they are both in for testing


insert into HardwareType (name, description, createdBy, creationTS) values ('boojum', 'member of group snark', 'jrb', UTC_TIMESTAMP());
insert into HardwareGroup(name, description, createdBy, creationTS) values ('boojum', 'singleton group for htype boojum', 'jrb', UTC_TIMESTAMP());

insert into HardwareType (name, description, createdBy, creationTS) values ('not_a_boojum', 'member of group snark', 'jrb', UTC_TIMESTAMP());
insert into HardwareGroup(name, description, createdBy, creationTS) values ('not_a_boojum', 'singleton group for htype not_a_boojum', 'jrb', UTC_TIMESTAMP());

insert into HardwareGroup(name, description, createdBy, creationTS) values('snark', 'groups together boojum and not_a_boojum', 'jrb', UTC_TIMESTAMP());


insert into HardwareTypeGroupMapping set hardwareTypeId=(select id from HardwareType where HardwareType.name='boojum'),  hardwareGroupId=(select id from HardwareGroup where HardwareGroup.name='boojum'), createdBy='jrb', creationTS=UTC_TIMESTAMP();

insert into HardwareTypeGroupMapping set hardwareTypeId=(select id from HardwareType where HardwareType.name='not_a_boojum'),  hardwareGroupId=(select id from HardwareGroup where HardwareGroup.name='not_a_boojum'), createdBy='jrb', creationTS=UTC_TIMESTAMP();



## Now for the mapping into snark group
insert into HardwareTypeGroupMapping set hardwareTypeId=(select id from HardwareType where HardwareType.name='boojum'), hardwareGroupId=(select id from HardwareGroup where HardwareGroup.name='snark'), createdBy='jrb', creationTS=UTC_TIMESTAMP();

insert into HardwareTypeGroupMapping set hardwareTypeId=(select id from HardwareType where HardwareType.name='not_a_boojum'), hardwareGroupId=(select id from HardwareGroup where HardwareGroup.name='snark'), createdBy='jrb', creationTS=UTC_TIMESTAMP();

