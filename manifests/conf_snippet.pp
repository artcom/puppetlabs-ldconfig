define ldconfig::conf_snippet (
  $ensure   = 'present',
  $content  = '',
  $source   = '',
  $filename = ''
) {

  $realname = $filename ? {
    ''      => $name,
    default => $filename
  } # $realname

  case $ensure {
    present: {
      case $content {
        '': {
          # no content means we grab a file
          $realsource = $source ? {
            ''      => "puppet:///modules/ldconfig/$realname.conf",
            default => $source
          } # $realsource
          file { "$ldconfig::basedir/$realname.conf":
            ensure  => present,
            source  => "$realsource",
            require => Package['ldconfigPackage'],
            notify  => Exec['ldconfig-rebuild'],
          } # file
        } # '':
        default: {
          # use a template to generate the content
          file { "$ldconfig::basedir/$realname.conf":
            ensure  => present,
            content => $content,
            require => Package['ldconfigPackage'],
            notify  => Exec['ldconfig-rebuild'],
          } # file
        } # default:
      } # case $content
    } # present:
    absent: {
      file { "$ldconfig::basedir/$realname.conf":
        ensure => absent,
        notify => Exec['ldconfig-rebuild'],
      } # file
    } # absent:
  } # case $ensure
} # define ldconfig::conf_snippet
