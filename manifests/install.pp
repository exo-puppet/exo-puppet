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
    
    # Agent packages
	package { ["puppet", "facter"]: 
		ensure => $puppet::params::ensure_mode, 
	}

    # Master packages
	if ( $puppet::master == true ) {
		package { "puppetmaster": 
			ensure => $puppet::params::ensure_mode, 
		}
	}

    # Dashboard packages
	if ( $puppet::dashboard == true ) {
		package { "puppet-dashboard": 
			ensure => $puppet::params::ensure_mode, 
		}
	}
}
