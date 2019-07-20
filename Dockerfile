FROM arm32v7/alpine:latest

COPY qemu-arm-static /usr/bin

WORKDIR /opt

RUN set -x && \
  apk add curl && \
  apk add openjdk8-jre && \
  apk add bash && \
  curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-5.6.15.tar.gz && \
  tar -xvf elasticsearch-5.6.15.tar.gz

RUN : "Create jvm.options" && { \
  echo "-Xms256m"; \
  echo "-Xmx256m"; \
  echo "-XX:+UseConcMarkSweepGC"; \
  echo "-XX:CMSInitiatingOccupancyFraction=75"; \
  echo "-XX:+UseCMSInitiatingOccupancyOnly"; \
  echo "-XX:+AlwaysPreTouch"; \
  echo "-Xss320k"; \
  echo "-Djava.awt.headless=true"; \
  echo "-Dfile.encoding=UTF-8"; \
  echo "-Djna.nosys=true"; \
  echo "-Djdk.io.permissionsUseCanonicalPath=true"; \
  echo "-Dio.netty.noUnsafe=true"; \
  echo "-Dio.netty.noKeySetOptimization=true"; \
  echo "-Dio.netty.recycler.maxCapacityPerThread=0"; \
  echo "-Dlog4j.shutdownHookEnabled=false"; \
  echo "-Dlog4j2.disable.jmx=true"; \
  echo "-Dlog4j.skipJansi=true"; \
  echo "-XX:+HeapDumpOnOutOfMemoryError"; \
} | tee /opt/elasticsearch-5.6.15/config/jvm.options

RUN : "Create elasticsearch.yml" && { \
  echo "network.host: 0.0.0.0"; \
  echo "http.port: 9200"; \
  echo "bootstrap.system_call_filter: false"; \
} | tee /opt/elasticsearch-5.6.15/config/elasticsearch.yml

ENV JAVA_HOME /usr/lib/jvm/default-jvm

EXPOSE 9200
ENTRYPOINT ["/opt/elasticsearch-5.6.15/bin/elasticsearch"]
