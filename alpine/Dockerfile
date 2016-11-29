FROM alpine:latest
MAINTAINER jicki < jicki@qq.com >
RUN echo "https://mirrors.ustc.edu.cn/alpine/v3.4/main" > /etc/apk/repositories \
    && echo "https://mirrors.ustc.edu.cn/alpine/v3.4/community" >> /etc/apk/repositories \
    && apk update
RUN apk add --no-cache --update-cache bash
CMD ["/bin/bash"]
