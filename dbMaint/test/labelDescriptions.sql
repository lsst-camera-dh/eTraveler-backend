alter table Label add column description varchar(5120) default '' after name;
alter table LabelGroup add column description varchar(5120) default '' after name;
