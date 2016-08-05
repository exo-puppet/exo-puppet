# Class: puppet::install
#
# This class manage the installation of the puppet package
class puppet::master::install {
  ensure_packages ( 'puppetmaster', { 'ensure' => $puppet::params::ensure_mode, 'require' => Apt::Source['puppetlabs'] } )
}
