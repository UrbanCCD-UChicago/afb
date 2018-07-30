# AoT File Browser

The Array of Things File Browser (AFB) is a multi-step process and application.
It consists of a handful of data preprocessors that run scripts on a server
within the AoT realm and the web application lives out on AWS.

## Web App

The web app is a standard Phoenix application. There's a handful of routes that
display information and a single route responsible for getting data from S3
to update the database's cache of data set metadata.

## Preprocessors

There is a single Python script (taken from the Waggle data tools) and
a series of bash scripts to coordinate processing batches.

The processes are kicked off by cron. There are daily, weekly, biweekly, and
monthly jobs. Each of these are coordinated by the script named
`cron-${epoch}.bash` that in turn call the slicing bash script. These scripts
download tarballs, call the Python slicing script, repackage the slices and
upload them to S3.

The daily script also calls the processing route of the web application to
kick off the metadata refresh routine.
