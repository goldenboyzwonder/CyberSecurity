#!/bin/bash

#Create a research directory
cd /home/sysadmin/.
mkdir research.

#check to see if the auth.log exists
ls /var/log/auth.log

#check to see if you have a Desktop and Downloads directory.
ls /home/sysadmin/.

#check to see if you can find cat and ps binary files.
ls /bin/cat.
ls /bin/ps.

#Check to see if there are any scripts in temporary directories.
ls /tmp.

#Check that the only users with accounts in the /home directory are adam, billy, instructor, jane, john max, sally, student, sysadmin and vagrant.
ls /home.
