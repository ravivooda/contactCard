#!/usr/bin/python
# -*- coding: utf-8 -*-

import MySQLdb as mdb
import sys
from settings import settings

def getDB(test=False):
    try:
        con = mdb.connect(settings.MYSQL_SERVER,settings.MYSQL_USERNAME,settings.MYSQL_PASSWORD,settings.MYSQL_DATABASE);
        if test:
            print "Awesome you connected"
        return con
    except Exception,e:
        print "Error occurred in fetching the database, Error: \n%s" % (e)
        return None

def execute(query,values):
    try:
        con = getDB()
        cur = con.cursor()
        cur.execute(query,values)
    except mdb.Error, e:
        print "Error occurred in executing query:\n\t %s\n\tErrors:\n\t%s" % (query, e)
        sys.exit(1)
    finally:
        if con:
            con.close()

def read(query,values):
    try:
        con = getDB()
        cur = con.cursor(mdb.cursors.DictCursor)
        cur.execute(query,values)
        return cur.fetchall()
    except mdb.Error, e:
        print "Error occurred in reading query:\n\t %s\n\tErrors:\n\t%s" % (query, e)
        return None
    finally:
        if con:
            con.close()

def read_one(query,values):
    result = read(query,values)
    if result:
        return result[0]
    return None

def write(query,values):
    try:
        con = getDB()
        cur = con.cursor()
        #query = query + " SELECT LAST_INSERT_ID()"
        cur.execute(query,values)
        con.commit()
        return cur.lastrowid
    except mdb.Error, e:
        print "Error occurred in writing query:\n\t %s\n\tErrors:\n\t%s" % (query, e)
        return None
    finally:
        if con:
            con.close()


if __name__ == "__main__":
    getDB(test=True)
