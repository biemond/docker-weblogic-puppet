#

node 'default' {

  include os
  include java
  include orawls::weblogic, orautils
  include fmw
  include opatch
  include domains
  include nodemanager, startwls, userconfig
  include security
  include basic_config
  include datasources
  include virtual_hosts
  include workmanagers
  include file_persistence
  include jms

  Class[java] -> Class[orawls::weblogic]
}

# operating settings for Middleware
class os {

  group { 'dba' :
    ensure => present,
  }

  # http://raftaman.net/?p=1311 for generating password
  # password = oracle
  user { 'oracle' :
    ensure     => present,
    groups     => 'dba',
    shell      => '/bin/bash',
    password   => '$1$DSJ51vh6$4XzzwyIOk6Bi/54kglGk3.',
    home       => "/home/oracle",
    comment    => 'wls user created by Puppet',
    managehome => true,
    require    => Group['dba'],
  }

}

class java {
  require os

  include jdk7

  jdk7::install7{ 'jdk1.8.0_111':
      version                   => "8u111" ,
      full_version              => "jdk1.8.0_111",
      alternatives_priority     => 18000,
      x64                       => true,
      download_dir              => "/var/tmp/install",
      urandom_java_fix          => true,
      rsa_key_size_fix          => true,
      source_path               => "/software",
  }
}


class fmw{
  $default_params = {}
  $fmw_installations = hiera('fmw_installations', {})
  create_resources('orawls::fmw',$fmw_installations, $default_params)
}

class opatch{
  require fmw,orawls::weblogic
  $default_params = {}
  $opatch_instances = hiera('opatch_instances', {})
  create_resources('orawls::opatch',$opatch_instances, $default_params)
}

class domains{
  require orawls::weblogic, opatch

  $default_params = {}
  $domain_instances = hiera('domain_instances', {})
  create_resources('orawls::domain',$domain_instances, $default_params)

  $wls_setting_instances = hiera('wls_setting_instances', {})
  create_resources('wls_setting',$wls_setting_instances, $default_params)

}

class nodemanager {
  require orawls::weblogic, domains

  $default_params = {}
  $nodemanager_instances = hiera('nodemanager_instances', {})
  create_resources('orawls::nodemanager',$nodemanager_instances, $default_params)
}

class startwls {
  require orawls::weblogic, domains,nodemanager

  $default_params = {}
  $control_instances = hiera('control_instances', {})
  create_resources('orawls::control',$control_instances, $default_params)
}

class userconfig{
  require orawls::weblogic, domains, nodemanager, startwls
  $default_params = {}
  $userconfig_instances = hiera('userconfig_instances', {})
  create_resources('orawls::storeuserconfig',$userconfig_instances, $default_params)
}


class security{
  require userconfig
  $default_params = {}
  $user_instances = hiera('user_instances', {})
  create_resources('wls_user',$user_instances, $default_params)

  $group_instances = hiera('group_instances', {})
  create_resources('wls_group',$group_instances, $default_params)

  $authentication_provider_instances = hiera('authentication_provider_instances', {})
  create_resources('wls_authentication_provider',$authentication_provider_instances, $default_params)
}

class basic_config{
  require security
  $default_params = {}

  $wls_domain_instances = hiera('wls_domain_instances', {})
  create_resources('wls_domain',$wls_domain_instances, $default_params)

  # subscribe on changes
  $wls_adminserver_instances = hiera('wls_adminserver_instances', {})
  create_resources('wls_adminserver',$wls_adminserver_instances, $default_params)

  $machines_instances = hiera('machines_instances', {})
  create_resources('wls_machine',$machines_instances, $default_params)

  $server_instances = hiera('server_instances', {})
  create_resources('wls_server',$server_instances, $default_params)

  $server_channel_instances = hiera('server_channel_instances', {})
  create_resources('wls_server_channel',$server_channel_instances, $default_params)

  $cluster_instances = hiera('cluster_instances', {})
  create_resources('wls_cluster',$cluster_instances, $default_params)

  $coherence_cluster_instances = hiera('coherence_cluster_instances', {})
  create_resources('wls_coherence_cluster',$coherence_cluster_instances, $default_params)

  $server_template_instances = hiera('server_template_instances', {})
  create_resources('wls_server_template',$server_template_instances, $default_params)

  $dynamic_cluster_instances = hiera('dynamic_cluster_instances', {})
  create_resources('wls_dynamic_cluster',$dynamic_cluster_instances, $default_params)

}

class datasources{
  require basic_config
  $default_params = {}
  $datasource_instances = hiera('datasource_instances', {})
  create_resources('wls_datasource',$datasource_instances, $default_params)
}


class virtual_hosts{
  require datasources
  $default_params = {}
  $virtual_host_instances = hiera('virtual_host_instances', {})
  create_resources('wls_virtual_host',$virtual_host_instances, $default_params)
}

class workmanagers{
  require virtual_hosts
  $default_params = {}

  $workmanager_constraint_instances = hiera('workmanager_constraint_instances', {})
  create_resources('wls_workmanager_constraint',$workmanager_constraint_instances, $default_params)

  $workmanager_instances = hiera('workmanager_instances', {})
  create_resources('wls_workmanager',$workmanager_instances, $default_params)
}

class file_persistence{
  require workmanagers

  $default_params = {}

  $file_persistence_folders = hiera('file_persistence_folders', {})
  create_resources('file',$file_persistence_folders, $default_params)

  $file_persistence_store_instances = hiera('file_persistence_store_instances', {})
  create_resources('wls_file_persistence_store',$file_persistence_store_instances, $default_params)
}

class jms{
  require file_persistence

  $default_params = {}
  $jmsserver_instances = hiera('jmsserver_instances', {})
  create_resources('wls_jmsserver',$jmsserver_instances, $default_params)

  $jms_module_instances = hiera('jms_module_instances', {})
  create_resources('wls_jms_module',$jms_module_instances, $default_params)

  $jms_subdeployment_instances = hiera('jms_subdeployment_instances', {})
  create_resources('wls_jms_subdeployment',$jms_subdeployment_instances, $default_params)

  $jms_quota_instances = hiera('jms_quota_instances', {})
  create_resources('wls_jms_quota',$jms_quota_instances, $default_params)

  $jms_connection_factory_instances = hiera('jms_connection_factory_instances', {})
  create_resources('wls_jms_connection_factory',$jms_connection_factory_instances, $default_params)

  $jms_queue_instances = hiera('jms_queue_instances', {})
  create_resources('wls_jms_queue',$jms_queue_instances, $default_params)

  $jms_topic_instances = hiera('jms_topic_instances', {})
  create_resources('wls_jms_topic',$jms_topic_instances, $default_params)

  $foreign_server_instances = hiera('foreign_server_instances', {})
  create_resources('wls_foreign_server',$foreign_server_instances, $default_params)

  $foreign_server_object_instances = hiera('foreign_server_object_instances', {})
  create_resources('wls_foreign_server_object',$foreign_server_object_instances, $default_params)

  $safagent_instances = hiera('safagent_instances', {})
  create_resources('wls_safagent',$safagent_instances, $default_params)

  $saf_remote_context_instances = hiera('saf_remote_context_instances', {})
  create_resources('wls_saf_remote_context',$saf_remote_context_instances, $default_params)

  $saf_error_handler_instances = hiera('saf_error_handler_instances', {})
  create_resources('wls_saf_error_handler',$saf_error_handler_instances, $default_params)

  $saf_imported_destination_instances = hiera('saf_imported_destination_instances', {})
  create_resources('wls_saf_imported_destination',$saf_imported_destination_instances, $default_params)

  $saf_imported_destination_object_instances = hiera('saf_imported_destination_object_instances', {})
  create_resources('wls_saf_imported_destination_object',$saf_imported_destination_object_instances, $default_params)
}
