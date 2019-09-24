FROM google/dart:2.5 as dart2
FROM drydock-prod.workiva.net/workiva/smithy-runner-generator:350667 as build

ARG NPM_TOKEN
ARG NPM_CONFIG__AUTH
ARG NPM_CONFIG_REGISTRY=https://npm.workiva.net
ARG NPM_CONFIG_ALWAYS_AUTH=true

# Build Environment Vars
ARG BUILD_ID
ARG BUILD_NUMBER
ARG BUILD_URL
ARG GIT_COMMIT
ARG GIT_BRANCH
ARG GIT_TAG
ARG GIT_COMMIT_RANGE
ARG GIT_HEAD_URL
ARG GIT_MERGE_HEAD
ARG GIT_MERGE_BRANCH
ARG GIT_SSH_KEY
ARG KNOWN_HOSTS_CONTENT
WORKDIR /build/
ADD . /build/

RUN mkdir /root/.ssh && \
    echo "$KNOWN_HOSTS_CONTENT" > "/root/.ssh/known_hosts" && \
    chmod 700 /root/.ssh/ && \
    umask 0077 && echo "$GIT_SSH_KEY" >/root/.ssh/id_rsa && \
    eval "$(ssh-agent -s)" && ssh-add /root/.ssh/id_rsa
RUN echo "installing npm packages"
RUN npm install

RUN echo "Starting the before_script section" && \
		dart --version

# Use pub from Dart 2 to initially resolve dependencies since it is much more efficient.
COPY --from=dart2 /usr/lib/dart /usr/lib/dart2
RUN echo "Running Dart 2 pub get.." && \
	_PUB_TEST_SDK_VERSION=1.24.3 timeout 5m /usr/lib/dart2/bin/pub get --no-precompile

RUN pub get && \
		echo "before_script section completed"
RUN echo "Starting the script section" && \
		./tool/check_version.sh && \
		echo "script section completed"
ARG BUILD_ARTIFACTS_DART-DEPENDENCIES=/build/pubspec.lock

RUN tar -cvzf /build/assets.tar.gz -C lib sockjs.js sockjs_prod.js
ARG BUILD_ARTIFACTS_CDN=/build/assets.tar.gz

RUN mkdir /audit/
ARG BUILD_ARTIFACTS_AUDIT=/audit/*

RUN npm ls -s --json --depth=10 > /audit/npm.lock || [ $? -eq 1 ] || exit
FROM scratch
