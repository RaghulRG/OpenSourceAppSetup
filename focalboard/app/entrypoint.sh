#!/bin/bash

# Start Focalboard in the background
/opt/focalboard/bin/focalboard-server --config /opt/focalboard/config.json &

# Start NGINX in the foreground
nginx -g "daemon off;" 
