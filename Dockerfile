# Nexus
#
# from http://books.sonatype.com/nexus-book/reference/install-sect-service.html

FROM debian
MAINTAINER Andrew Schurman "arcticwaters@gmail.com"

RUN apt-get update && apt-get install -y wget openjdk-7-jre-headless procps
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN useradd --system --create-home nexus
RUN cd /home/nexus
RUN su - nexus -c 'wget http://www.sonatype.org/downloads/nexus-latest-bundle.tar.gz'
RUN su - nexus -c 'tar zxf nexus-latest-bundle.tar.gz'
RUN mv "$(find /home/nexus/* -maxdepth 0 -name nexus\* -type d)" /usr/local/share/
RUN ln -s "$(find /usr/local/share/* -maxdepth 0 -name nexus\* -type d)" /usr/local/share/nexus

RUN cp /usr/local/share/nexus/bin/nexus /etc/init.d
RUN chown root:root /etc/init.d/nexus

RUN perl -pi -e 's|^NEXUS_HOME=.*?$|NEXUS_HOME="/usr/local/share/nexus"|' /etc/init.d/nexus
RUN perl -pi -e 's|^#?RUN_AS_USER=.*?$|RUN_AS_USER="nexus"|' /etc/init.d/nexus
RUN perl -pi -e 's|^#?PIDDIR=.*?$|PIDDIR="/var/run/nexus"|' /etc/init.d/nexus

RUN perl -pi -e 's|^nexus-work=.*?$|nexus-work=/var/local/nexus|' /usr/local/share/nexus/conf/nexus.properties
RUN perl -pi -e 's|^application-port=.*?$|application-port=8081|' /usr/local/share/nexus/conf/nexus.properties

RUN mkdir -p /var/run/nexus && chown nexus:nexus /var/run/nexus
RUN mkdir -p /var/local/nexus && chown nexus:nexus /var/local/nexus

RUN cd /etc/init.d
RUN update-rc.d nexus defaults
#RUN service nexus start

EXPOSE 8081

#CMD tail -F /usr/local/share/nexus/logs/wrapper.log
