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
          apt::key { 'ppa:brightbox/ruby-ng':
            id      => '80F70E11F0F0D5F10CB20E62F5DA5F09C3173AA6',
            server  => 'keyserver.ubuntu.com',
          } ->
          apt::ppa { 'ppa:brightbox/ruby-ng': ensure => 'present', package_manage => true } ->
          apt::key { 'foreman':
            id      => '7059542D5AEA367F78732D02B3484CB71AA043B8',
            server  => 'keyserver.ubuntu.com',
          } ->
          apt::source { 'foreman':
            location => 'http://deb.theforeman.org/',
            repos    => $forman_version,
          } ->
          apt::source { 'foreman-plugins':
            location       => 'http://deb.theforeman.org/',
            repos          => $forman_version,
            release        => 'plugins',
          }

          # ensure_packages ( 'passenger-common', {
          #   'ensure'  => $puppet::params::ensure_mode,
          #   'name'    => 'passenger-common1.9.1',
          #   'require' => [Apt::Source['foreman'],Class['apt::update']],
          # } )
          ensure_packages ( ['foreman','foreman-mysql2'], {
            'ensure' => $puppet::params::ensure_mode,
            'require' => [Apt::Source['foreman'],Class['apt::update'],Package['ruby1.9.3']],
          } )
        }
        default   : {
          fail("The ${module_name} module is not supported on ${::operatingsystem} ${::lsbdistrelease} (only 12.04 Precise is supported)" )
        }
      }
    }
    default    : {
      fail("The ${module_name} module is not supported on ${::operatingsystem}")
    }
  }
}
