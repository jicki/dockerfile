# Nginx + PHP-FPM


## image

```

docker pull jicki/nginx-fpm:7.2


```


## Version

```
NGINX_VERSION 1.14.0

PHP_VERSION  7.2.4


```

## volumes


```
# vhost

-v localpath:/etc/nginx/sites-enabled

# logs

-v localpath:/var/logs/nginx


# 项目目录

-v localpath:/var/www/html


```

## ENV

### Git

| Name               | Description                                                                                                                                                                                                                |
|--------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| GIT_REPO           | URL to the repository containing your source code. If you are using a personal token, this is the https URL without `https://` (e.g `github.com/project/`). For ssh prepend with `git@` (e.g `git@github.com/project.git`) |
| GIT_BRANCH         | Select a specific branch (optional)                                                                                                                                                                                        |
| GIT_TAG            | Specify a specific git tag (optional)                                                                                                                                                                                      |
| GIT_COMMIT         | Specify a specific git commit (optional)                                                                                                                                                                                   |
| GIT_EMAIL          | Set your email for code pushing (required for git to work)                                                                                                                                                                 |
| GIT_NAME           | Set your name for code pushing (required for git to work)                                                                                                                                                                  |
| GIT_USE_SSH        | Set this to 1 if you want to use git over SSH (instead of HTTP), useful if you want to use Bitbucket instead of GitHub                                                                                                     |
| SSH_KEY            | Private SSH deploy key for your repository base64 encoded (requires write permissions for pushing)                                                                                                                         |
| GIT_PERSONAL_TOKEN | Personal access token for your git account (required for HTTPS git access)                                                                                                                                                 |
| GIT_USERNAME       | Git username for use with personal tokens. (required for HTTPS git access)                                                                                                                                                 |

### Others

| Name                    | Description                                                                                                    |
|-------------------------|----------------------------------------------------------------------------------------------------------------|
| WEBROOT                 | Change the default webroot directory from `/var/www/html` to your own setting                                  |
| ERRORS                  | Set to 1 to display PHP Errors in the browser                                                                  |
| HIDE_NGINX_HEADERS      | Disable by setting to 0, default behaviour is to hide nginx + php version in headers                           |
| PHP_MEM_LIMIT           | Set higher PHP memory limit, default is 128 Mb                                                                 |
| PHP_POST_MAX_SIZE       | Set a larger post_max_size, default is 100 Mb                                                                  |
| PHP_UPLOAD_MAX_FILESIZE | Set a larger upload_max_filesize, default is 100 Mb                                                            |
| PHP_ERRORS_STDERR       | Send php logs to docker logs                                                                                   |
| DOMAIN                  | Set domain name for Lets Encrypt scripts                                                                       |
| REAL_IP_HEADER          | set to 1 to enable real ip support in the logs                                                                 |
| REAL_IP_FROM            | set to your CIDR block for real ip in logs                                                                     |
| RUN_SCRIPTS             | Set to 1 to execute scripts                                                                                    |
| PGID                    | Set to GroupId you want to use for nginx (helps permissions when using local volume)                           |
| PUID                    | Set to UserID you want to use for nginx (helps permissions when using local volume)                            |
| REMOVE_FILES            | Use REMOVE_FILES=0 to prevent the script from clearing out /var/www/html (useful for working with local files) |
| APPLICATION_ENV         | Set this to development to prevent composer deleting local development dependencies                            |
| SKIP_CHOWN              | Set to 1 to avoid running chown -Rf on /var/www/html                                                           |
| SKIP_COMPOSER           | Set to 1 to avoid installing composer                                                                          |



## Repository Layout Guidelines

We recommend laying out your source git repository in the following way, to enable you to use all the features of the container.

It's important to note code will always be checked out to ```/var/www/html/``` this is for historic reasons and we may improve this in the future with a user configurable variable. If you just wish to check code out into a container and not do anything special simply put all your files in the root directory of your repository like so:

```
- repo root (/var/www/html)
 - index.html
 - more code here
```

However if you wish to use scripting support you'll want to split code and scripts up to ensure your scripts are not in the public part of your site.

```
 - repo root (/var/www/html)
  - src
    - your code here
  - conf
    - nginx
      - nginx-site.conf
      - nginx-site-ssl.conf
  - scripts
    - 00-firstscript.sh
    - 01-second.sh
    - ......
```

### src / Webroot
If you use an alternative directory for your application root like the previous example of __src/__, you can use the __WEBROOT__ variable to instruct nginx that that is where the code should be served from.

``` docker run -e 'WEBROOT=/var/www/html/src/' -e OTHER_VARS ........ ```

One example would be, if you are running craft CMS you'll end up with a repo structure like this:

```
- repo root (/var/www/html)
 - craft
   - core craft
 - public
   - index.php
   -    other public files
```

In this case __WEBROOT__ would be set as __/var/www/html/public__

Note that if you are managing dependencies with composer, your composer.json and composer.lock files should *always* be located in the repo root, not in the directory you set as __WEBROOT__.

### conf
This directory is where you can put config files you call from your scripts. It is also home to the nginx folder where you can include custom nginx config files.

### scripts
Scripts are executed in order so its worth numbering them ```00,01,..,99``` to control their run order. Bash scripts are supported but, of course, you could install other run times in the first script then write your scripts in your preferred language.

