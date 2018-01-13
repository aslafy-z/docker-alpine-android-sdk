FROM anapsix/alpine-java:8_jdk

MAINTAINER Can Kutlu Kinay <me@ckk.im>

ENV SDK_VERSION     3859397
ENV SDK_CHECKSUM    444e22ce8ca0f67353bda4b85175ed3731cae3ffa695ca18119cbacef1c1bea0
ENV ANDROID_HOME    /opt/android-sdk
ENV SDK_UPDATE      "platforms;android-26 build-tools;26.0.3 system-images;android-26;google_apis;x86"
ENV LD_LIBRARY_PATH ${ANDROID_HOME}/tools/lib64/qt:${ANDROID_HOME}/tools/lib/libQt5:$LD_LIBRARY_PATH/
ENV GRADLE_VERSION  4.4.1
ENV GRADLE_HOME     /opt/gradle-${GRADLE_VERSION}
ENV PATH            ${PATH}:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools:${GRADLE_HOME}/bin

RUN set -x \
    && apk add --no-cache curl \
    && curl -SLO "https://dl.google.com/android/repository/sdk-tools-linux-${SDK_VERSION}.zip" \
    && echo "${SDK_CHECKSUM}  sdk-tools-linux-${SDK_VERSION}.zip" | sha256sum -cs \
    && mkdir -p "${ANDROID_HOME}" \
    && unzip "sdk-tools-linux-${SDK_VERSION}.zip" -d "${ANDROID_HOME}" \
    && rm -Rf "sdk-tools-linux-${SDK_VERSION}.zip" \ 
    && mkdir -p /root/.android \
    && touch /root/.android/repositories.cfg \
    && yes | sdkmanager --licenses \
    && ${ANDROID_HOME}/tools/bin/sdkmanager --verbose ${SDK_UPDATE} \
    # Install gradle
    && curl -SLO https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip \
    && mkdir -p "${GRADLE_HOME}" \
    && unzip "gradle-${GRADLE_VERSION}-bin.zip" -d "/opt" \
    && rm -f "gradle-${GRADLE_VERSION}-bin.zip" \
    && apk del curl
