drop table LabelCurrent;
delete from InputSemantics where name='url';
delete from DbRelease where major=0 and minor=15 and patch=5;
update DbRelease set status='CURRENT' where major=0 and minor=15 and patch=4;
