FROM eclipse-temurin:8-jdk

WORKDIR /opt

RUN apt-get update && \
    apt-get install -y wget unzip && \
    wget https://download.oracle.com/glassfish/4.1/release/glassfish-4.1.zip -O glassfish.zip && \
    unzip glassfish.zip && \
    rm glassfish.zip

# MySQL Driver
COPY lib/mysql-connector-java-5.0.8-bin.jar \
    /opt/glassfish4/glassfish/domains/domain1/lib/

# Application
COPY deployments/noah.war \
    /opt/glassfish4/glassfish/domains/domain1/autodeploy/noah.war

# Startup script
COPY init-glassfish.sh /init-glassfish.sh
RUN chmod +x /init-glassfish.sh

EXPOSE 8080 8181 4848

CMD ["/init-glassfish.sh"]