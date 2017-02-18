FROM oraclelinux:7

RUN yum -y install hostname.x86_64 wget git binutils.x86_64 unzip.x86_64 net-tools && \
    wget --output-document=/tmp/puppetlabs-release-pc1-el-7.noarch.rpm https://yum.puppetlabs.com/puppetlabs-release-pc1-el-7.noarch.rpm  && \
    rpm -i /tmp/puppetlabs-release-pc1-el-7.noarch.rpm  && \
    echo "gem: --no-ri --no-rdoc" > ~/.gemrc && \
    yum install -y --skip-broken puppet tar && \
    /opt/puppetlabs/puppet/bin/gem install librarian-puppet && \
    yum clean all

ADD puppet/Puppetfile /etc/puppetlabs/
ADD puppet/manifests/site.pp /etc/puppetlabs/code/manifests/
ADD puppet/hiera.yaml /etc/puppetlabs/
ADD puppet/hieradata/common.yaml /etc/puppetlabs/

WORKDIR /etc/puppetlabs/

RUN export PATH=$PATH:/opt/puppetlabs/bin:/opt/puppetlabs/puppet/bin && \
    LIBRARIAN_PUPPET_PATH=code/modules librarian-puppet install --verbose && \
    librarian-puppet show

# upload software
RUN mkdir /var/tmp/install && \
    chmod 777 /var/tmp/install && \
    mkdir /software && \
    chmod 777 /software

COPY jdk-8u111-linux-x64.tar.gz /software/
COPY fmw_12.2.1.2.0_wls.jar /var/tmp/install/

RUN /opt/puppetlabs/bin/puppet apply /etc/puppetlabs/code/manifests/site.pp --verbose --trace --hiera_config /etc/puppetlabs/hiera.yaml --detailed-exitcodes || [ $? -eq 2 ] && \
    rm -rf /software/* && \
    rm -rf /var/tmp/install/* && \
    rm -rf /var/tmp/* && \
    rm -rf /tmp/*

WORKDIR /


EXPOSE 5556 7001 8001

ADD startWls.sh /
RUN chmod 0755 /startWls.sh

CMD bash -C '/startWls.sh';'bash'
