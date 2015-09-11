# Jump-start for traveler definitions predating support for shortDescription
# in YAML
update Process set shortDescription=name where shortDescription is null or length(shortDescription)=0;
 