delimiter //

create procedure generic_hardwareGroups(IN objectId int, IN objectTypeId int)
  READS SQL DATA
  BEGIN
    DECLARE objectTypeName varchar(50);
    select name into objectTypeName from Labelable where id = objectTypeId;
    CASE objectTypeName
      WHEN 'hardware' THEN CALL hardware_hardwareGroups(objectId);
      WHEN 'travelerType' THEN CALL travelerType_subsystem(objectId);
      WHEN 'run' THEN CALL run_hardwareGroups(objectId);
      WHEN 'hardwareType' THEN CALL hardwareType_hardwareGroups(objectId);
      WHEN 'NCR' THEN CALL NCR_hardwareGroups(objectId);
    END CASE;
  END //

delimiter ;
