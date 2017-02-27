FROM chunt/private:debian_base 
MAINTAINER "chunt"

#args used during building of this container
ARG MY_FILES_DIR=files
ARG TMP_DIR=/tmp/cs_sensor
ARG CS_NAME="HPE_Security_Fortify_SCA_and_Apps_16.20"
ARG CS_RUN="${CS_NAME}_linux_x64.run"
ARG FORTIFY_BASE_DIR=/opt/app/fortify
ARG FORTIFY_VERSION="16.20"
ARG FORTIFY_DIR=$FORTIFY_BASE_DIR/$FORTIFY_VERSION
ARG INSTALL_OPTIONS=cloudscan_sensor.options

#create fortify and temp dirs for install of cloudscan sensor
RUN mkdir -p $TMP_DIR/
RUN mkdir -p $FORTIFY_DIR

COPY $MY_FILES_DIR/* $FORTIFY_BASE_DIR/
RUN ls -l $FORTIFY_BASE_DIR

#copy options file for install
#RUN mv $TMP_DIR/$INSTALL_OPTIONS $FORTIFY_BASE_DIR

ENV PATH "$PATH:/usr/bin/java"
ENV JAVA_HOME "/usr/bin/java"

#cleanup temp dir
RUN rm -rf $TMP_DIR
