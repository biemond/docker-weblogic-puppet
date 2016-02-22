FROM oraclelinux:7

RUN rpm --import https://yum.puppetlabs.com/RPM-GPG-KEY-puppetlabs && \
    rpm -ivh http://yum.puppetlabs.com/el/7/products/x86_64/puppetlabs-release-7-11.noarch.rpm

# configure & install puppet
RUN yum -y install hostname.x86_64 rubygems ruby-devel gcc git && \
    echo "gem: --no-ri --no-rdoc" > ~/.gemrc && \
    yum install -y --skip-broken puppet tar && \
    gem install librarian-puppet && \
    yum clean all

ADD puppet/Puppetfile /etc/puppet/
ADD puppet/manifests/site.pp /etc/puppet/
ADD puppet/hiera.yaml /etc/puppet/
ADD puppet/hieradata/common.yaml /etc/puppet/

WORKDIR /etc/puppet/

RUN librarian-puppet install --verbose && \
    librarian-puppet show

# upload software
RUN mkdir /var/tmp/install && \
    chmod 777 /var/tmp/install && \
    mkdir /software && \
    chmod 777 /software

COPY jdk-7u55-linux-x64.tar.gz /software/
COPY fmw_12.1.3.0.0_wls.jar /var/tmp/install/

RUN puppet apply /etc/puppet/site.pp --verbose --trace --modulepath /etc/puppet/modules --hiera_config /etc/puppet/hiera.yaml --detailed-exitcodes || [ $? -eq 2 ]

WORKDIR /

# cleanup
RUN rm -rf /software/* && \
    rm -rf /var/tmp/install/* && \
    rm -rf /var/tmp/* && \
    rm -rf /tmp/*

EXPOSE 5556 7001 8001

ADD startWls.sh /
RUN chmod 0755 /startWls.sh

CMD bash -C '/startWls.sh';'bash'
