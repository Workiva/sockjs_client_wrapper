FROM drydock.workiva.net/workiva/dart2_base_image:1 as build

WORKDIR /build/
ADD . /build/

RUN pub get

RUN tar -cvzf /build/assets.tar.gz -C lib sockjs.js sockjs_prod.js
ARG BUILD_ARTIFACTS_CDN=/build/assets.tar.gz

FROM scratch
