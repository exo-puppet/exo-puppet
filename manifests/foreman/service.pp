# Class: puppet::service
#
# This class manage the puppet services
#
# TODO Split puppet::service in 2 other classes (puppet::service_master puppet::service_dashboard) to better manage Notify in
# puppet::config
#
class puppet::foreman::service {
  # TODO finish to implement Foreman Services

  service { 'foreman':
    # We don't want foreman with WebRick but with Apache Passenger
    ensure     => stopped,
    name       => $puppet::params::foreman_service_name,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['puppet::params', 'puppet::foreman::config', 'puppet::foreman::install'],
  }

  service { 'foreman-proxy':
    # We don't want foreman-proxy with WebRick but with Apache Passenger
    # ensure     => $puppet::params::dashboard_service_ensure,
    ensure     => stopped,
    #    ensure     => running,
    name       => $puppet::params::foreman_proxy_service_name,
    hasstatus  => true,
    hasrestart => true,
    require    => Class['puppet::params', 'puppet::foreman::config', 'puppet::foreman::install'],
  }
}
