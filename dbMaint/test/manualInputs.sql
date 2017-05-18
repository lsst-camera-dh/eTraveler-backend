alter table FloatResultManual add column valueString varchar(60)  COMMENT 'save value just as operator entered it' after value;
alter table InputPattern add column name varchar(255) NULL COMMENT 'one-word identifier for field' after label;

alter table InputPattern add constraint  unique key ix135 (processId,name);
