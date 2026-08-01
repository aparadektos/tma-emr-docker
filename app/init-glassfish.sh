#!/bin/bash

set -e

echo "Starting GlassFish..."

# Start GlassFish in background
/opt/glassfish4/bin/asadmin start-domain

echo "Waiting 10 seconds..."
sleep 10

echo "Creating JDBC Pool..."

/opt/glassfish4/bin/asadmin create-jdbc-connection-pool \
--datasourceclassname com.mysql.jdbc.jdbc2.optional.MysqlDataSource \
--restype javax.sql.DataSource \
--property User=${MYSQL_USER}:Password=${MYSQL_PASSWORD}:ServerName=mysql:PortNumber=3306:DatabaseName=${MYSQL_DATABASE} \
tma-maritime-cp || true

echo "Creating JDBC Resource..."

/opt/glassfish4/bin/asadmin create-jdbc-resource \
--connectionpoolid tma-maritime-cp \
jdbc/tmariseditdbresource || true

echo "Restarting GlassFish..."

/opt/glassfish4/bin/asadmin restart-domain

echo "Ready."

tail -f /opt/glassfish4/glassfish/domains/domain1/logs/server.log