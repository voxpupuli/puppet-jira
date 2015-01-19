# Class to install the MySQL Java connector
class jira::mysql_connector (
  $version      = $jira::mysql_connector_version,
  $product      = $jira::mysql_connector_product,
  $format       = $jira::mysql_connector_format,
  $installdir   = $jira::mysql_connector_install,
  $downloadURL  = $jira::mysql_connector_URL,
) {

  require staging

  $file = "${product}-${version}.${format}"

  if ! defined(File[$installdir]) {
    file { $installdir:
      ensure => 'directory',
      owner  => root,
      group  => root,
      before => Staging::File[$file]
    }
  }

  staging::file { $file:
    source  => "${downloadURL}/${file}",
    timeout => 300,
  } ->

  staging::extract { $file:
    target  => $installdir,
    creates => "${installdir}/${product}-${version}",
  } ->

  file { "${jira::webappdir}/lib/mysql-connector-java.jar":
    ensure => link,
    target => "${installdir}/${product}-${version}/${product}-${version}-bin.jar",
  }

}
