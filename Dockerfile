FROM drydock-prod.workiva.net/workiva/dart2_base_image:0.0.0-dart2.7.0
WORKDIR /build/
ADD . /build/

RUN pub get

RUN tar -cvzf /build/assets.tar.gz -C lib sockjs.js sockjs_prod.js
ARG BUILD_ARTIFACTS_CDN=/build/assets.tar.gz

FROM scratch
