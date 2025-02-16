#!/bin/bash

set -xe

trap_handler() {
  echo "Traphandler received signal. Exiting ..."
  exit
}
trap trap_handler SIGINT SIGTERM SIGABRT SIGQUIT SIGUSR1 SIGUSR2


CURRENTUSER=`whoami`
CURRENTUSERID=`id`

echo "WHOAMI: ${CURRENTUSER}"
echo "ID: ${CURRENTUSERID}"

if [[ -f /app/env.local ]]; then
  echo "Loading local env vars ..."
  source /app/env.local
fi

case $1 in

  "agent")
    echo "Starting server ..."
    export PYTHONPATH=/app/src:$PYTHONPATH
    export PYTHONUNBUFFERED=1
    exec python3 /app/agent.py
    ;;

  "gunicorn")
    echo "Starting gunicorn ..."
    GUNICORN=$(which gunicorn)
    echo "Gunicorn path: $GUNICORN"
    if [[ -z $GUNICORN ]]; then
      echo "ERROR: gunicorn not found"
      exit 1
    fi
    NAME="localapi"
    BIND=0.0.0.0:5000
    NUM_WORKERS=3
    WSGI_MODULE=wsgi
    export PYTHONPATH=/app/src:$PYTHONPATH
    exec $GUNICORN ${WSGI_MODULE}:app \
      --chdir /app \
      --name $NAME \
      --workers $NUM_WORKERS \
      --bind=$BIND \
      --log-level=debug \
      --log-file=- \
      --timeout=3600
      #--user=kuser --group=kuser \
      #--pid "${GUNICORN_PID_FILE}"
    ;;


  *)
    echo "Executing unknown command: $@"
    # KUSER=kuser
    # exec su -c "$@" $KUSER
    exec "$@"
    ;;
esac
