# Class: puppet::install
#
# This class manage the installation of the puppet package
class puppet::install {
  case $::operatingsystem {
    /(Ubuntu|Debian)/ : {
      case $::lsbdistrelease {
        /(12.04|14.04)/ : {

          apt::source { 'puppetlabs':
            location => 'http://apt.puppetlabs.com',
            repos    => 'main dependencies',
            key      => {
              'id'     => '6F6B15509CF8E59E6E469F327F438280EF8D349F',
              'server' => 'pgp.mit.edu',
            },
          }
          # Agent packages
          # ensure_packages ( 'libaugeas-ruby1.8',    { 'ensure' => $puppet::params::ensure_mode, 'require' => [Apt::Source['puppetlabs'],Class['apt::update'] } )
          # ensure_packages ( 'libaugeas-ruby1.9.1',  { 'ensure' => $puppet::params::ensure_mode, 'require' => [Apt::Source['puppetlabs'],Class['apt::update']] } )
          # ensure_packages ( 'augeas-tools',         { 'ensure' => $puppet::params::ensure_mode, 'require' => [Apt::Source['puppetlabs'],Class['apt::update'] } )
          # ensure_packages ( 'augeas-lenses',        { 'ensure' => $puppet::params::ensure_mode, 'require' => [Apt::Source['puppetlabs'],Class['apt::update'] } )
          # ensure_packages ( 'puppet', { 'ensure' => $puppet::params::ensure_mode, 'require' => Apt::Source['puppetlabs'] } )
          # ensure_packages ( 'facter', { 'ensure' => $puppet::params::ensure_mode, 'require' => Apt::Source['puppetlabs'] } )

          ensure_packages ([
            'libaugeas-ruby1.8',
            'libaugeas-ruby1.9.1',
            'augeas-tools',
            'augeas-lenses',
            'puppet',
            'facter'
          ], {
            'ensure'  => $puppet::params::ensure_mode,
            'require' => [Apt::Source['puppetlabs'],Class['apt::update']]
          } )
        }
        /(16.04)/ : {

          apt::source { 'puppetlabs':
            location => 'http://apt.puppetlabs.com',
            repos    => 'main dependencies',
            key      => {
              'id'     => '6F6B15509CF8E59E6E469F327F438280EF8D349F',
              'server' => 'pgp.mit.edu',
            },
          }
          # Agent packages
          # ruby-augeas installed instead of libaugeas-ruby
          # ensure_packages ( 'augeas-tools',         { 'ensure' => $puppet::params::ensure_mode, 'require' => [Apt::Source['puppetlabs'],Class['apt::update'] } )
          # ensure_packages ( 'augeas-lenses',        { 'ensure' => $puppet::params::ensure_mode, 'require' => [Apt::Source['puppetlabs'],Class['apt::update'] } )
          # ensure_packages ( 'puppet', { 'ensure' => $puppet::params::ensure_mode, 'require' => Apt::Source['puppetlabs'] } )
          # ensure_packages ( 'facter', { 'ensure' => $puppet::params::ensure_mode, 'require' => Apt::Source['puppetlabs'] } )

          ensure_packages ([
            'augeas-tools',
            'augeas-lenses',
            'puppet',
            'facter'
          ], {
            'ensure'  => $puppet::params::ensure_mode,
            'require' => [Apt::Source['puppetlabs'],Class['apt::update']]
          } )
        }
        default   : {
          # Agent packages
          # ensure_packages ( 'libaugeas-ruby1.8', { 'ensure' => $puppet::params::ensure_mode } )
          # ensure_packages ( 'augeas-tools', { 'ensure' => $puppet::params::ensure_mode } )
          # ensure_packages ( 'augeas-lenses', { 'ensure' => $puppet::params::ensure_mode } )
          # ensure_packages ( 'puppet', { 'ensure' => $puppet::params::ensure_mode } )
          # ensure_packages ( 'facter', { 'ensure' => $puppet::params::ensure_mode } )

          ensure_packages ([
            'libaugeas-ruby1.8',
            'augeas-tools',
            'augeas-lenses',
            'puppet',
            'facter'
          ], {
            'ensure'  => $puppet::params::ensure_mode,
            'require' => [Class['apt::update']]
          } )
        }
      }
    }
  }

  # Master packages
  if ($puppet::master == true) {
    include puppet::master::install
  }

  # Dashboard packages
  if ($puppet::dashboard == true) {
    include puppet::dashboard::install
  }

  # Foreman packages
  if ($puppet::foreman == true) {
    include puppet::foreman::install
  }
}
