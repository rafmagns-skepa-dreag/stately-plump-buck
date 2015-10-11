#!/usr/bin/python

import sqlite3
import string

db = open("/home/richard/Documents/stats/hw1/IMDB_small.csv", "r")

conn = sqlite3.connect('movies.db')
c = conn.cursor()
data = []


for line in db:
  splitLine = line.split(',')
  i = 0
  if len(splitLine) == 24:
    for i in range(0,7):
      if i == 5:
        splitLine[i] = float(splitLine[i])
      elif i != 1:
        splitLine[i] = int(splitLine[i])

    data.append(splitLine[0:7])

for d in data:
  print d
  c.execute('INSERT INTO movies VALUES (?, ?, ?, ?, ?, ?, ?)', (
    d[0],d[1],d[2],d[3],d[4],d[5],d[6]))

conn.commit()
conn.close()

