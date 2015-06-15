#sets up php5 for apache
define php5::ini (
  $ensure = undef
){
  require php5


  @package {'augeas':
    ensure => installed
  }
  realize Package[['augeas']]


  #case $::osfamily {
  #  /(?i:redhat)/: { 
  #    $augeas_package_name = 'augeas'
  #    $augtool_path        = ['/usr/local/bin', '/bin', '/usr/bin']
  #  }
  #  default: { fail("Unsupported platform: ${::osfamily}") }
  #}
  #package { $augeas_package_name:
  #  ensure => 'present'
  #}

  case $ensure {
    undef: { fail('Ensure must be specified') }
    /(?i:absent|clear)/: {
      augeas {"php::ini:clear::${title}":
        context => '/files/etc/php.ini',
        changes => "clear ${title}",
        notify  => Service['apache2-service'],
        require => Package['augeas'],
      }
      #exec { "php::ini::clear::$title":
      #  command => "augtool clear '/files/etc/php.ini/$title'",
      #  path    => $augtool_path,
      #  notify  => Service['apache2-service'],
      #  require => Package[$augeas_package_name],
      #}
    }
    default : {
      augeas { "php::ini::set:${title}":
        context => '/files/etc/php.ini',
        changes => "set ${title} ${ensure}",
        notify  => Service['apache2-service'],
        require => Package['augeas'],
      }
      #exec { "php::ini::set::$title":
      #  command => "augtool set '/files/etc/php.ini/$title' '$ensure'",
      #  path    => $augtool_path,
      #  notify  => Service['apache2-service'],
      #  require => Package[$augeas_package_name],
      #}
    }
  }
}
