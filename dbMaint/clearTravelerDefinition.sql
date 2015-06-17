# Delete all entries created by or for traveler definition, including
# definition of exception types
# Usually clearTravelerExecution.sql should be run first
delete from NextProcessVersion;
delete from InputPattern;
delete from PrerequisitePattern;
delete from ExceptionType;
delete from TravelerTypeStateHistory;
delete from TravelerType;
delete from ProcessEdge;
delete from Process;
