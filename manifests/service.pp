# Class: puppet::service
#
# This class manage the puppet services
#
# TODO Split puppet::service in 2 other classes (puppet::service_master puppet::service_dashboard) to better manage Notify in
# puppet::config
#
class puppet::service {
  # include "puppet::params"

  # Puppet Agent Service
  service { 'puppet':
    ensure     => $puppet::params::agent_service_ensure,
    name       => $puppet::params::service_name,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['puppet::params', 'puppet::config'],
  }

  # Puppet Master Service
  if ($puppet::master == true) {
    include puppet::master::service
  }

  # Puppet Dashboard Service
  if ($puppet::dashboard == true) {
    include puppet::dashboard::service
  }

  # Foreman Service
  if ($puppet::foreman == true) {
    include puppet::foreman::service
  }
}
