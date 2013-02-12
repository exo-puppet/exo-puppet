# Class: puppet::dashboard::install
#
# This class manage the installation of the puppet package
class puppet::dashboard::install {
	package { "puppet-dashboard":
    ensure  => $puppet::params::ensure_mode,
    require   => [ Exec ["repo-update"], Repo::Define [ "puppetlab-repo" ] ],
	}
}
