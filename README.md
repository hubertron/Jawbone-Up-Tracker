upstats
=======

This is a simple rails 4 / ruby 2 dashboard website for displaying information from the Jawbone Up wristband. It interacts with the Jawbone Up api. 

You can check out a demo at [http://upstats.herokuapp.com](http://upstats.herokuapp.com)

setup
=====

UpStats uses a small postgres database to keep some user information in it like first name, last name and your token for communicating with the Jawbone Api. It does not save any other information about your stats.

development
===========

All the information for the jawbone api is in the lib/jawbone folder. There is some interesting stuff there if you want to figure out how to communicate with the api.


run your own
============

It's really easy, just make sure you checkout the code, have rails 4 and ruby 2 installed.
