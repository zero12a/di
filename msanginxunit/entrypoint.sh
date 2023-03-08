#!/bin/bash



curl -X PUT --data-binary '{
 "listeners": {
   "*:80": {
   "pass": "applications/php"
 }
},
 "applications": {
  "php": {
   "type": "php",
   "root": "/data/www/"
 }
}
}' --unix-socket /var/run/control.unit.sock http://localhost/config/
