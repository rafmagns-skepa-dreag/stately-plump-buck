#!/bin/bash
#A script to make updating the College IT Drupal 7 sites easier

echo "Now starting automated University of Chicago -- College IT Drupal 7 updater.
Have you already uninstalled unused modules? (y/n): "
read uninstall

if [ "$uninstall" != "y" ]
then
    echo "Please uninstall unused modules on all sites before proceeding."
fi

echo "Are you updating prod or dev? (p/d): "
read update_type

if [ "$update_type" != "p" ]
then
    TYPE=".dev"
else
    TYPE=".prod"
fi

ROOT_UID=0
E_BACKUP=55
E_PERMS=65
E_UP=75
E_CACHE=85
D7="@d7."
#eventually going to migrate this to a separate file so this one doesn't have to be touched -- can just be a file with the names separated by new lines
SITE_NAMES={"avc","cha","chicagostudies","college","collegebridge","collegesurveys","crescat","filmstudiescenter","frogs","hexagon","oaides","petition","slushpuppy","study-abroad","umbrella"}
#SITE_NAMES="cha"
BEWARE="
BEWARE
Modules to beware of include: Media (must be -alpha3) and Feeds (must be --dev). Please check the wiki just to be sure before updating modules.
ERAWEB
"

# SITE_NAMES=()

# while read line || [ -n "$line" ]; do
#     echo "$line"
#     SITE_NAMES+=("$line")
# done < "$1"

# echo "$SITE_NAMES"
# for site in $SITE_NAMES; do
# 	echo "$site"
# done

# AVC="avc"
# CHA="cha"
# CHICAGO="chicagostudies"
# COLLEGE="college"
# BRIDGE="collegebridge"
# SURVEYS="collegesurveys"
# CRESCAT="crescat"
# FILM="filmstudiescenter"
# FROGS="frogs"
# HEX="hexagon"
# OAIDES="oaides"
# OBOOK="obook"
# PETITION="petition"
# DB="slushpuppy"
# SA="study-abroad"
# UMBRELLA="umbrella"


cd '/var/www/webfiles/college/drupal7/sites'

#backup the sites before starting
drush -y @sites bam-backup --quiet # || {echo "PROBLEMS BACKING UP"; exit E_BACKUP }
echo "
Backup complete
"

sudo cd7 perms college7 --quiet# || { echo "PROBLEMS FIXING PERMISSIONS"; exit E_PERMS }
echo "
Permissions on core have been fixed
"

#Drupal must be updated from within one of the site directories
cd '/var/www/webfiles/college/drupal7/sites/avc.uchicago.edu'

#update Drupal
drush -y up drupal # || { echo "PROBLEMS UPDAING DRUPAL CORE"; exit E_UP }
echo "
Drupal Core has been updated as needed
"

cd ..

#Clear all caches for all sites
drush -y @sites cc all --quiet # || { echo "PROBLEMS CLEARING CACHES"; exit E_CACHE }
echo "
Caches have been cleared
"

#Refresh sites to make sure that everything shows up properly
drush -y @sites refresh --quiet # || { echo "PROBLEMS REFRESHING"; exit E_CACHE }
echo "
All sites have been refreshed
"

#Begin the updating loop
for site in $SITE_NAMES; do
    drush $D7$site$TYPE ups
    echo "$BEWARE"
    echo "Do you want to proceed with the listed updates? (y/n): "
    read proceed

    if [ "$proceed" = "y" ]; then
        drush -y $D7$site$TYPE up
        echo "Updates have been completed"
    else
        echo "Please enter name(s) of the modules (excluding dev branches) you wish to update. ([ENTER]/module names): "
        read module_names
        if [ "z$module_names" != "z" ]; then
            drush $D7$site$TYPE up $module_names
            echo "Updates complete"
        fi

        echo "Please enter the name of any dev branches you wish to update. ([ENTER]/module names): "
        read module_names
        if [ "z$module_names" != "z" ]; then
            drush $D7$site$TYPE pm-updatecode
        fi
    fi

    drush $D7$site$TYPE updatedb
    echo "Database has been updated as needed"

    echo "Were there errors and/or do you want to rebuild the registry? (y/n)"
    read rebuild
    if [ "$rebuild" = "y" ]; then
        drush $D7$site$TYPE rr
    fi

    cd7 perms $site
    echo "
    Permissions have been fixed for $site
    "

    cd7 perms college7
    echo "
    Permissions have been fixed for core
    "

done

exit 0