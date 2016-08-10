#!/bin/bash
set -x

DB_TYPE=$(echo $DB_TYPE | tr '[:upper:]' '[:lower:]')

# check for linked database containers
if [[ -n $POSTGRESQL_PORT_5432_TCP_ADDR ]]; then
	DB_HOST="$POSTGRESQL_PORT_5432_TCP_ADDR"
elif [[ -n $MYSQL_PORT_3306_TCP_ADDR ]]; then
	DB_HOST="$MYSQL_PORT_3306_TCP_ADDR"
else
	DB_HOST="$DB_HOST"
fi

sed -i -e "s/{{DB_HOST}}/$DB_HOST/" /assets/db.properties.pgsql
sed -i -e "s/{{DB_HOST}}/$DB_HOST/" /assets/db.properties.mysql

case $DB_TYPE in
	postgres )	cp /assets/db.properties.pgsql $CATALINA_HOME/webapps/activiti-explorer/WEB-INF/classes/db.properties \
			&& cp /assets/db.properties.pgsql $CATALINA_HOME/webapps/activiti-rest/WEB-INF/classes/db.properties
			cd /opt
			wget https://jdbc.postgresql.org/download/postgresql-${PGSQL_JDBC_VERSION}.jar
			cp postgresql-${PGSQL_JDBC_VERSION}.jar $CATALINA_HOME/webapps/activiti-explorer/WEB-INF/lib/ \
			&& cp postgresql-${PGSQL_JDBC_VERSION}.jar $CATALINA_HOME/webapps/activiti-rest/WEB-INF/lib/
			;;
	mysql )		cp /assets/db.properties.mysql $CATALINA_HOME/webapps/activiti-explorer/WEB-INF/classes/db.properties \
			&& cp /assets/db.properties.mysql $CATALINA_HOME/webapps/activiti-rest/WEB-INF/classes/db.properties
			cd /opt
			wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_JDBC_VERSION}.tar.gz
			tar -xf mysql-connector-java-${MYSQL_JDBC_VERSION}.tar.gz
			cp mysql-connector-java-${MYSQL_JDBC_VERSION}/mysql-connector-java-${MYSQL_JDBC_VERSION}-bin.jar $CATALINA_HOME/webapps/activiti-explorer/WEB-INF/lib/ \
			&& cp mysql-connector-java-${MYSQL_JDBC_VERSION}/mysql-connector-java-${MYSQL_JDBC_VERSION}-bin.jar $CATALINA_HOME/webapps/activiti-rest/WEB-INF/lib/
			;;
	* )		echo "Unknown database type"
			exit 1
			;;
esac
