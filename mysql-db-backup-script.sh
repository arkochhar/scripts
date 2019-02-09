#!/bin/bash
# Author: TechPulseToday
# Publisher: https://www.techpulsetoday.com/

#############BEGIN EDIT AREA######################
# BELOW ARE SOME REQUIRED SETTINGS. CONFIGURE THEM PROPERLY BEFORE USING
# THE SCRIPT

# DBHOSTNAME is the host name of the host that hosts yours MySQL database.
# You can get this from GoDaddy. Just replace the entire contents after =
# with your database host name.
# DBHOSTNAME=xxxxx.db.xxxxxxx.hostedresource.com
DBHOSTNAME='localhost'

# DBUSERNAME is the username to access the MySQL database. Just replace
# the word databaseusername below with your username. No
# quotes needed.
DBUSERNAME='root'

# DBPASSWORD is the password to access the MySQL database. Just replace
# the word databasepassword below with your password database. No
# quotes needed.
DBPASSWORD="root"

# DBNAME is the MySQL database that needs to be backed up. Typically, in
# GoDaddy Linux Hosting this is  the same as the DBUSERNAME
DBNAME='dbname'

# Path of the folder where backups will be stored. $HOME/html will
# automatically put you in the hosting accounts root folder. GoDaddy MySQL
# databases are normally stored in the _db_backups folder within your base
# hosting folder. If the folder does not exist create it before running the
# script. You can also create a subfolder within _db_backups folder if you
# would like to backup the database to a separate folder. Alternatively,
# you can backup to an entirely different folder of your choice. Whatever
# you choose to do, ensure that the path is correctly specified below.
BACKUPFOLDER=$HOME/backups
BINFOLDER=/usr/bin
#BINFOLDER=/opt/lampp/bin

# Should the script delete older files based on the conditions you set
# below (Y or N - uppercase letters only). Choosing Y will maintain only
# recent backups based on your settings below. Choosing N will keep all
# the backups from the past.
DELETEFILES=Y

# Do daily backups Y or N? (one uppercase letter only)
DAILYBACKUP=Y

# Number of recent daily backups to keep. The default is 6 (Sun-Fri) with
# Weekly backup on Sat.All previous backups will be deleted. This is
# meaningless unless DAILYBACKUP is set to Y.
NUMDAILYBACKUPS=6

# Do weekly backups Y or N? (one uppercase letter only). Weekly backups
# are done on Saturdays.
WEEKLYBACKUP=Y

# Number of recent weekly backups to keep. The default is 4. All previous
# weekly backups will be deleted. This is meaningless unless WEEKLYBACKUP
# is set to Y.
NUMWEEKLYBACKUPS=4

# Do monthly backups Y or N? (one uppercase letter only). Monthly backups
# are done on the last day of the month.
MONTHLYBACKUP=Y

# Number of recent monthly backups to keep. The default is 2. All previous
# monthly backups will be deleted. This is meaningless unless
# MONTHLYBACKUP is set to Y.
NUMMONTHLYBACKUPS=2

#############END EDIT AREA######################
#
# DO NOT EDIT ANYTHING BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING.
# WHILE YOU CAN EDIT IT TO CUSTOMIZE HOW THE SCRIPT WORKS, DOING SO CAN
# BREAK THE FUNCTIONING OF THIS SCRIPT.
#

# Create a Backup Folder if not exists
if [[ ! -e ${BACKUPFOLDER} ]]; then
    mkdir -p ${BACKUPFOLDER}
elif [[ ! -d ${BACKUPFOLDER} ]]; then
    echo "${BACKUPFOLDER} already exists but is not a directory" 1>&2
fi

# Set the Date & Time
TODATE=$(date +%d)
TOMORROW=`date +%d -d "1 day"`
TODAY=$(date +%a)
MONTH=$(date +%B)
WEEK=$(date +%U)

if [ $TODATE -gt $TOMORROW ] && [ "$MONTHLYBACKUP" == "Y" ]
then
    $BINFOLDER/mysqldump -h $DBHOSTNAME -u $DBUSERNAME -p$DBPASSWORD $DBNAME  | gzip > $BACKUPFOLDER/$DBNAME'_'`date '+%d%m%Y'`'_'$MONTH.sql.gz
else
    if [ "$TODAY" == "Sat" ] && [ "$WEEKLYBACKUP" == "Y" ]
    then
        $BINFOLDER/mysqldump -h $DBHOSTNAME -u $DBUSERNAME -p$DBPASSWORD $DBNAME  | gzip > $BACKUPFOLDER/$DBNAME'_'`date '+%d%m%Y'`'_'Week$WEEK.sql.gz
    else
        if [ "$DAILYBACKUP" == "Y" ]
        then
            $BINFOLDER/mysqldump -h $DBHOSTNAME -u $DBUSERNAME -p$DBPASSWORD $DBNAME  | gzip > $BACKUPFOLDER/$DBNAME'_'`date '+%d%m%Y'`'_'$TODAY.sql.gz
        fi
    fi
fi


if [ "$DELETEFILES" == "Y" ]
then
    NUMWEEKLY=$[$NUMWEEKLYBACKUPS*7]
    NUMMONTHLY=$[$NUMMONTHLYBACKUPS*31]
    find $BACKUPFOLDER/*Sun.sql.gz -type f -mtime +$NUMDAILYBACKUPS -delete 2> /dev/null
    find $BACKUPFOLDER/*Mon.sql.gz -type f -mtime +$NUMDAILYBACKUPS -delete 2> /dev/null
    find $BACKUPFOLDER/*Tue.sql.gz -type f -mtime +$NUMDAILYBACKUPS -delete 2> /dev/null
    find $BACKUPFOLDER/*Wed.sql.gz -type f -mtime +$NUMDAILYBACKUPS -delete 2> /dev/null
    find $BACKUPFOLDER/*Thu.sql.gz -type f -mtime +$NUMDAILYBACKUPS -delete 2> /dev/null
    find $BACKUPFOLDER/*Fri.sql.gz -type f -mtime +$NUMDAILYBACKUPS -delete 2> /dev/null
    find $BACKUPFOLDER/*Sat.sql.gz -type f -mtime +$NUMDAILYBACKUPS -delete 2> /dev/null
    find $BACKUPFOLDER/*Week*.sql.gz -type f -mtime +$NUMWEEKLY -delete 2> /dev/null
    find $BACKUPFOLDER/*January.sql.gz -type f -mtime +$NUMMONTHLY -delete 2> /dev/null
    find $BACKUPFOLDER/*February.sql.gz -type f -mtime +$NUMMONTHLY -delete 2> /dev/null
    find $BACKUPFOLDER/*March.sql.gz -type f -mtime +$NUMMONTHLY -delete 2> /dev/null
    find $BACKUPFOLDER/*April.sql.gz -type f -mtime +$NUMMONTHLY -delete 2> /dev/null
    find $BACKUPFOLDER/*May.sql.gz -type f -mtime +$NUMMONTHLY -delete 2> /dev/null
    find $BACKUPFOLDER/*June.sql.gz -type f -mtime +$NUMMONTHLY -delete 2> /dev/null
    find $BACKUPFOLDER/*July.sql.gz -type f -mtime +$NUMMONTHLY -delete 2> /dev/null
    find $BACKUPFOLDER/*August.sql.gz -type f -mtime +$NUMMONTHLY -delete 2> /dev/null
    find $BACKUPFOLDER/*September.sql.gz -type f -mtime +$NUMMONTHLY -delete 2> /dev/null
    find $BACKUPFOLDER/*October.sql.gz -type f -mtime +$NUMMONTHLY -delete 2> /dev/null
    find $BACKUPFOLDER/*November.sql.gz -type f -mtime +$NUMMONTHLY -delete 2> /dev/null
    find $BACKUPFOLDER/*December.sql.gz -type f -mtime +$NUMMONTHLY -delete 2> /dev/null
fi
