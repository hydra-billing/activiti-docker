FROM tomcat:latest

ENV ACTIVITI_VERSION 5.19.0
ENV PGSQL_JDBC_VERSION 9.4.1207
ENV MYSQL_JDBC_VERSION 5.1.39
ENV DB_TYPE postgres

COPY assets /assets/
COPY ./*.sh /

# download and deploy Activiti
WORKDIR /tmp
RUN wget https://github.com/Activiti/Activiti/releases/download/activiti-${ACTIVITI_VERSION}/activiti-${ACTIVITI_VERSION}.zip
RUN unzip activiti-${ACTIVITI_VERSION}.zip -d /usr/local/
WORKDIR /usr/local/activiti-${ACTIVITI_VERSION}/wars
RUN ls * | xargs -I{} sh -c 'mkdir /usr/local/tomcat/webapps/${1%.*}' -- {} \
 && ls * | xargs -I{} sh -c 'unzip $1 -d /usr/local/tomcat/webapps/${1%.*}/' -- {}
RUN rm -rf /tmp/*

ENTRYPOINT ["/entrypoint.sh"]
