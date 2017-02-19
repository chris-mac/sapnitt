Git repo parser
==============
The `gitparser.py` file allows us to take the list of repos contained within the `git.html` file and provide a list of repos that have not been modified for 30 days and shows when they were last modified in days.

##Notes
Like any scraping mechanism the script is fragile as we rely on HTML classes that are often used for layout and presentation rather than semantics.

##Requirements
All requirements should be available via pip
- bs4
- dateutil
  

