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
            key         => '80F70E11F0F0D5F10CB20E62F5DA5F09C3173AA6',
            key_server  => 'keyserver.ubuntu.com',
          }
          apt::ppa { 'ppa:brightbox/ruby-ng': ensure => 'present', package_manage => true }

          apt::key { 'foreman':
            key         => 'AE0AF310E2EA96B6B6F4BD726F8600B9563278F6',
            key_server  => 'keyserver.ubuntu.com',
          }
          apt::source { 'foreman':
            location    => 'http://deb.theforeman.org/',
            repos       => $forman_version,
            include_src => false,
          }
          apt::source { 'foreman-plugins':
            # ensure         => absent,
            location       => 'http://deb.theforeman.org/',
            repos          => $forman_version,
            release        => 'plugins',
            include_src => false,
          }

          ensure_packages ( 'ruby1.9.3' )
          # ensure_packages ( 'passenger-common', {
          #   'ensure'  => $puppet::params::ensure_mode,
          #   'name'    => 'passenger-common1.9.1',
          #   'require' => [Apt::Source['foreman'],Class['apt::update']],
          # } )
          ensure_packages ( ['foreman','foreman-mysql2'], {
            'ensure'  => $puppet::params::ensure_mode,
            'require' => [Apt::Source['foreman'],Package['ruby1.9.3']],
            # 'require' => [Apt::Source['foreman'],Apt::Source['foreman-plugins'],Package['ruby1.9.3']],
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
