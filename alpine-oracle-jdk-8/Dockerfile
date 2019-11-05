FROM jicki/alpine:glibc

ARG TZ="Asia/Shanghai"
ARG JAVA_GC_LOG="/var/log/jvmgc.log" 

ENV JAVA_VERSION 8
ENV JAVA_UPDATE 231
ENV LANGUAGE en_US:en
ENV JAVA_HOME /usr/lib/jvm/default-jvm
ENV TZ ${TZ}
ENV JAVA_GC_LOG ${JAVA_GC_LOG}
ENV TINI_VERSION v0.18.0
ENV TINI_DOWNLOAD_URL https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-amd64

# refs => http://calvin1978.blogcn.com/articles/jvmoption-7.html
ENV JAVA_OPTS   -Djava.security.egd=file:/dev/./urandom \
                -XX:AutoBoxCacheMax=20000 \
                -XX:+UnlockExperimentalVMOptions \
                -XX:+UseCGroupMemoryLimitForHeap \
                -XX:+AlwaysPreTouch \
                -XX:+PrintCommandLineFlags \
                -XX:+PrintGCDateStamps \
                -XX:+PrintGCDetails \
                -XX:+PrintGCApplicationStoppedTime \
                -Xloggc:${JAVA_GC_LOG} \
                ${JAVA_OPTS}

COPY docker-java-home /usr/bin/docker-java-home
COPY jdk-8u231-linux-x64.tar.gz /tmp/
COPY jce_policy-8.zip /tmp/

RUN echo "https://mirrors.ustc.edu.cn/alpine/v3.10/main" > /etc/apk/repositories \ 
 && echo "https://mirrors.ustc.edu.cn/alpine/v3.10/community" >> /etc/apk/repositories \ 
 && apk update 

RUN apk add --no-cache --virtual=build-dependencies curl ca-certificates unzip bash \
    && curl -sSL ${TINI_DOWNLOAD_URL} > /usr/bin/tini \
    && chmod +x /usr/bin/tini \
    && cd "/tmp" \
    && tar -xzf jdk-${JAVA_VERSION}u${JAVA_UPDATE}-linux-x64.tar.gz \
    && mkdir -p /usr/lib/jvm \
    && mv jdk1.${JAVA_VERSION}.0_${JAVA_UPDATE} /usr/lib/jvm/java-${JAVA_VERSION}-oracle \
    && ln -s /usr/lib/jvm/java-${JAVA_VERSION}-oracle ${JAVA_HOME} \
    && ln -s ${JAVA_HOME}/bin/* /usr/bin/ \
    && unzip -jo -d ${JAVA_HOME}/jre/lib/security jce_policy-${JAVA_VERSION}.zip \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && rm -rf "$JAVA_HOME/"*src.zip && \
    rm -rf "$JAVA_HOME/lib/missioncontrol" \
           "$JAVA_HOME/lib/visualvm" \
           "$JAVA_HOME/lib/"*javafx* \
           "$JAVA_HOME/jre/lib/plugin.jar" \
           "$JAVA_HOME/jre/lib/ext/jfxrt.jar" \
           "$JAVA_HOME/jre/bin/javaws" \
           "$JAVA_HOME/jre/lib/javaws.jar" \
           "$JAVA_HOME/jre/lib/desktop" \
           "$JAVA_HOME/jre/plugin" \
           "$JAVA_HOME/jre/lib/"deploy* \
           "$JAVA_HOME/jre/lib/"*javafx* \
           "$JAVA_HOME/jre/lib/"*jfx* \
           "$JAVA_HOME/jre/lib/amd64/libdecora_sse.so" \
           "$JAVA_HOME/jre/lib/amd64/"libprism_*.so \
           "$JAVA_HOME/jre/lib/amd64/libfxplugins.so" \
           "$JAVA_HOME/jre/lib/amd64/libglass.so" \
           "$JAVA_HOME/jre/lib/amd64/libgstreamer-lite.so" \
           "$JAVA_HOME/jre/lib/amd64/"libjavafx*.so \
           "$JAVA_HOME/jre/lib/amd64/"libjfx*.so && \
    rm "${JAVA_HOME}/jre/lib/security/README.txt" && \
    apk del build-dependencies && \
    rm "/tmp/"*
    
ENTRYPOINT ["tini","--"]

CMD ["bash"]
