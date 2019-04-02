#!/usr/bin/env python
from __future__ import print_function
import os
import os.path
import sqlalchemy
from argparse import ArgumentParser

class CopyLabels():

    def __init__(self, labelable=None, dbConnectFile='db_connect.txt'):
        self.engine = None
        self.dbConnectFile = dbConnectFile
        self.connect()
        self.labelable=labelable
        self.labelableId=None
        
    def connect(self):
        kwds = {}
        try:
            with open(self.dbConnectFile) as f:
                for line in f:
                    (key, val) = line.split()
                    kwds[key] = val
        except IOError:
            raise IOError("Unable to open db connect file" + self.dbConnectFile)

        # Create a new mysql connection object.
        db_url = sqlalchemy.engine.url.URL('mysql+mysqldb', **kwds)
        self.engine = sqlalchemy.create_engine(db_url)

    def getLabelableId(self):
        if self.labelableId is None:
            q = "select id from Labelable where name='" + self.labelable + "'"
            results = self.engine.execute(q)
            row = results.fetchone()
            if (row == None):
                raise Exception("Could not find hardware labelable type")
            self.labelableId =  str(row['id'])
        return self.labelableId


    def fetchLabeled(self):
        where = " "
        if self.labelable is not None:
            self.labelableId = self.getLabelableId()
            where = " WHERE labelableId=' " + self.labelableId + "' "
        q = "select objectId,labelableId,labelId,reason,adding,activityId,createdBy,creationTS,id from LabelHistory"
        q += where
        q += " order by objectId asc,labelId asc, id desc"

        print(q)

        results = self.engine.execute(q)
        row = results.fetchone()
        toDo = []
        insert = "insert into LabelCurrent (objectId,labelableId,labelId,reason,adding,"
        insert += "activityId,createdBy,creationTS)"
        insert += " values({objectId},{labelableId},{labelId},'{reason}',{adding},"
        insert += "{activityId},'{createdBy}','{creationTS}') "
        update = "update LabelCurrent set reason='{reason}',adding={adding},activityId={activityId},"
        update += "createdBy='{createdBy}',creationTS='{creationTS}' "
        update += " where objectId={objectId} and labelId={labelId}"
        #insert += " on duplicate key update reason='{reason}',"
        #insert += " adding={adding},activityId={activityId},createdBy='{createdBy}',creationTS='{creationTS}'"
        first = True
        oldOid = None
        oldLid = None
        while row != None:
            activityId=row['activityId']
            if activityId == None:
                activityId = 'NULL'
            objectId = str(row['objectId'])
            labelableId = str(row['labelableId'])
            labelId = str(row['labelId'])
            adding = str(row['adding'])
            id = str(row['id'])
            print('Found (objectId, labelId, id)  (',objectId,',',labelId,',',id,')') 
            if (objectId == oldOid) and (labelId == oldLid):
                print('Skipping match')
                row = results.fetchone()
                continue
            else:
                oldOid = objectId
                oldLid = labelId
            reas = str(row['reason'])
            reason = reas.replace("'", "\\'")
            createdBy = str(row['createdBy'])
            creationTS = str(row['creationTS'])
            toDo.append({'insert': insert.format(**locals()), 'update': update.format(**locals()),
                         'objectId': objectId, 'labelId' : labelId, 'creationTS' : creationTS})
            if first:
                print("First insert would be ")
                print(toDo[0]['insert'])
                print("First update would be ")
                print(toDo[0]['update'])
                      
                first = False
            row = results.fetchone()
        print("Found ", len(toDo), " objects with labels")
        return toDo
            
        
    def setCurrent(self, toDo, dryRun):
        print( "dryRun is", dryRun)
        print("# inserts/updates: ", len(toDo))
        q_template = "SELECT creationTS from LabelCurrent where objectId={objectId}"
        q_template += " and labelId={labelId}"
        with self.engine.connect() as conn:
                
            for e in toDo:
                labelId = e['labelId']
                objectId = e['objectId']
                creationTS = e['creationTS']
                    
                results = conn.execute(q_template.format(**locals()))
                row = results.fetchone()
                if  row == None:           # do insert
                    print('Do insert: ', e['insert'])
                    if dryRun:
                        print('dry run only')
                    else:
                        conn.execute(e['insert'])

                else:
                    currentTS = str(row['creationTS'])
                    if creationTS > currentTS:  # shouldn't happen, but if it does, do update
                        print('Do update: ', e['update'])
                        if dryRun:
                            print("Dry run only")
                        else:
                            conn.execute(e['update'])
                    else:                  
                        print("Do nothing; we're up to date")

if __name__ == "__main__":
    usage = " %prog [options] , e.g. \n python labelToName.py myLabelGroup --db=dev \n or \n python labelToName.py myLabelGroup --connectFile=myConnect.txt "

    parser = ArgumentParser(description="Copy old label history to LabelCurrent, using labels from specified hardware label group")
    parser.add_argument("-d", "--db", dest="db", help="used to compute connect file path: ~/.ssh/db_(option-value).txt")
    parser.add_argument("--connectFile", "-f", dest="connectFile", help="path to file containing db connection information")
    parser.add_argument("--dryRun", dest="dryRun", choices=[0, 1], type=int,
                        help="1 (true) by default. To modify database, use --dryRun=0")
    parser.add_argument("--labelable", default=None, help="label group containing generic labels to be applied")
    parser.set_defaults(dryRun=1)
    parser.set_defaults(db=None)
    parser.set_defaults(connectFile=None)
    
    options = parser.parse_args()

    if options.connectFile != None:
        print("Got connectFile option")
        if options.db != None:
            print("connectFile option takes precedence over db option")
        connectFile = options.connectFile
    else:
        if options.db == None:
            raise RuntimeError("one of connectFile, db is required")
        else:
            print("db is ",str(options.db))
            connectFile = os.path.join(os.environ['HOME'],
                                       '.ssh/db_' + str(options.db) + '.txt')
    print('connect file is ', connectFile)
    if options.labelable is not None:
        print("Searching for labeled objects of type ", options.labelable)

    copier = CopyLabels(options.labelable, connectFile)

    toDo = copier.fetchLabeled()
    copier.setCurrent(toDo, options.dryRun == 1)
    
