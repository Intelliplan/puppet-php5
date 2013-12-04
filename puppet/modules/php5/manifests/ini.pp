define php5::ini (
  $ensure = undef
){
  require php5
  
  case $::osfamily {
    /(?i:redhat)/: { 
      $augeas_package_name = 'augeas'
      $augtool_path        = ['/usr/local/bin', '/bin', '/usr/bin']
    }
    default: { fail("Unsupported platform: ${::osfamily}") }
  }
  package { $augeas_package_name:
    ensure => 'present'
  }

  case $ensure {
    undef: { fail("Ensure must be specified") }
    /(?i:absent|clear)/: {
      exec { "php::ini::clear::$title":
        command => "augtool clear '/files/etc/php.ini/$title'",
        path    => $augtool_path,
        notify  => Service['apache2-service'],
        require => Package[$augeas_package_name],
      }
    }
    default : {
      exec { "php::ini::set::$title":
        command => "augtool set '/files/etc/php.ini/$title' '$ensure'",
        path    => $augtool_path,
        notify  => Service['apache2-service'],
        require => Package[$augeas_package_name],
      }
    }
  }
}
