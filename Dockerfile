FROM alpine:3.6

ENV RAILS_ROOT=/usr/src/app \
    HOME=$RAILS_ROOT \
    TZ=Asia/Tehran \
    # To decrease the size of the Dockerfile only install the DB packages you need
    DB_PACKAGES="mysql-dev"

RUN apk update && \
    # Install required packages - you can find any additional packages here: https://pkgs.alpinelinux.org/packages
    apk add tzdata curl bash ca-certificates rsync supervisor nginx \
            build-base yarn libffi-dev libxml2-dev libxslt-dev nodejs $DB_PACKAGES \
            ruby ruby-dev ruby-bundler ruby-irb ruby-json ruby-bigdecimal ruby-nokogiri && \
    # Set the timezone
    cp /usr/share/zoneinfo/${TZ} /etc/localtime && \
    echo "${TZ}" > /etc/timezone && \
    # Setup permissions
    mkdir -p /run/nginx /var/lib/nginx/logs && \
    chgrp -R 0        /var/log /var/run /var/tmp /run/nginx /var/lib/nginx && \
    chmod -R g=u,a+rx /var/log /var/run /var/tmp /run/nginx /var/lib/nginx && \
    # Log aggregation
    ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log && \
    # Clean up packages
    rm -rf /var/cache/apk/*

WORKDIR /usr/src/app
EXPOSE 8080

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY Gemfile Gemfile.lock ./
COPY supervisord.conf /
# Use system-libraries for nokogiri so it installs faster
RUN bundle config build.nokogiri --use-system-libraries && bundle install --without test development

COPY . /tmp/app
RUN chgrp -R 0 /tmp/app && \
    chmod -R g=u /tmp/app && \
    cp -a /tmp/app/. . && \
    rm -rf /tmp/app && \
    chmod +x start.sh && \
    mkdir -p log && chgrp -R 0 log && chmod -R g=u log

CMD ["./start.sh"]
USER 1001
