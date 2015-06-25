#sets up php5 for apache
define php5::ini (
  $ensure = undef
){
  require php5

  case $ensure {
    undef: { fail('Ensure must be specified') }
    /(?i:absent|clear)/: {
      augeas {"php::ini:clear::${title}":
        context => '/files/etc/php.ini',
        changes => "clear ${title}",
        notify  => Service['apache2-service'],
        require => Package['augeas'],
      }
    }
    default : {
      augeas { "php::ini::set:${title}":
        context => '/files/etc/php.ini',
        changes => "set ${title} ${ensure}",
        notify  => Service['apache2-service'],
        require => Package['augeas'],
      }
    }
  }
}
