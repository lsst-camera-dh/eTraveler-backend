delete from InternalAction where name="genericLabel";
alter table Process drop foreign key fk46;
alter table Process drop genericLabelId;
delete from DbRelease where major='0' and minor='15' and patch='1';
update DbRelease set status='CURRENT' where major='0' and minor='15' and patch='0';
