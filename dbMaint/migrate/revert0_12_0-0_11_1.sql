drop table RunNumber;
alter table FilepathResultHarnessed drop index ix177;
alter table FilepathResultHarnessed drop index ix178;
alter table FilepathResultHarnessed drop datatype;
alter table FilepathResultHarnessed drop basename;

delete from DbRelease where major='0' and minor='12' and patch='0';
