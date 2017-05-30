alter table Label drop description;
alter table LabelGroup drop description;

alter table FloatResultManual drop valueString;
alter table InputPattern drop index ix135;
alter table InputPattern drop name;

delete from DbRelease where major='0' and minor='15' and patch='2';
update DbRelease set status='CURRENT' where major='0' and minor='15' and patch='1';

