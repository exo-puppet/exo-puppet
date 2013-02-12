# Class: puppet::install
#
# This class manage the installation of the puppet package
class puppet::master::install {
	package { "puppetmaster":
    ensure      => $puppet::params::ensure_mode,
    require   => [ Exec ["repo-update"], Repo::Define [ "puppetlab-repo" ] ],
	}
}
