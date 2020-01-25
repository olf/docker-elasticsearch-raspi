FROM arm32v7/alpine:latest

COPY qemu-arm-static /usr/bin

WORKDIR /opt

RUN set -x && \
  apk add curl && \
  apk add bash && \
  curl -L -O https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.6%2B10/OpenJDK11U-jdk_arm_linux_hotspot_11.0.6_10.tar.gz && \
  tar xf OpenJDK11U-jdk_arm_linux_hotspot_11.0.6_10.tar.gz && \
  rm OpenJDK11U-jdk_arm_linux_hotspot_11.0.6_10.tar.gz && \
  curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.5.2-no-jdk-linux-x86_64.tar.gz && \
  tar xf elasticsearch-7.5.2-no-jdk-linux-x86_64.tar.gz && \
  rm elasticsearch-7.5.2-no-jdk-linux-x86_64.tar.gz

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
} | tee /opt/elasticsearch-7.5.2/config/jvm.options

RUN : "Create elasticsearch.yml" && { \
  echo "network.host: 0.0.0.0"; \
  echo "http.port: 9200"; \
  echo "bootstrap.system_call_filter: false"; \
} | tee /opt/elasticsearch-7.5.2/config/elasticsearch.yml

ENV JAVA_HOME /opt/jdk-11.0.6+10

EXPOSE 9200
ENTRYPOINT ["/opt/elasticsearch-7.5.2/bin/elasticsearch"]
