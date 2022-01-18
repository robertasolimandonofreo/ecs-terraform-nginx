FROM jenkins/jenkins:lts
USER root

RUN apt-get update && \
    apt-get -y install apt-transport-https \
      ca-certificates \
      curl \
      gnupg2 \
      unzip \
      wget \
      software-properties-common && \
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
    add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
      $(lsb_release -cs) \
      stable" && \
   apt-get update && \
   apt-get -y install docker-ce

RUN wget https://releases.hashicorp.com/terraform/1.0.7/terraform_1.0.7_linux_amd64.zip \
&& unzip terraform_1.0.7_linux_amd64.zip \
&& mv terraform /usr/local/bin/

COPY ./jenkins-plugins /usr/share/jenkins/plugins

ENV JENKINS_USER admin
ENV JENKINS_PASS admin


ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/

VOLUME /var/jenkins_home