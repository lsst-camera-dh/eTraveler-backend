#!/usr/bin/env python
import os
import os.path
import sqlalchemy
from argparse import ArgumentParser

class copyLabelHistory():

    def __init__(self, groupName, dbConnectFile='db_connect.txt'):
        self.engine = None
        self.dbConnectFile = dbConnectFile
        self.connect()
        self.groupName = groupName
        self.groupId=None
        self.labelabelId=None
        
    def connect(self):
        kwds = {}
        try:
            with open(self.dbConnectFile) as f:
                for line in f:
                    (key, val) = line.split()
                    kwds[key] = val
        except IOError:
            raise IOError, "Unable to open db connect file" + self.dbConnectFile

        # Create a new mysql connection object.
        db_url = sqlalchemy.engine.url.URL('mysql+mysqldb', **kwds)
        self.engine = sqlalchemy.create_engine(db_url)

    def getHardwareLabelable(self):
        q = "select id from Labelable where name='hardware'"
        results = self.engine.execute(q)
        row = results.fetchone()
        if (row == None):
            raise Exception("Could not find hardware labelable type")
        self.labelableId = row['id']

    def getGenericGroupId(self):
        # assume group name has been passed in via arg
        q = "select id from LabelGroup where labelableId='"
        q += str(self.labelableId) + "' and name='" + self.groupName + "'"
        results = self.engine.execute(q)
        row = results.fetchone()
        if (row == None):
            raise Exception("Could not find hardware labelable type")
        self.groupId = row['id']

        
    def fetchOldHistory(self):
        if self.groupId == None:
            self.getHardwareLabelable()
            self.getGenericGroupId()
        q="select hardwareId,reason,adding,activityId,HSH.createdBy,HSH.creationTS,HS.name as hsName,Label.id as genLabelId "
        q+="from HardwareStatusHistory HSH join HardwareStatus HS on "
        q+="HSH.hardwareStatusId=HS.id join Label on Label.name=HS.name "
        q+="where HS.isStatusValue=0 and Label.labelGroupId='"
        q+=str(self.groupId) + "'"

        print 'Fetch query is: '
        print q

        self.oldHistory = self.engine.execute(q)
        
    def setNewHistory(self, dryRun):
        print "dryRun is", dryRun
    
        iTemplate="insert into LabelHistory (objectId,labelableId,labelId,"
        iTemplate+="reason,adding,activityId,createdBy,creationTS) value "
        iTemplate+="('{0}','{1}','{2}','{3}','{4}',{5},'{6}','{7}')"
        results = self.oldHistory
        row = results.fetchone()

        while row != None:
            activityId=row['activityId']
            if activityId == None:
                activityId = 'NULL'
            else:
                activityId = "'" + str(activityId) + "'"
                
            iQuery = iTemplate.format(str(row['hardwareId']),
                                      str(self.labelableId),
                                      str(row['genLabelId']),
                                      str(row['reason']),
                                      str(row['adding']),
                                      activityId,
                                      str(row['createdBy']),
                                      str(row['creationTS']))
            print "insert query is: "
            print iQuery
            if dryRun == 0:
                self.engine.execute(iQuery)
            row = results.fetchone()
if __name__ == "__main__":
    usage = " %prog [options] , e.g. \n python labelToName.py myLabelGroup --db=dev \n or \n python labelToName.py myLabelGroup --connectFile=myConnect.txt "

    parser = ArgumentParser(description="Copy old hardware label history to new generic label history, using labels from specified hardware label group")
    parser.add_argument("-d", "--db", dest="db", help="used to compute connect file path: ~/.ssh/db_(option-value).txt")
    parser.add_argument("--connectFile", "-f", dest="connectFile", help="path to file containing db connection information")
    parser.add_argument("--dryRun", dest="dryRun", choices=[0, 1], type=int,
                        help="1 (true) by default. To modify database, use --dryRun=0")
    parser.add_argument("group", help="label group containing generic labels to be applied")
    parser.set_defaults(dryRun=1)
    parser.set_defaults(db=None)
    parser.set_defaults(connectFile=None)
    
    options = parser.parse_args()
    if options.connectFile != None:
        if options.db != None:
            print "connectFile option takes precedence over db option"
        connectFile = options.connectFile
    else:
        if options.db == None:
            raise RuntimeError("one of connectFile, db is required")
        else:
            connectFile = os.path.join(os.environ['HOME'],
                                       '.ssh/db_' + str(options.db) + '.txt')

    copier = copyLabelHistory(options.group, connectFile)

    copier.fetchOldHistory()
    copier.setNewHistory(options.dryRun)
    
