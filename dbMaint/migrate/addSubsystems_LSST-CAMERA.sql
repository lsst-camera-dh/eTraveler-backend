insert into Subsystem (name, shortName, description, generic, createdBy, creationTS) values ("Exchange System", "EXCH", "Umbrella for subsubsystems Carousel, Auto Changer, Filter Loader", '0', 'jrb', UTC_TIMESTAMP());
insert into Subsystem (name, shortName, description, generic, createdBy, creationTS) values ("Auto Changer", "CHGR", "", '0', 'jrb', UTC_TIMESTAMP());

insert into Subsystem (name, shortName, description, generic, createdBy, creationTS) values ("Carousel", "CAR", "", '0', 'jrb', UTC_TIMESTAMP());

insert into Subsystem (name, shortName, description, generic, createdBy, creationTS) values ("Filter Loader", "LDR", "", '0', 'jrb', UTC_TIMESTAMP());

insert into Subsystem (name, shortName, description, generic, createdBy, creationTS) values ("Camera Body and Shutter", "CBS", "", '0', 'jrb', UTC_TIMESTAMP());

insert into Subsystem (name, shortName, description, generic, createdBy, creationTS) values ("Camera Body", "CBDY", "", '0', 'jrb', UTC_TIMESTAMP());

insert into Subsystem (name, shortName, description, generic, createdBy, creationTS) values ("Shutter", "SHTR", "", '0', 'jrb', UTC_TIMESTAMP());

insert into Subsystem (name, shortName, description, generic, createdBy, creationTS) values ("Science Raft", "SR", "", '0', 'jrb', UTC_TIMESTAMP());

insert into Subsystem (name, shortName, description, generic, createdBy, creationTS) values ("Corner Raft", "CR", "", '0', 'jrb', UTC_TIMESTAMP());

insert into Subsystem (name, shortName, description, generic, createdBy, creationTS) values ("Cryostat", "CRYO", "", '0', 'jrb', UTC_TIMESTAMP());

insert into Subsystem (name, shortName, description, generic, createdBy, creationTS) values ("Utility Trunk", "UT", "", '0', 'jrb', UTC_TIMESTAMP());

insert into Subsystem (name, shortName, description, generic, createdBy, creationTS) values ("Integration and Test", "INT", "", '0', 'jrb', UTC_TIMESTAMP());

insert into Subsystem (name, shortName, description, generic, createdBy, creationTS) values ("Optics", "OPT", "", '0', 'jrb', UTC_TIMESTAMP());

insert into Subsystem (name, shortName, description, generic, createdBy, creationTS) values ("Data Acquisition", "DAQ", "", '0', 'jrb', UTC_TIMESTAMP());

create temporary table minisub (miniid int, minishort varchar(16));
insert into minisub (miniid, minishort) select id, shortName from Subsystem;

update Subsystem set parentId=(select miniid from minisub where minishort='EXCH') where shortName='CHGR';
update Subsystem set parentId=(select miniid from minisub where minishort='EXCH') where shortName='CAR';
update Subsystem set parentId=(select miniid from minisub where minishort='EXCH') where shortName='LDR';
update Subsystem set parentId=(select miniid from minisub where minishort='CBS') where shortName='CBDY';
update Subsystem set parentId=(select miniid from minisub where minishort='CBS') where shortName='SHTR';
update Subsystem set parentId=(select miniid from minisub where minishort='CRYO') where shortName='UT';
