delimiter //

create procedure generic_subsystem(IN objectId int, IN objectTypeId int)
  READS SQL DATA
  BEGIN
    DECLARE objectTypeName varchar(50);
    select name into objectTypeName from Labelable where id = objectTypeId;
    CASE objectTypeName
      WHEN 'hardware' THEN CALL hardware_subsystem(objectId);
      WHEN 'travelerType' THEN CALL travelerType_subsystem(objectId);
      WHEN 'run' THEN CALL run_subsystem(objectId);
      WHEN 'hardwareType' THEN CALL hardwareType_subsystem(objectId);
      WHEN 'NCR' THEN CALL NCR_subsystem(objectId);
    END CASE;
  END //

delimiter ;
