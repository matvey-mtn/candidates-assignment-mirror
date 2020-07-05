#!/bin/bash
sed  -i  's/deny from all/allow from all/g'  /etc/apache2/sites-available/default
service apache2 reload
