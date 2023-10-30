import os
from sqlalchemy import create_engine, MetaData, select, update

DEFAULT_IN = "http://srs.slac.stanford.edu/Decorator/exp/LSST-CAMERA"
DEFAULT_OUT = "https://lsst-camera.slac.stanford.edu/Decorator/exp/LSST-CAMERA"
NODE = "mysql-node03.slac.stanford.edu"

def fix_field(dbname='rd_lsst_cmdv', usertype="app", instring=DEFAULT_IN,
              outstring=DEFAULT_OUT, table="Process",
              field="description", just_one=None):

    pfile = os.path.join(os.getenv('HOME'), 'db_' + usertype)

    with open(pfile) as f:
        pw = f.readline().strip()
    sqlalch_url = f"mysql://{dbname}_{usertype}:{pw}@{NODE}/{dbname}"
    eng = create_engine(sqlalch_url)
    conn = eng.connect()
    meta = MetaData()
    meta.reflect(bind=conn)     # now has references to tables
    table_ref = meta.tables[f"{table}"]
    ref_field = table_ref.c[field]
    ref_id = table_ref.c.id
    stmt = select(ref_id, ref_field).select_from(table_ref)
    stmt = stmt.where(ref_field.contains(instring))
    if just_one:
        stmt = stmt.where(ref_id.__eq__(just_one))
        print(stmt)

        result = conn.execute(stmt)
        row = result.fetchone()
        print(f"For id {row[0]} in table {table}  found field \n{row[1]}")

        # update this one row
        descr = row[1]
        new_descr = descr.replace(instring, outstring)
    
        print("New description:\n", new_descr)
    
        update_stmt = update(table_ref).where(ref_id.__eq__(just_one))
        update_stmt = update_stmt.values(description=new_descr)
        print(update_stmt)
        conn.execute(update_stmt)
        return

    # Otherwise fix all offending fields
    print('Query to find bad rows: ')
    print(stmt)
    result = conn.execute(stmt)
    cnt = 0
    for row in result:
        cnt += 1
        descr = row[1]
        new_descr = descr.replace(instring, outstring)
        update_stmt = update(table_ref).where(ref_id.__eq__(row[0]))
        update_stmt = update_stmt.values(description=new_descr)
        #print(f'id: {row[0]}, original descr:\n{descr}\n new:\n{new_descr}')
        #print(update_stmt)
        conn.execute(update_stmt)
    print(f'Updated {cnt} rows in table {table}')
        
#fix_field(usertype="app", table="Process")
#fix_field(usertype="app", table="InputPattern")
#fix_field(table="PrerequisitePattern", dbname="rd_lsst_cam")
#fix_field(table="InputPattern", dbname="rd_lsst_cam")
#fix_field(table="Process", dbname="rd_lsst_cam")
#fix_field(table="Process", dbname="rd_lsst_cam",
#          instring="https://srs.slac.stanford.edu/Decorator/exp/LSST-CAMERA")
fix_field(table="PrerequisitePattern", dbname="rd_lsst_cam",
          instring="https://srs.slac.stanford.edu/Decorator/exp/LSST-CAMERA")

    
    
    
