# Class: puppet::install
#
# This class manage the installation of the puppet package
class puppet::install {
	
	case $::operatingsystem {
		/(Ubuntu|Debian)/: {
            repo::define { "puppetlab-repo":
                file_name   => "puppetlab",
                url         => "http://apt.puppetlabs.com/ubuntu",
                sections    => ["main"],
                source      => true,
                key         => "4BD6EC30",
                key_server  => "keyserver.ubuntu.com",
                notify      => Exec["repo-update"],
            }
            
            # this fil eremover is here to clean up puppet.list manually added during system installation
            repo::define { "puppetlab-oldfile":
                file_name   => "puppet",
                url         => "http://apt.puppetlabs.com/ubuntu",
                sections    => ["main"],
                source      => true,
                installed   => false,
                notify  => Exec["repo-update"],
            }
	    }
    }
    
    # Agent packages
	package { ["puppet", "facter"]: 
        ensure    => $puppet::params::ensure_mode, 
        require   => [ Exec ["repo-update"], Repo::Define [ "puppetlab-repo" ] ],
	}

    # Master packages
	if ( $puppet::master == true ) {
		package { "puppetmaster": 
            ensure      => $puppet::params::ensure_mode, 
            require   => [ Exec ["repo-update"], Repo::Define [ "puppetlab-repo" ] ],
		}
	}

    # Dashboard packages
	if ( $puppet::dashboard == true ) {
		package { "puppet-dashboard": 
            ensure  => $puppet::params::ensure_mode, 
            require   => [ Exec ["repo-update"], Repo::Define [ "puppetlab-repo" ] ],
		}
	}
}
