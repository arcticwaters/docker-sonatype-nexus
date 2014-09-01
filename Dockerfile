# Nexus
#
# from http://books.sonatype.com/nexus-book/reference/install-sect-service.html

FROM debian:jessie
MAINTAINER Andrew Schurman "arcticwaters@gmail.com"

RUN apt-get update && apt-get install --no-install-recommends -y openjdk-7-jre-headless procps
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

ADD http://www.sonatype.org/downloads/nexus-2.9.0-bundle.tar.gz /tmp/nexus.tar.gz
RUN mkdir -p /opt && tar zxvf /tmp/nexus.tar.gz -C /opt && rm -rf /tmp/nexus.tar.gz && ln -s "$(find /opt/* -maxdepth 0 -name nexus\* -type d)" /opt/nexus
RUN awk '{ gsub("^#?RUN_AS_USER=.*?$","RUN_AS_USER=root"); print; }' /opt/nexus/bin/nexus > /tmp/nexus.bin && mv /tmp/nexus.bin /opt/nexus/bin/nexus
RUN chmod +x /opt/nexus/bin/nexus

EXPOSE 8081
VOLUME ["/opt/sonatype-work"]

CMD ["/opt/nexus/bin/nexus","console"]
