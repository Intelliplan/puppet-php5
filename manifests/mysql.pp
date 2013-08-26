class php5::mysql {
  include php5
  package { 'php-mysql':
    ensure => present
  }
}