# Class: puppet::service
#
# This class manage the puppet services
#
# TODO Split puppet::service in 2 other classes (puppet::service_master puppet::service_dashboard) to better manage Notify in puppet::config
#
class puppet::dashboard::service {

	# TODO finish to implement Puppet Dashboard Service (puppet-dashboard + puppet-dashboard-workers)

  service { "puppet-dashboard":
    # We don't want puppet-dashboard with WebRick but with Apache
    #ensure     => $puppet::params::dashboard_service_ensure,
    ensure     => stopped,
    name       => $puppet::params::dashboard_service_name,
    hasstatus  => true,
    hasrestart => true,
    require => Class [ "puppet::params","puppet::dashboard::config" ],
  }
  service { "puppet-dashboard-workers":
    ensure     => $puppet::params::dashboard_service_ensure,
    name       => $puppet::params::dashboard_service_worker_name,
    hasstatus  => true,
    hasrestart => true,
    require => Class [ "puppet::params","puppet::dashboard::config" ],
  }
}
