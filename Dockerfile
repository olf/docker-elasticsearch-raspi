FROM raspbian/stretch:latest

# COPY qemu-arm-static /usr/bin

WORKDIR /opt

RUN set -x && \
  apt-get -yq update && \
  apt-get -yq install curl

RUN set -x && \
  curl -L -O https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.5.2-no-jdk-linux-x86_64.tar.gz && \
  tar xf elasticsearch-7.5.2-no-jdk-linux-x86_64.tar.gz && \
  rm elasticsearch-7.5.2-no-jdk-linux-x86_64.tar.gz && \
  mv /opt/elasticsearch-7.5.2 /opt/elasticsearch

RUN set -x && \
  curl -L -O https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk-11.0.6%2B10/OpenJDK11U-jdk_arm_linux_hotspot_11.0.6_10.tar.gz && \
  tar xf OpenJDK11U-jdk_arm_linux_hotspot_11.0.6_10.tar.gz && \
  rm OpenJDK11U-jdk_arm_linux_hotspot_11.0.6_10.tar.gz && \
  mv /opt/jdk-11.0.6+10 /opt/elasticsearch/jdk

RUN : "Create jvm.options" && { \
  echo "-Xms512m"; \
  echo "-Xmx512m"; \
  echo "-XX:CMSInitiatingOccupancyFraction=75"; \
  echo "-XX:+UseCMSInitiatingOccupancyOnly"; \
  echo "-XX:+AlwaysPreTouch"; \
  echo "-XX:+UseParallelGC"; \
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
  } | tee /opt/elasticsearch/config/jvm.options

RUN : "Create elasticsearch.yml" && { \
  echo "node.name: pthagonal"; \
  echo "cluster.initial_master_nodes: pthagonal"; \
  echo "network.host: 0.0.0.0"; \
  echo "http.port: 9200"; \
  echo "xpack.monitoring.enabled: false"; \
  echo "xpack.security.enabled: false"; \
  echo "xpack.ml.enabled: false"; \
  echo "bootstrap.system_call_filter: false"; \
  } | tee /opt/elasticsearch/config/elasticsearch.yml

EXPOSE 9200

# ENV JAVA_HOME /usr/lib/jvm/default-jvm
# ENV JAVA_HOME /opt/jdk-11.0.6+10

ENTRYPOINT [ "/opt/elasticsearch/bin/elasticsearch" ]
# CMD /bin/sleep 60m
