#!/bin/bash
# If dockerfile failed install manually
if [ ! -f "/usr/bin/bashio" ]; then
    echo "Bashio does not exist, executing script"
    (
        #######################
        # Automatic installer #
        #######################
        curl -L -f -s "https://raw.githubusercontent.com/alexbelgium/hassio-addons/master/zzz_templates/automatic_packages.sh" --output /automatic_packages.sh
        chmod 777 /automatic_packages.sh
        eval /./automatic_packages.sh
        rm /automatic_packages.sh

    ) >/dev/null

fi
