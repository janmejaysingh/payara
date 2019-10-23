FROM openshift/base-centos7
LABEL maintainer="janmejay, janmejay" description="Base image for all payara images"
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0
ENV PATH "$PATH":/${JAVA_HOME}/bin:.:
ENV PAYARA_ARCHIVE payara5
ENV DOMAIN_NAME domain1
ENV INSTALL_DIR /opt
ENV PAYARA_HOME ${INSTALL_DIR}/${PAYARA_ARCHIVE}/glassfish
ENV DEPLOYMENT_DIR ${INSTALL_DIR}/deploy
ENV BUILDER_VERSION 0.0.3
RUN yum update -y \
  && yum -y install unzip \
  && yum -y install java-1.8.0-openjdk-devel \
  && yum clean all
RUN curl -o ${INSTALL_DIR}/${PAYARA_ARCHIVE}.zip -L https://s3-eu-west-1.amazonaws.com/payara.fish/Payara+Downloads/5.191/payara-5.191.zip \ 
    && unzip ${INSTALL_DIR}/${PAYARA_ARCHIVE}.zip -d ${INSTALL_DIR} \ 
    && rm ${INSTALL_DIR}/${PAYARA_ARCHIVE}.zip
RUN mkdir ${DEPLOYMENT_DIR} \
    && chown -R 1001:0 ${INSTALL_DIR} \
    && chmod -R a+rw ${INSTALL_DIR}
ADD start.sh .
RUN chmod a+x start.sh
USER 1001
EXPOSE 4848 8009 8080 8181
LABEL io.k8s.description="Payara 5 S2I Image" \
      io.k8s.display-name="Payara 5 S2I Builder" \
      io.openshift.expose-services="8080:http" \
      io.openshift.tags="builder,airhacks,payara,payara5, javaee"
COPY ./s2i/bin/ /usr/libexec/s2i