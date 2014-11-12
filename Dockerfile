FROM centos:centos7

# Need to enable centosplus for the image libselinux issue
RUN yum install -y yum-utils
RUN yum-config-manager --enable centosplus

RUN yum -y install hostname.x86_64 rubygems ruby-devel gcc git
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc
#RUN yum group install "Base"
#RUN yum group install "Development Tools"

RUN rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs && \
    rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm

# configure & install puppet
RUN yum install -y puppet tar
RUN gem install puppet librarian-puppet

RUN yum -y install httpd; yum clean all

ADD puppet/Puppetfile /etc/puppet/
ADD puppet/manifests/site.pp /etc/puppet/
ADD puppet/hiera.yaml /etc/puppet/
ADD puppet/hieradata/common.yaml /etc/puppet/

WORKDIR /etc/puppet/
RUN librarian-puppet install

# upload software
RUN mkdir /var/tmp/install
RUN chmod 777 /var/tmp/install

RUN mkdir /software
RUN chmod 777 /software

COPY jdk-7u55-linux-x64.tar.gz /software/
COPY fmw_12.1.3.0.0_wls.jar /var/tmp/install/

RUN puppet apply /etc/puppet/site.pp --verbose --detailed-exitcodes || [ $? -eq 2 ]

CMD /opt/scripts/wls/stopWeblogicAdmin.sh
CMD /opt/scripts/wls/stopNodeManager.sh

EXPOSE 5556 7001 8001

ADD startWls.sh /
RUN chmod 0755 /startWls.sh


WORKDIR /

# cleanup
RUN rm -rf /software/*
RUN rm -rf /var/tmp/install/*
RUN rm -rf /var/tmp/*
RUN rm -rf /tmp/*

CMD bash -C '/startWls.sh';'bash'
