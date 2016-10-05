alter table RunNumber drop index ix373;
alter table RunNumber drop runInt;
delete from DbRelease where major='0' and minor='12' and patch='1';
