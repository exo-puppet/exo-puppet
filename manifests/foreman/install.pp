# Class: puppet::foreman::install
#
# This class manage the installation of the foreman package
class puppet::foreman::install {
  case $::operatingsystem {
    /(Ubuntu)/ : {
      case $::lsbdistrelease {
        /(12.04)/ : {
          $forman_version = '1.7'
          # We need this repo because : http://theforeman.org/manuals/1.7/index.html#3.6Upgrade
          # Ubuntu 12.04 (Precise) users must ensure the Brightbox Ruby NG PPA is configured and that the default Ruby version is 1.8
          repo::define { 'brightbox-ruby-ng-repo':
            file_name => 'brightbox-ruby-ng',
            url       => 'http://ppa.launchpad.net/brightbox/ruby-ng/ubuntu',
            sections  => [
              'main'],
            source    => false,
            key       => 'C3173AA6',
            key_server => 'keyserver.ubuntu.com',
            notify    => Exec['repo-update'],
          } ->
          repo::define { 'foreman-repo':
            file_name => 'foreman',
            url       => 'http://deb.theforeman.org/',
            sections  => [
              $forman_version],
            source    => false,
            key       => '1AA043B8',
            key_server => 'keyserver.ubuntu.com',
            notify    => Exec['repo-update'],
          } ->
          repo::define { 'foreman-plugin-repo':
            file_name => 'foreman-plugins',
            url       => 'http://deb.theforeman.org/',
            distribution  => 'plugins',
            sections  => [
              $forman_version],
            source    => false,
            notify    => Exec['repo-update'],
          }

            package { 'passenger-common':
              ensure  => $puppet::params::ensure_mode,
              name    => 'passenger-common1.9.1',
              require => [
                Exec['repo-update'],
                Repo::Define['foreman-repo']],
            }
        }
        default   : {
          fail("The ${module_name} module is not supported on ${::operatingsystem} ${::lsbdistrelease} (only 12.04 Precise is supported)"
          )
        }
      }
    }
    default    : {
      fail("The ${module_name} module is not supported on ${::operatingsystem}")
    }
  }
  package { 'foreman':
    ensure  => $puppet::params::ensure_mode,
    require => [
      Exec['repo-update'],
      Repo::Define['foreman-repo']],
  } -> package { 'foreman-mysql2': ensure => $puppet::params::ensure_mode, }
}
