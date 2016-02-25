update HardwareType set subsystemId=(select id from Subsystem where name='Legacy') where subsystemId is NULL;
