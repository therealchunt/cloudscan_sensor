FROM chunt/private:debian_base 
MAINTAINER "chunt"

#args used during building of this container
ARG MY_FILES_DIR=files
ARG TMP_DIR=/root/mytemp
ARG CS_NAME="HPE_Security_Fortify_SCA_and_Apps_16.20"
ARG CS_RUN="${CS_NAME}_linux_x64.run"
ARG FORTIFY_BASE_DIR=/opt/app/fortify
ARG FORTIFY_VERSION="16.20"
ARG FORTIFY_DIR=$FORTIFY_BASE_DIR/$FORTIFY_VERSION
ARG INSTALL_OPTIONS=cloudscan_sensor.options

#create fortify and temp dirs for install of cloudscan sensor
RUN mkdir $TMP_DIR/
COPY $MY_FILES_DIR/* $TMP_DIR/

RUN mkdir -p $FORTIFY_DIR
COPY $TMP_DIR/$CS_RUN $FORTIFY_BASE_DIR/

#copy options file for install
COPY $TMP_DIR/$INSTALL_OPTIONS $FORTIFY_BASE_DIR

RUN ./$FORTIFY_BASE_DIR/$CS_RUN --mode unattended --optionfile $FORTIFY_BASE_DIR/$INSTALL_OPTIONS

RUN cp -R $CC_TMP/$CC_NAME/tomcat/webapps/cloud-ctrl/ $TOMCAT_DIR/webapps/
#RUN tar -xvf $TMP_DIR/cloud-ctrl.tar -C $TOMCAT_DIR/webapps/

#overwrite properties file
RUN mv $TMP_DIR/config.properties $TOMCAT_DIR/webapps/cloud-ctrl/WEB-INF/classes/

#RUN sed -i '9i\ worker_auth_token=${' $TOMCAT_DIR/webapps/cloud-ctrl/WEB-INF/classes/config.properties
#RUN sed -i '265i \CATALINA_OPTS=" -javaagent:$CATALINA_HOME/WI_Agent/lib/FortifyAgent.jar $CATALINA_OPTS"' $TOMCAT_DIR/bin/catalina.sh


#cleanup temp dir
RUN rm -rf $TMP_DIR
