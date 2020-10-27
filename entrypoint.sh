#!/bin/sh
set -eu
rsync -rlDog --chown www-data:root --delete --exclude-from=/upgrade.exclude /usr/src/nextcloud/ /var/www/html/
rm -f /var/www/html/version.php; ln -s /data/version.php /var/www/html/version.php
exec "$@"
