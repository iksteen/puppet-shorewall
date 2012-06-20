class shorewall(
  $startup = '1'
) {

  case $::operatingsystem {
    gentoo: { include shorewall::gentoo }
    debian: {
      include shorewall::debian
      $dist_tor_user = 'debian-tor'
    }
    centos: { include shorewall::base }
    ubuntu: {
    case $::lsbdistcodename {
      karmic: { include shorewall::ubuntu::karmic }
      default: { include shorewall::debian }
      }
    }
    default: {
      notice "unknown operatingsystem: $operatingsystem" 
      include shorewall::base
    }
  }

  case $tor_transparent_proxy_host {
    '': { $tor_transparent_proxy_host = '127.0.0.1' }
  }
  case $tor_transparent_proxy_port {
    '': { $tor_transparent_proxy_port = '9040' }
  }
  if $tor_user == '' {
    $tor_user = $dist_tor_user ? {
      ''      => 'tor',
      default => $dist_tor_user,
    }
  }
  case $non_torified_users {
    '': { $non_torified_users = [] }
  }
  $real_non_torified_users = uniq_flatten($tor_user, $non_torified_users)

  # See http://www.shorewall.net/3.0/Documentation.htm#Zones
  shorewall::managed_file{ zones: }
  # See http://www.shorewall.net/3.0/Documentation.htm#Interfaces
  shorewall::managed_file{ interfaces: }
  # See http://www.shorewall.net/3.0/Documentation.htm#Hosts
  shorewall::managed_file { hosts: }
  # See http://www.shorewall.net/3.0/Documentation.htm#Policy
  shorewall::managed_file { policy: }
  # See http://www.shorewall.net/3.0/Documentation.htm#Rules
  shorewall::managed_file { rules: }
  # See http://www.shorewall.net/3.0/Documentation.htm#Masq
  shorewall::managed_file{ masq: }
  # See http://www.shorewall.net/3.0/Documentation.htm#ProxyArp
  shorewall::managed_file { proxyarp: }
  # See http://www.shorewall.net/3.0/Documentation.htm#NAT
  shorewall::managed_file { nat: }
  # See http://www.shorewall.net/3.0/Documentation.htm#Blacklist
  shorewall::managed_file { blacklist: }
  # See http://www.shorewall.net/3.0/Documentation.htm#rfc1918
  shorewall::managed_file { rfc1918: }
  # See http://www.shorewall.net/3.0/Documentation.htm#Routestopped
  shorewall::managed_file { routestopped: }
  # See http://www.shorewall.net/3.0/Documentation.htm#Variables
  shorewall::managed_file { params: }
  # See http://www.shorewall.net/3.0/traffic_shaping.htm
  shorewall::managed_file { tcdevices: }
  # See http://www.shorewall.net/3.0/traffic_shaping.htm
  shorewall::managed_file { tcrules: }
  # See http://www.shorewall.net/3.0/traffic_shaping.htm
  shorewall::managed_file { tcclasses: }
  # http://www.shorewall.net/manpages/shorewall-providers.html
  shorewall::managed_file { providers: }
}
