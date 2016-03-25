FROM ubuntu:14.04

MAINTAINER James Dunnam "jamesd1184@gmail.com"

ENV MAVEN_VERSION 3.3.9

RUN echo deb http://archive.ubuntu.com/ubuntu precise universe > /etc/apt/sources.list.d/universe.list
RUN apt-get update && apt-get install -y wget git curl zip monit openssh-server git iptables ca-certificates daemon net-tools

#Install Oracle JDK 8
#--------------------
RUN echo "# Installing Oracle JDK 8" && \
    sudo apt-get install -y software-properties-common debconf-utils && \
    sudo add-apt-repository -y ppa:webupd8team/java && \
    sudo apt-get update && \
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | sudo debconf-set-selections && \
    sudo apt-get install -y oracle-java8-installer
# Maven related
# -------------
ENV MAVEN_ROOT /var/lib/maven
ENV MAVEN_HOME $MAVEN_ROOT/apache-maven-$MAVEN_VERSION
ENV MAVEN_OPTS -Xms256m -Xmx512m

RUN echo "# Installing Maven " && echo ${MAVEN_VERSION} && \
    wget --no-verbose -O /tmp/apache-maven-$MAVEN_VERSION.tar.gz \
    http://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz && \
    mkdir -p $MAVEN_ROOT && \
    tar xzf /tmp/apache-maven-$MAVEN_VERSION.tar.gz -C $MAVEN_ROOT && \
    ln -s $MAVEN_HOME/bin/mvn /usr/local/bin && \
    rm -f /tmp/apache-maven-$MAVEN_VERSION.tar.gz

VOLUME /var/lib/maven

# Node related
# ------------
ENV PHANTOMJS_VERSION 1.9.8

RUN echo "# Installing Nodejs" && \
    curl -sL https://deb.nodesource.com/setup | bash - && \
    apt-get install nodejs build-essential -y && \
    npm set strict-ssl false && \
    npm install -g npm@latest && \
    npm install -g bower grunt grunt-cli && \
    echo "# Phantomjs" && \
      mkdir -p /srv/var && \
      wget -q --no-check-certificate -O /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 \
      https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
      tar -xjf /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 -C /tmp && \
      rm -f /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
      mv /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/ /usr/lib/phantomjs && \
      ln -s /usr/lib/phantomjs/bin/phantomjs /usr/bin/phantomjs
