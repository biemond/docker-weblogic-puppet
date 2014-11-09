FROM centos:latest

# Need to enable centosplus for the image libselinux issue
RUN yum install -y yum-utils
RUN yum-config-manager --enable centosplus

RUN yum -y install hostname.x86_64 rubygems ruby-devel gcc git bind-utils net-tools
RUN echo "gem: --no-ri --no-rdoc" > ~/.gemrc

RUN rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs && \
    rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-7.noarch.rpm

# configure & install puppet
RUN yum install -y puppet tar
RUN gem install puppet librarian-puppet

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

EXPOSE 5556 7001 8001

CMD /opt/scripts/wls/startNodeManager.sh && /opt/scripts/wls/startWeblogicAdmin.sh
