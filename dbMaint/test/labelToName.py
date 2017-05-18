#!/usr/bin/env python
import os
import os.path
import re
import sqlalchemy
from optparse import OptionParser

class labelToName():

    def __init__(self, dbConnectFile='db_connect.txt'):
        self.engine = None
        self.dbConnectFile = dbConnectFile
        self.htmlPat = re.compile("<.*?>")
                
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

    def formNames(self, dryRun=True):
        # Fetch, id, label from InputPattern where name is null, order by id
        q = "select id, label from InputPattern where name is null"
        u = "update InputPattern set name={0} where id={1}"

        results = self.engine.execute(q)
        row = results.fetchone()
        count = 1
        if (row == None):
            print "No non-null name fields found"
            return

        while (row != None):
            id = row['id']
            label = row['label']
            name = ''.join(self.htmlPat.split(label))
            name = re.sub(' ', '_', name)
            print 'value for name will be ',name
            print 'query will be: '
            uq =  u.format(name, id)
            print uq
            if (not dryRun):
                # self.engine.execute(uq)
                print 'Not ready to do it for real yet'
            row = results.fetchone()
            count += 1
            if dryRun and (count > 100): return
        # For each row
        #     transform label value to suitable value for name
        #     if dryRun == true:
        #        just print it out
        #     else:
        #        update InputPattern set name=(val) where id=(id)


if __name__ == "__main__":
    usage = " %prog [options] , e.g. \n python labelToName.py --db=dev \n or \n python labelToName.py --connectFile=myConnect.txt "

    parser = OptionParser(usage=usage)
    parser.add_option("-d", "--db", dest="db", help="used to compute connect file path: ~/.ssh/db_(option-value).txt")
    parser.add_option("--connectFile", "-f", dest="connectFile", help="path to file containing db connection information")
    parser.add_option("--dryRun", dest="dryRun", help="true by default. To modify database, must have value False")
    parser.set_defaults(dryRun=True)
    parser.set_defaults(db=None)
    parser.set_defaults(connectFile=None)

    (options, args) = parser.parse_args()
    if options.connectFile != None:
        if options.db != None:
            print "connectFile option takes precedence over db option"
        connectFile = options.connectFile
    else:
        if options.db == None:
            raise RunTimeException("one of connectFile, db is required")
        else:
            connectFile = os.path.join(os.environ['HOME'],
                                       '.ssh/db_' + str(options.db) + '.txt')

    ltn = labelToName(connectFile)

    ltn.formNames(options.dryRun)
