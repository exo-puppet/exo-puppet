# Class: puppet::dashboard::install
#
# This class manage the installation of the puppet package
class puppet::dashboard::install {
  ensure_packages ( 'rack', { 'ensure' => '1.1.2', 'provider' => 'gem' } )
  ensure_packages ( 'puppet-dashboard', { 'ensure' => $puppet::params::ensure_mode, 'require' => Apt::Source['puppetlab'] } )
}
