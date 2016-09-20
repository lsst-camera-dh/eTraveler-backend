alter table FilepathResultHarnessed add datatype varchar(255) COMMENT "datatype used to register in Data Catalog" after catalogKey;
alter table FilepathResultHarnessed add basename varchar(255) COMMENT "extracted from full filepath stored in value" after value;
alter table FilepathResultHarnessed add index ix177 (datatype);
alter table FilepathResultHarnessed add index ix178 (basename);

