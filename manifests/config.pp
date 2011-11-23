# Class: puppet::config
#
# This class manage the puppet configuration
class puppet::config {
	file { $puppet::params::config_file:
		ensure => file,
		owner  => root,
		group  => root,
		mode   => 0644,
		content => template("puppet/$puppet::params::config_template"),
		require => Class["puppet::install"],
		notify => Class["puppet::service"],
	}
}
