FROM drydock-prod.workiva.net/workiva/dart2_base_image:2
RUN dart pub get
FROM scratch
