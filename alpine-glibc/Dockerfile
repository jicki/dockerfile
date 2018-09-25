FROM alpine

# Here we install GNU libc (aka glibc) and set C.UTF-8 locale as default.

RUN echo "https://mirrors.ustc.edu.cn/alpine/v3.8/main" > /etc/apk/repositories \
    && echo "https://mirrors.ustc.edu.cn/alpine/v3.8/community" >> /etc/apk/repositories \
    && apk update

RUN apk --no-cache add ca-certificates wget \
    && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
    && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk \
    && apk add glibc-2.28-r0.apk && \
    \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-bin-2.28-r0.apk && \
    wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-i18n-2.28-r0.apk && \
    apk add glibc-bin-2.28-r0.apk glibc-i18n-2.28-r0.apk && \
    /usr/glibc-compat/bin/localedef -i en_US -f UTF-8 en_US.UTF-8 && \
    \
    apk del glibc-i18n && \
    \
    rm "/root/.wget-hsts" 

ENV LANG=C.UTF-8
