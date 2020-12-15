FROM digitalpatterns/jre:latest
ARG PRESTO_VERSION

WORKDIR /usr/lib/presto

RUN apt update && \
    apt upgrade -y && \
    apt install -y build-essential && \
    curl -sL https://deb.nodesource.com/setup_lts.x | bash - && \
    apt install -y python && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean

RUN \
  set -xeu && \
  mkdir -p /usr/lib/presto /data/presto && \
  curl -o /tmp/presto-server-${PRESTO_VERSION}.tar.gz https://repo1.maven.org/maven2/io/prestosql/presto-server/${PRESTO_VERSION}/presto-server-${PRESTO_VERSION}.tar.gz && \
  tar -C /tmp -xzf /tmp/presto-server-${PRESTO_VERSION}.tar.gz && \
  rm /tmp/presto-server-${PRESTO_VERSION}.tar.gz && \
  mv /tmp/presto-server-${PRESTO_VERSION}/* /usr/lib/presto/ && \
  curl -o /usr/bin/presto https://repo1.maven.org/maven2/io/prestosql/presto-cli/${PRESTO_VERSION}/presto-cli-${PRESTO_VERSION}-executable.jar && \
  chmod +x /usr/bin/presto && \
  chown -R "java:java" /usr/lib/presto /data/presto

COPY --chown=java:java run-presto /usr/bin/presto/bin/run-presto
RUN chmod +x /usr/bin/presto/bin/*

USER java

EXPOSE 8080 8443
ENV LANG en_GB.UTF-8
CMD ["/usr/lib/presto/bin/run-presto"]
