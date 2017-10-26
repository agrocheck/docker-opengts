FROM phusion/baseimage:0.9.22

EXPOSE 8080
EXPOSE 31275

ENV CATALINA_HOME /opt/tomcat
ENV GTS_HOME /opt/opengts
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN export DEBIAN_FRONTEND="noninteractive" && \
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections

RUN add-apt-repository -y ppa:webupd8team/java && \
    apt-get update && \
    apt-get install -y --allow-unauthenticated ant oracle-java8-installer unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -Lo /tmp/opengts.zip "https://downloads.sourceforge.net/project/opengts/server-base/2.6.5/OpenGTS_2.6.5.zip" && \
    unzip -d "$(dirname "${GTS_HOME}")" /tmp/opengts.zip && \
    mv "$(dirname "${GTS_HOME}")/OpenGTS_2.6.5" "${GTS_HOME}" && \
    rm /tmp/opengts.zip

RUN curl -Lo /tmp/tomcat.tar.gz "https://archive.apache.org/dist/tomcat/tomcat-8/v8.5.23/bin/apache-tomcat-8.5.23.tar.gz" && \
    tar -xzf /tmp/tomcat.tar.gz -C "$(dirname "${CATALINA_HOME}")" && \
    mv "$(dirname "${CATALINA_HOME}")/apache-tomcat-8.5.23" "${CATALINA_HOME}" && \
    rm /tmp/tomcat.tar.gz

RUN curl -Lo "${JAVA_HOME}/jre/lib/ext/mysql-connector-java.jar" "http://central.maven.org/maven2/mysql/mysql-connector-java/5.1.44/mysql-connector-java-5.1.44.jar"
RUN curl -Lo "${JAVA_HOME}/jre/lib/ext/javax.mail.jar" "https://search.maven.org/remotecontent?filepath=com/sun/mail/javax.mail/1.5.6/javax.mail-1.5.6.jar"

RUN apt-get update && \
    apt-get install -y --allow-unauthenticated mysql-server-5.7 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/run/mysqld && \
    chown mysql:mysql /var/run/mysqld && \
    rm -rf /var/lib/mysql/*

WORKDIR /docker
COPY bin bin

ENTRYPOINT ["bin/entrypoint.sh"]
CMD ["start"]
