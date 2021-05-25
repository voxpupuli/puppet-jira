# @api private
class jira::mysql_connector (
  $version      = $jira::mysql_connector_version,
  $product      = $jira::mysql_connector_product,
  $format       = $jira::mysql_connector_format,
  $installdir   = $jira::mysql_connector_install,
  $download_url = $jira::mysql_connector_url
) {
  assert_private()
  $file = "${product}-${version}.${format}"

  if ! defined(File[$installdir]) {
    file { $installdir:
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
      before => Archive["${installdir}/${file}"],
    }
  }

  if (versioncmp($jira::mysql_connector_version, '8.0.0') == -1) { # version < 8.0.0
    $jarfile = "${product}-${version}-bin.jar"
  } else {
    $jarfile = "${product}-${version}.jar"
  }

  archive { "${installdir}/${file}":
    ensure       => present,
    extract      => true,
    extract_path => $installdir,
    source       => "${download_url}/${file}",
    creates      => "${installdir}/${product}-${version}",
    cleanup      => true,
    proxy_server => $jira::proxy_server,
    proxy_type   => $jira::proxy_type,
  }

  file { "${jira::webappdir}/lib/mysql-connector-java.jar":
    ensure  => link,
    target  => "${installdir}/${product}-${version}/${jarfile}",
    require => Archive["${installdir}/${file}"],
  }
}
