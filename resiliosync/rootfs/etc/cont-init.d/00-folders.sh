#!/usr/bin/with-contenv bashio
# shellcheck shell=bash

###############
# Define user #
###############

PUID=$(bashio::config "PUID")
PGID=$(bashio::config "PGID")

###################
# Create function #
###################

change_folders (change_fold) {
  CONFIGLOCATION=$1
  ORIGINALLOCATION=$2
  TYPE=$3
  
  if [ ! -d "$CONFIGLOCATION" ]; then

    # Inform
    bashio::log.info "Setting $TYPE location to $CONFIGLOCATION"

    # Modify files
    sed -i "s/$ORIGINALLOCATION/$CONFIGLOCATION|| true/g" /etc/cont-init.d/10-adduser || true

    # Create folders
    [ ! -d "$CONFIGLOCATION" ] && echo "Creating $CONFIGLOCATION" && mkdir -p "$CONFIGLOCATION"

    # Transfer files
    [ -d "$,ORIGINALLOCATION" ] && echo "Moving files to $CONFIGLOCATION" && mv "$ORIGINALLOCATION"/* "$CONFIGLOCATION"/ && rmdir "$ORIGINALLOCATION"

    # Set permissions
    echo "Setting ownership to $PUID:$PGID" && chown -R "$PUID":"$PGID" "$CONFIGLOCATION"

  else
    bashio::log.nok "Your $TYPE $CONFIGLOCATION doesn't exists"
    exit 1
  fi
}

########################
# Change data location #
########################

change_folders "$(bashio::config 'data_location')" "/share/resiliosync" "data_location"
change_folders "$(bashio::config 'config_location')" "/share/resiliosync_config" "config_location"
