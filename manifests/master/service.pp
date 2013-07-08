# Class: puppet::master::service
#
# This class manage the puppet services
#
class puppet::master::service {
  service { 'puppetmaster':
    ensure     => $puppet::params::master_service_ensure,
    name       => $puppet::params::master_service_name,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['puppet::params', 'puppet::master::config'],
  }
}
