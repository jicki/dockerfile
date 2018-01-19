FROM rabbitmq:3.6-management-alpine

COPY join.sh /
RUN chmod +x /join.sh

RUN sed -i 's/exec "$@"/\
    sh -c "while ! nc -z localhost 15672; do sleep 0.1; done; sleep 3; .\/join.sh" \&\
    \nexec "$@"/' /usr/local/bin/docker-entrypoint.sh
