alter table Activity drop foreign key fk75;
alter table Activity drop activityFinalStatusId;

alter table Hardware drop foreign key fk6;
alter table Hardware drop locationId;

alter table Process drop foreign key fk47;
alter table Process drop foreign key fk48;

alter table Process drop labelGroupId;
alter table Process drop siteId;

update DbRelease set status='CURRENT' where major='0' and minor='15' and patch='3';
delete from DbRelease where major='0' and minor='15' and patch='4';

