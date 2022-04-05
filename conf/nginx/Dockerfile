FROM nginx:latest

ARG UID
ARG GID

ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN usermod -u $UID www-data && \
    groupmod -g $GID www-data