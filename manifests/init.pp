class php5 {
  @package { ['php', 'php-cli']:
    ensure => present
  }

  realize Package[['php'],['php-cli']]
}
