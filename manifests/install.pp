# Class: puppet::install
#
# This class manage the installation of the puppet package
class puppet::install {
	
	case $::operatingsystem {
		/(Ubuntu|Debian)/: {
			file { "/etc/apt/sources.list.d/puppet.list":
		    	content => template("puppet/sources.list.puppet.erb"),
	    	}
	    }
    }
    
	package { "puppet": ensure => $puppet::params::ensure_mode, }
	package { "facter": ensure => $puppet::params::ensure_mode, }
}
