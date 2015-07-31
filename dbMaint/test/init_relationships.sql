#  Stuff needed to test new relationship implementation

# A relationship between a boojum and a borogove
insert into MultiRelationshipType set name='boojum_borogove_1',hardwareTypeId=(select id from HardwareType where HardwareType.name='boojum'), minorTypeId=(select id from HardwareType where HardwareType.name='borogove'),description='Simple relationship',createdBy='jrb',creationTS=UTC_TIMESTAMP;
insert into MultiRelationshipSlotType set name='uniqueSlot', multiRelationshipTypeId=(select id from MultiRelationshipType where name='boojum_borogove_1'),createdBy='jrb',creationTS=UTC_TIMESTAMP();

# A relationship between a boojum and 2 borogoves
insert into MultiRelationshipType set name='boojum_borogove_2',hardwareTypeId=(select id from HardwareType where HardwareType.name='boojum'), minorTypeId=(select id from HardwareType where HardwareType.name='borogove'),description='Relationship with two subordinates',createdBy='jrb',creationTS=UTC_TIMESTAMP;
insert into MultiRelationshipSlotType set name='slot_1', multiRelationshipTypeId=(select id from MultiRelationshipType where name='boojum_borogove_2'),createdBy='jrb',creationTS=UTC_TIMESTAMP();
insert into MultiRelationshipSlotType set name='slot_2', multiRelationshipTypeId=(select id from MultiRelationshipType where name='boojum_borogove_2'),createdBy='jrb',creationTS=UTC_TIMESTAMP();

# A relationship between a boojum and 3 screws, single batch
insert into MultiRelationshipType set name='boojum_screws_singleBatch',hardwareTypeId=(select id from HardwareType where HardwareType.name='boojum'), minorTypeId=(select id from HardwareType where HardwareType.name='screws'),description='Relationship with two subordinates',nMinorItems='3',createdBy='jrb',creationTS=UTC_TIMESTAMP;
insert into MultiRelationshipSlotType set name='uniqueBatchedSlot', multiRelationshipTypeId=(select id from MultiRelationshipType where name='boojum_screws_singleBatch'),createdBy='jrb',creationTS=UTC_TIMESTAMP();

# A relationship between a boojum and 3 screws, multiple batches allowed
insert into MultiRelationshipType set name='boojum_screws_multiBatch',hardwareTypeId=(select id from HardwareType where HardwareType.name='boojum'), minorTypeId=(select id from HardwareType where HardwareType.name='screws'),description='Relationship with two subordinates',nMinorItems='3',singleBatch='0',createdBy='jrb',creationTS=UTC_TIMESTAMP;
insert into MultiRelationshipSlotType set name='batchedSlot_1', multiRelationshipTypeId=(select id from MultiRelationshipType where name='boojum_screws_multiBatch'),createdBy='jrb',creationTS=UTC_TIMESTAMP();
insert into MultiRelationshipSlotType set name='batchedSlot_2', multiRelationshipTypeId=(select id from MultiRelationshipType where name='boojum_screws_multiBatch'),createdBy='jrb',creationTS=UTC_TIMESTAMP();
insert into MultiRelationshipSlotType set name='batchedSlot_3', multiRelationshipTypeId=(select id from MultiRelationshipType where name='boojum_screws_multiBatch'),createdBy='jrb',creationTS=UTC_TIMESTAMP();





