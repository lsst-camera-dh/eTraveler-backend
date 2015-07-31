## Make up a couple fake hardware types and a group they are both in for testing
## Add more defintions for a couple types to be used in assembly with snarks

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

# A couple new hardware types to act as subordinate components,
# one batched and one not
insert into HardwareType (name, description, createdBy, creationTS) values ('borogove', 'Something to be subordinate component in assembly', 'jrb', UTC_TIMESTAMP());
insert into HardwareGroup(name, description, createdBy, creationTS) values ('borogove', 'singleton group for htype borogove', 'jrb', UTC_TIMESTAMP());

insert into HardwareTypeGroupMapping  set hardwareTypeId=(select id from HardwareType where HardwareType.name='borogove'),  hardwareGroupId=(select id from HardwareGroup where HardwareGroup.name='borogove'), createdBy='jrb', creationTS=UTC_TIMESTAMP();

insert into HardwareType (name, description, isBatched, createdBy, creationTS) values ('screws', 'Example of batched type', '1', 'jrb', UTC_TIMESTAMP);

## probably could do without singleton group for batched hardware type
insert into HardwareGroup(name, description, createdBy, creationTS) values ('screws', 'singleton group for htype screws', 'jrb', UTC_TIMESTAMP());

insert into HardwareTypeGroupMapping  set hardwareTypeId=(select id from HardwareType where HardwareType.name='screws'),  hardwareGroupId=(select id from HardwareGroup where HardwareGroup.name='screws'), createdBy='jrb', creationTS=UTC_TIMESTAMP();

