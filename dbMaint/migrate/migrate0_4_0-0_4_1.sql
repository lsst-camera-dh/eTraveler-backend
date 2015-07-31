ALTER TABLE ExceptionType ADD returnProcessId int not null after NCRProcessId;
ALTER TABLE ExceptionType ADD KEY `fk83` (`returnProcessId`);
ALTER TABLE ExceptionType ADD CONSTRAINT `fk83` FOREIGN KEY(`returnProcessId`) REFERENCES `Process` (`id`);
INSERT into DbRelease (major, minor, patch, status, createdBy, creationTS, lastModTS, remarks) values (0, 4, 1, 'TEST', 'jrb', NOW(), NOW(), 'bug fix: add column ExceptionType.returnProcessId');
