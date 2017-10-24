#!/usr/bin/env python
import os
import os.path
import re
import sqlalchemy
from optparse import OptionParser

class backfillFromHistory():

    def __init__(self, dbConnectFile='db_connect.txt',item='activityStatus',
                 ifNull=True):
        self.engine = None
        self.dbConnectFile = dbConnectFile
        #self.htmlPat = re.compile("<.*?>")
                
        self.connect()

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

    # If onlyNull is true, only update if activityFinalStatusId is null
    def backfill(self, dryRun=1, item='activityStatus', nullOnly=1):
        if item == 'activityStatus':
            self.itemTable='Activity'
            self.itemField='activityFinalStatusId'
            self.historyTable='ActivityStatusHistory'
            self.historyDataField='activityStatusId'
            self.historyItemField='activityId'
        else:
            if item == 'hardwareLocation':
                self.itemTable='Hardware'
                self.itemField='locationId'
                self.historyTable='HardwareLocationHistory'
                self.historyDataField='locationId'
                self.historyItemField='hardwareId'
            else:
                if item == 'hardwareStatus':
                    self.itemTable='Hardware'
                    self.itemField = 'hardwareStatusId'
                    self.historyTable='HardwareStatusHistory'
                    self.historyDataField='hardwareStatusId'
                    self.historyItemField='hardwareId'
                else:
                    print "item ",item, " not supported"
                    print "Have a nice day"
                    return
            
        print "dryRun is:  ", dryRun

        q = 'select id from ' + self.itemTable
        if int(nullOnly) == 1: q += ' where ' + self.itemField + ' is null '
        q += ' order by id'
        results = self.engine.execute(q)
        row = results.fetchone()
        count = 1
        if (row == None):
            print "No items needing update found"
            return

        while (row != None):
            id = row['id']

            historyQuery = 'select ' + self.historyDataField
            historyQuery += ' from ' + self.historyTable + ' as HT'
            if item == 'hardwareStatus':
                historyQuery += ' join HardwareStatus HS on '
                historyQuery +=  'HT.hardwareStatusId = HS.id'
            historyQuery += ' where ';
            if item == 'hardwareStatus':
                historyQuery += ' HS.isStatusValue=1 and '

            historyQuery += self.historyItemField
            historyQuery += " ='" + str(id) + "' order by "
            historyQuery += "HT.id desc limit 1"
            if int(dryRun) == 1:
                if count < 10 or (count % 100 == 0):
                    print 'About to issue query'
                    print historyQuery
                rs = self.engine.execute(historyQuery)
                r = rs.fetchone()
                statusId = r[self.historyDataField]
                if count < 10 or (count % 100 == 0):
                    print 'New value for ', self.itemTable, ' entry with id ',id, ' is ',statusId
            else:
                upd = 'update ' + self.itemTable + ' set ' + self.itemField
                upd += '=(' + historyQuery + ") where id='"
                upd += str(id) + "'"
                if count < 10 or (count % 100 == 0):
                    print 'About to issue update'
                    print upd
                self.engine.execute(upd)
                if count < 10 or (count % 100 == 0):
                    print 'Updated item in table ', self.itemTable, 'with id=',id
            row = results.fetchone()
            count += 1
            # To start just try a couple
            #if count > 5: return

if __name__ == "__main__":
    usage = " %prog [options] , e.g. \n python backfillFromHistory.py --db=dev \n or \n python backfillFromHistory.py --connectFile=myConnect.txt "

    parser = OptionParser(usage=usage)
    parser.add_option("-d", "--db", dest="db", help="used to compute connect file path: ~/.ssh/db_(option-value).txt")
    parser.add_option("--connectFile", "-f", dest="connectFile", help="path to file containing db connection information")
    parser.add_option("--dryRun", dest="dryRun", help="1 (true) by default. To modify database, use --dryRun=0")
    parser.add_option("--item",dest="item",help="field to extract from history. May be activityStatus (default), hardwareLocation or hardwareStatus")
    parser.add_option("--nullOnly", dest="nullOnly",
                      help="if set (default) only null fields will be overwritten. To write all fields use --nullOnly=0")
    parser.set_defaults(dryRun=1)
    parser.set_defaults(nullOnly=1)
    parser.set_defaults(item="activityStatus");
    parser.set_defaults(db=None)
    parser.set_defaults(connectFile=None)

    (options, args) = parser.parse_args()
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

    back = backfillFromHistory(connectFile)

    dryRun = options.dryRun
    item = options.item
    back.backfill(dryRun=dryRun, item=item, nullOnly=options.nullOnly)
