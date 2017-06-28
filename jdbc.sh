#!/bin/bash
set -x

DB_TYPE=$(echo $DB_TYPE | tr '[:upper:]' '[:lower:]')


cd /opt

case "$DB_TYPE" in
	postgres)
      if [[ -n "$POSTGRESQL_PORT_5432_TCP" ]]; then
        DB_HOST="$POSTGRESQL_PORT_5432_TCP_ADDR"
        DB_PORT="$POSTGRESQL_PORT_5432_TCP_PORT"
      fi

			wget https://jdbc.postgresql.org/download/postgresql-${PGSQL_JDBC_VERSION}.jar
			cp postgresql-${PGSQL_JDBC_VERSION}.jar $CATALINA_HOME/webapps/activiti-explorer/WEB-INF/lib/
			cp postgresql-${PGSQL_JDBC_VERSION}.jar $CATALINA_HOME/webapps/activiti-rest/WEB-INF/lib/
			;;
	mysql)
      if [[ -n "$MYSQL_PORT_3306_TCP" ]]; then
      	DB_HOST="$MYSQL_PORT_3306_TCP_ADDR"
      	DB_PORT="$MYSQL_PORT_3306_TCP_PORT"
      fi
      
			wget http://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-${MYSQL_JDBC_VERSION}.tar.gz
			tar -xf mysql-connector-java-${MYSQL_JDBC_VERSION}.tar.gz
			cp mysql-connector-java-${MYSQL_JDBC_VERSION}/mysql-connector-java-${MYSQL_JDBC_VERSION}-bin.jar $CATALINA_HOME/webapps/activiti-explorer/WEB-INF/lib/
			cp mysql-connector-java-${MYSQL_JDBC_VERSION}/mysql-connector-java-${MYSQL_JDBC_VERSION}-bin.jar $CATALINA_HOME/webapps/activiti-rest/WEB-INF/lib/
			;;
	*)
      echo "Unknown database type"
			exit 1
			;;
esac


sed -i -e "s/{{DB_HOST}}/$DB_HOST/" /assets/db.properties.$DB_TYPE
sed -i -e "s/{{DB_PORT}}/$DB_PORT/" /assets/db.properties.$DB_TYPE
sed -i -e "s/{{DB_NAME}}/$DB_NAME/" /assets/db.properties.$DB_TYPE
sed -i -e "s/{{DB_USERNAME}}/$DB_USERNAME/" /assets/db.properties.$DB_TYPE
sed -i -e "s/{{DB_PASSWORD}}/$DB_PASSWORD/" /assets/db.properties.$DB_TYPE

cp /assets/db.properties.$DB_TYPE $CATALINA_HOME/webapps/activiti-explorer/WEB-INF/classes/db.properties
cp /assets/db.properties.$DB_TYPE $CATALINA_HOME/webapps/activiti-rest/WEB-INF/classes/db.properties
