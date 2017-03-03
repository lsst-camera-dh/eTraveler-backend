update Process set jobname=name where jobname is null and (travelerActionMask & 1) = 1;
