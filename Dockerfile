# NOTE:
# - port 80 used for graphite UI
# - port 2003 for Carbon for metric collection
# - port 3000 for Grafana web UI
#
# Graphite storage is in /opt/graphite/storage:
# - We'll probably have to modify the graphite local_settings.xml to point
#   the storage dir to an NFS path
#
# - The DB init script: Need to figure out if this erases existing data

# Grafana sqlite3 database path can be configured in its config. It should
# point to an NFS path
FROM centos:7

ENV NFS_LOCATION /mnt/grafana
ENV GRAPHITE_STORAGE "${NFS_LOCATION}/graphite-storage"
ENV GRAFANA_STORAGE "${NFS_LOCATION}/grafana-storage"

EXPOSE 80 2003 3000

RUN yum update -y && yum clean all

# Install required packages for graphite
RUN yum install -y epel-release && yum clean all
RUN yum install httpd net-snmp perl python-devel git gcc-c++ pycairo mod_wsgi libffi libffi-devel -y && yum clean all

RUN yum install -y python-pip node npm
RUN pip install django==1.9.12
RUN pip install django-tagging
RUN pip install pytz
RUN pip install scandir
RUN pip install whisper
RUN pip install Twisted==16.4.1
RUN pip install graphite-web
RUN pip install carbon

# Copy configs
RUN cp /opt/graphite/conf/storage-schemas.conf.example /opt/graphite/conf/storage-schemas.conf
RUN cp /opt/graphite/conf/storage-aggregation.conf.example /opt/graphite/conf/storage-aggregation.conf
RUN cp /opt/graphite/conf/graphTemplates.conf.example /opt/graphite/conf/graphTemplates.conf
RUN cp /opt/graphite/conf/graphite.wsgi.example /opt/graphite/conf/graphite.wsgi
RUN cp /opt/graphite/webapp/graphite/local_settings.py.example /opt/graphite/webapp/graphite/local_settings.py
RUN cp /opt/graphite/conf/carbon.conf.example /opt/graphite/conf/carbon.conf

# TODO: Modify storage-shemas.conf

# Setup httpd for Graphite?
RUN cp /opt/graphite/examples/example-graphite-vhost.conf /etc/httpd/conf.d/graphite.conf

RUN chown -R apache:apache /opt/graphite/ && chmod -R 755 /opt/graphite/

# Set graphite storage location
# RUN sed -i.bak "s|\#STORAGE_DIR =.*|STORAGE_DIR = '${GRAPHITE_STORAGE}'|g" /opt/graphite/webapp/graphite/local_settings.py

# Install Grafana
RUN yum install initscripts fontconfig https://s3-us-west-2.amazonaws.com/grafana-releases/release/grafana-4.4.1-1.x86_64.rpm -y

# Set grafana sqlite location
# RUN sed -i.bak "s|DATA_DIR=.*|DATA_DIR=${GRAFANA_STORAGE}|g" /etc/init.d/grafana-server

RUN PYTHONPATH=/opt/graphite/webapp django-admin.py migrate --settings=graphite.settings --run-syncdb
# Re-run chown and chmod cause the migrate script probably creates files with wrong permissions
RUN chown -R apache:apache /opt/graphite/ && chmod -R 755 /opt/graphite/

ADD docker-start.sh /opt/bin/docker-start.sh

ENTRYPOINT /opt/bin/docker-start.sh
