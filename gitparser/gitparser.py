#!/usr/bin/env python
from bs4 import BeautifulSoup
import datetime
import dateutil.relativedelta
import re
import unicodedata

#Open up our local file and find the table
#mytext=open("helloworld.html")
#soup = BeautifulSoup(mytext, "lxml")
#table = soup.find_all("table", class_="repositories")

#Function to handle weeks and months relative to now and convert into days
def toDays(since):
  sincestr = unicode.join(u'\n',map(unicode,since))
  if "weeks" in sincestr:
    strippedsince = re.sub('( weeks ago)', r'', sincestr)
    sinceindays = int(float(strippedsince))*7
    return sinceindays
  elif "months" in sincestr:
    strippedsince = re.sub('( months ago)', r'', sincestr)
    sinceinmonths = int(float(strippedsince))
    d = datetime.datetime.date(datetime.datetime.now())
    d2 = d - dateutil.relativedelta.relativedelta(months=sinceinmonths)
    sinceindays = (d-d2).days
    return sinceindays

#Open up our local file and find the repo table
mytext=open("git.html")
soup = BeautifulSoup(mytext, "lxml")
table = soup.find_all("table", class_="repositories")

#Iterate through the table and get the repos which have not been modified in last 30 days and print in days the last time they were modified
for line in table:
    for row in line.find_all('tr'):
        repo = row.find_all(class_="left")
        for rp in repo:
          reponame = rp.findAll(text=True)
        lastmodified = row.find_all(class_="age4")
        for lm in lastmodified:
          timesince = lm.findAll(text=True)
          sinceindays = toDays(timesince)
          if (sinceindays >= 30):
            reponamestr = unicode.join(u'', map(unicode,reponame))
            sinceindaysstr = str(sinceindays)
            print "Last modified " + sinceindaysstr + " days ago: " + reponamestr

#Age0 is minutes
#Age1 is hours
#Age2 is days up to including 7 days
#Age3 is up to 27 days
#Age4 is 4 weeks and over and needs to be translated to days

mytext.close()
#regs
#bs4, dateutil
