FROM drydock-prod.workiva.net/workiva/dart2_base_image:0.0.0-dart2.18.7
WORKDIR /build/
ADD . /build/

RUN dart pub get

RUN tar -cvzf /build/assets.tar.gz -C lib sockjs.js sockjs.js.map sockjs_prod.js sockjs_prod.js.map
ARG BUILD_ARTIFACTS_CDN=/build/assets.tar.gz

FROM scratch
