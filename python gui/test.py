#!/bin/bin/python

from Tkinter import *
import ttk
import tkMessageBox
import tkFont
import sqlite3

# just a simple message box
def helloCallBack():
  tkMessageBox.showinfo("Testing", "YO." )

def submitCallBack():
  tkMessageBox.showinfo("Submission completed", "Thank you for your submission. We will be back to you shortly")

# thanks to
def treeviewSortCol(tv, col, reverse):
  l = [(tv.set(k, col), k) for k in tv.get_children("")]
  l.sort(reverse=reverse)

  for index, (val, k) in enumerate(l):
    tv.move(k, '', index)

  tv.heading(col, command=lambda: \
      treeviewSortCol(tv,col,not reverse))

def getTableNames(tn):
  c.execute('PRAGMA TABLE_INFO({})'.format(tn))
  names = [tup[1] for tup in c.fetchall()]
  return names

def getByLength(len, tree):
  c.execute('SELECT * FROM movies WHERE length > 10')
  l = c.fetchall()
  for line in l:
    tree.insert("", END, values=(line[0],line[1],line[2],line[3],line[4],line[5],line[6]))



top = Tk()
helv36 = tkFont.Font (family="Helvetica", size=36)
frame = Frame(top)
frame.pack()

bottomFrame = Frame(top)
bottomFrame.pack( side=BOTTOM )

columnNames = getTableNames('movies')

tree = ttk.Treeview(bottomFrame, columns=columnNames, show="headings", height=20)
for col in columnNames:
    tree.heading(col, text=col, command=lambda _col=col: \
                     treeviewSortCol(tree, _col, False))

getByLength(100, tree)


scrollbar_right = ttk.Scrollbar (bottomFrame, command=tree.yview, orient=VERTICAL)
scrollbar_right.pack(side=RIGHT, fill=Y)

scrollbar_bottom = ttk.Scrollbar (bottomFrame, command=tree.xview, orient=HORIZONTAL)
scrollbar_bottom.pack(side=BOTTOM, fill=X)

tree.configure(yscrollcommand=scrollbar_right.set, xscrollcommand=scrollbar_bottom.set)
tree.pack(side=TOP,expand=YES,fill=BOTH)

# Add new movie popup
# newEntry = Tk()

# newEntryFrame = Frame(newEntry)
# newEntryFrame.pack(expand=YES, fill=BOTH)





if __name__ == "main":
  # connect to the table
  conn = sqlite3.connect('movies.db')
  # conn.commit() saves changes
  # conn.close() closes the db
  # cursor for the table
  c = conn.cursor()
  top.mainloop()
  conn.close()
