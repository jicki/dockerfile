

一、 安装 php 内置扩展

1. 系统安装 支持库
2. 使用 docker-php-ext-install 安装
3. 如需要配置扩展路径参数等, 使用 docker-php-ext-configure， 再试用 docker-php-ext-install 安装


```
FROM my-php-images
RUN apk update && apk add --no-cache \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
    && docker-php-ext-install -j$(nproc) iconv mcrypt \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd
```




二、安装 pecl 库里面的 扩展

1. 系统安装 支持库
2. pecl install 安装扩展
3. 使用 docker-php-ext-enable 启动扩展

```
FROM my-php-images
RUN apk update && apk add --no-cache libmemcached-dev \
    && pecl install memcached \
    && docker-php-ext-enable memcached
```





三、安装 额外的 扩展

1. 下载 扩展包,  
2. 解压并安装
3. 使用 docker-php-ext-enable 启动扩展

docker-php-ext-enable

```
FROM my-php-images

RUN curl -fsSL 'https://xcache.lighttpd.net/pub/Releases/3.2.0/xcache-3.2.0.tar.gz' -o xcache.tar.gz \
    && mkdir -p xcache \
    && tar -xf xcache.tar.gz -C xcache --strip-components=1 \
    && rm xcache.tar.gz \
    && ( \
        cd xcache \
        && phpize \
        && ./configure --enable-xcache \
        && make -j$(nproc) \
        && make install \
    ) \
    && rm -r xcache \
    && docker-php-ext-enable xcache
```