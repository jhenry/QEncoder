#!/bin/bash

CONFIG="config.config"

if [ -f "$CONFIG" ]; then
	
	echo "Sourcing paths for CumulusClips encoder queue daemons...."
	source $CONFIG
	
	if [[ -f $Q_DAEMON_PATH && -f $LOG_PATH ]]; then
		echo "Starting CumulusClips encoder queue daemons..."
		$Q_DAEMON_PATH 0 >> $LOG_PATH &
		$Q_DAEMON_PATH 1 >> $LOG_PATH &
		$Q_DAEMON_PATH 2 >> $LOG_PATH &
		$Q_DAEMON_PATH 3 >> $LOG_PATH &
		$Q_DAEMON_PATH 4 >> $LOG_PATH &
		$Q_DAEMON_PATH 5 >> $LOG_PATH &
		$Q_DAEMON_PATH 6 >> $LOG_PATH &
		$Q_DAEMON_PATH 7 >> $LOG_PATH &
	fi

fi
