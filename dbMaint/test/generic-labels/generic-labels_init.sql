-- Seed the tables with some things

-- Define some groups
insert into LabelGroup (name, labelableId, createdBy, creationTS)  select 'RunLabels', Labelable.id, 'jrb', UTC_TIMESTAMP from Labelable where Labelable.name='run';
insert into LabelGroup (name, labelableId, createdBy, creationTS)  select 'CCDLabels', Labelable.id, 'jrb', UTC_TIMESTAMP from Labelable where Labelable.name='hardware';
insert into LabelGroup (name, labelableId, createdBy, creationTS)  select 'SnarkWhere', Labelable.id, 'jrb', UTC_TIMESTAMP from Labelable where Labelable.name='hardware';
insert into LabelGroup (name, labelableId, createdBy, creationTS)  select 'SnarkRandom', Labelable.id, 'jrb', UTC_TIMESTAMP from Labelable where Labelable.name='hardware';
insert into LabelGroup (name, labelableId, createdBy, creationTS)  select 'LocLabels', Labelable.id, 'jrb', UTC_TIMESTAMP from Labelable where Labelable.name='location';
insert into LabelGroup (name, labelableId, createdBy, creationTS)  select 'HtypeLegacy', Labelable.id, 'jrb', UTC_TIMESTAMP from Labelable where Labelable.name='hardware_type';
insert into LabelGroup (name, labelableId, createdBy, creationTS) select 'Boro', Labelable.id, 'jrb', UTC_TIMESTAMP from Labelable where Labelable.name='hardware';


update LabelGroup set hardwareGroupId=(select id from HardwareGroup where HardwareGroup.name='Generic-CCD') where LabelGroup.name='CCDLabels';
update LabelGroup set hardwareGroupId=(select id from HardwareGroup where HardwareGroup.name='snark') where LabelGroup.name='SnarkWhere';
update LabelGroup set hardwareGroupId=(select id from HardwareGroup where HardwareGroup.name='snark') where LabelGroup.name='SnarkRandom';
update LabelGroup set hardwareGroupId=(select id from HardwareGroup where HardwareGroup.name='borogove') where LabelGroup.name='Boro';


update LabelGroup set subsystemId=(select id from Subsystem where name='Legacy') where LabelGroup.name='HtypeLegacy';

update LabelGroup set mutuallyExclusive=1 where name="LocLabels";

-- Make some labels in group RunLabels
insert into Label (name, labelGroupId, createdBy, creationTS) select 'good', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='RunLabels';

insert into Label (name, labelGroupId, createdBy, creationTS) select 'best', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='RunLabels';
insert into Label (name, labelGroupId, createdBy, creationTS) select 'flawed', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='RunLabels';
insert into Label (name, labelGroupId, createdBy, creationTS) select 'hasNCR', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='RunLabels';
insert into Label (name, labelGroupId, createdBy, creationTS) select 'overnight', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='RunLabels'; 
insert into Label (name, labelGroupId, createdBy, creationTS) select 'paused_resumed', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='RunLabels'; 
insert into Label (name, labelGroupId, createdBy, creationTS) select 'ignore', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='RunLabels'; 
insert into Label (name, labelGroupId, createdBy, creationTS) select 'conditionsIssue', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='RunLabels'; 

-- Make some labels in group SnarkWhere
insert into Label (name, labelGroupId, createdBy, creationTS) select 'high', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='SnarkWhere';
insert into Label (name, labelGroupId, createdBy, creationTS) select 'low', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='SnarkWhere';
insert into Label (name, labelGroupId, createdBy, creationTS) select 'underground', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='SnarkWhere';
insert into Label (name, labelGroupId, createdBy, creationTS) select 'inClouds', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='SnarkWhere';
insert into Label (name, labelGroupId, createdBy, creationTS) select 'absent', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='SnarkWhere';
insert into Label (name, labelGroupId, createdBy, creationTS) select 'tulgeyWood', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='SnarkWhere';


-- Make some labels in group SnarkRandom
insert into Label (name, labelGroupId, createdBy, creationTS) select 'green', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='SnarkRandom';
insert into Label (name, labelGroupId, createdBy, creationTS) select 'fuzzy', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='SnarkRandom';
insert into Label (name, labelGroupId, createdBy, creationTS) select 'asleep', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='SnarkRandom';
insert into Label (name, labelGroupId, createdBy, creationTS) select 'annoyed', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='SnarkRandom';
insert into Label (name, labelGroupId, createdBy, creationTS) select 'ticklish', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='SnarkRandom';
insert into Label (name, labelGroupId, createdBy, creationTS) select 'grinning', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='SnarkRandom';

-- Make some labels in group HtypeLegacy
insert into Label (name, labelGroupId, createdBy, creationTS) select 'manufacturedAtSLAC', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='HtypeLegacy';

insert into Label (name, labelGroupId, createdBy, creationTS) select 'delayed', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='HtypeLegacy';

insert into Label (name, labelGroupId, createdBy, creationTS) select 'complete', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='HtypeLegacy';

insert into Label (name, labelGroupId, createdBy, creationTS) select 'noSpares', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='HtypeLegacy';

insert into Label (name, labelGroupId, createdBy, creationTS) select 'obsolete', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='HtypeLegacy';

-- Make some labels in group Boro
insert into Label (name, labelGroupId, createdBy, creationTS) select 'Boro_L1', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='Boro';
insert into Label (name, labelGroupId, createdBy, creationTS) select 'Boro_L2', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='Boro';
insert into Label (name, labelGroupId, createdBy, creationTS) select 'Boro_L3', id, 'jrb', UTC_TIMESTAMP() from LabelGroup where name='Boro';
