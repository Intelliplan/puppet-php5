class php5::xml {
  include php5
  package { 'php-xml':
    ensure => 'present',
    notify => Service['apache2-service'],
  }
}
