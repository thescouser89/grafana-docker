# Create graphite-storage location if not present
# if ! [ -d "${GRAPHITE_STORAGE}" ]; then
    # mkdir "${GRAPHITE_STORAGE}"
# fi

# chown -R apache:apache "${GRAPHITE_STORAGE}"
# chmod -R 755 "${GRAPHITE_STORAGE}"

# # Create grafana storage location
# if ! [ -d "${GRAFANA_STORAGE}" ]; then
    # mkdir "${GRAFANA_STORAGE}"
# fi
# chown -R grafana:grafana "${GRAFANA_STORAGE}"
# chmod -R 755 "${GRAFANA_STORAGE}"

# PYTHONPATH=/opt/graphite/webapp django-admin.py migrate --settings=graphite.settings --run-syncdb

# Start carbon service
/opt/graphite/bin/carbon-cache.py start

# Start httpd service
httpd

# Start grafana
/etc/init.d/grafana-server start

# Freeze
tail -f /dev/null
