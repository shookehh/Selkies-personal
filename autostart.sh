#!/bin/bash
# Runs once when the desktop session starts.
# Priority: AUTOSTART_CMD (arbitrary command) > AUTOSTART_URL (Chrome app window) > nothing

LOG=/tmp/autostart.log

if [ -n "$AUTOSTART_CMD" ]; then
  echo "[autostart] running AUTOSTART_CMD: $AUTOSTART_CMD" >>"$LOG"
  nohup /bin/sh -c "$AUTOSTART_CMD" >>"$LOG" 2>&1 &
elif [ -n "$AUTOSTART_URL" ]; then
  echo "[autostart] opening AUTOSTART_URL in Chrome: $AUTOSTART_URL" >>"$LOG"
  nohup /usr/bin/google-chrome-stable --no-sandbox --disable-dev-shm-usage \
    --no-first-run --start-maximized --app="$AUTOSTART_URL" >>"$LOG" 2>&1 &
else
  echo "[autostart] no AUTOSTART_CMD or AUTOSTART_URL set - plain desktop" >>"$LOG"
fi
