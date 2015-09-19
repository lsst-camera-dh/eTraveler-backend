ALTER TABLE JobHarness drop index ix261;
ALTER TABLE JobHarness drop description;
ALTER TABLE JobHarness drop name;

UPDATE DbRelease set status="REVERTED" where major="0" and minor="8" and patch="1";

