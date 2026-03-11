
# load config
if [ -z "$LOG_LEVEL" ]; then
    PACKAGE_CONF='/etc/package/package.conf'
    if [ ! -f "$PACKAGE_CONF" ]; then
        echo 'error: cannot find $PACKAGE_CONF' >&2
        exit 1
    fi
    source $PACKAGE_CONF
fi

# logging functions
LOG_LEVEL_FATAL=0
LOG_LEVEL_ERROR=1
LOG_LEVEL_WARNING=2
LOG_LEVEL_INFO=3
LOG_LEVEL_VERBOSE=4
LOG_LEVEL_DEBUG=5

function log_fatal {
    if [ $LOG_LEVEL -ge $LOG_LEVEL_FATAL ]; then 
        echo 'fatal error:' $@ >&2
    fi
}

function log_error {
    if [ $LOG_LEVEL -ge $LOG_LEVEL_ERROR ]; then 
        echo 'error:' $@ >&1
    fi
}

function log_warning {
    if [ $LOG_LEVEL -ge $LOG_LEVEL_WARNING ]; then 
        echo 'warning:' $@ >&1
    fi
}

function log_info {
    if [ $LOG_LEVEL -ge $LOG_LEVEL_INFO ]; then 
        echo $@ >&1
    fi
}

function log_verbose {
    if [ $LOG_LEVEL -ge $LOG_LEVEL_VERBOSE ]; then 
        echo $@ >&1
    fi
}

function log_debug {
    if [ $LOG_LEVEL -ge $LOG_LEVEL_DEBUG ]; then 
        echo 'debug:' $@ >&2
    fi
}

export -f log_fatal log_error log_warning log_info log_verbose log_debug

