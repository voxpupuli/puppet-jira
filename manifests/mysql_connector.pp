# Class to install the MySQL Java connector
class jira::mysql_connector (
  $version      = $jira::mysql_connector_version,
  $product      = $jira::mysql_connector_product,
  $format       = $jira::mysql_connector_format,
  $installdir   = $jira::mysql_connector_install,
  $download_url = $jira::mysql_connector_url,
  $deploy_module= $jira::deploy_module,
) {

$file = "${product}-${version}.${format}"
if ! defined(File[$installdir]) {
        file { $installdir:
          ensure => 'directory',
          owner  => root,
          group  => root,
        }
 }


->  case $deploy_module {
    'staging': {
      require ::staging

      staging::file { $file:
        source  => "${download_url}/${file}",
        timeout => 300,
      }

      -> staging::extract { $file:
        target  => $installdir,
        creates => "${installdir}/${product}-${version}",
      }
      -> file { "${jira::webappdir}/lib/mysql-connector-java.jar":
        ensure => link,
        target => "${installdir}/${product}-${version}/${product}-${version}-bin.jar",
      }
    }
    'archive': {
      archive { "/tmp/${file}":
        ensure          => present,
        extract         => true,
        extract_command => 'tar xfz %s --strip-components=1',
        extract_path    => $installdir,
        source          => "${download_url}/${file}",
        creates         => "${installdir}/${product}-${version}-bin.jar",
        cleanup         => true,
        proxy_server    => $jira::proxy_server,
        proxy_type      => $jira::proxy_type,
        before          => File[$jira::homedir],
        require         => [
          File[$jira::installdir],
          File[$jira::webappdir],
          User[$jira::user],
        ],
      }
      -> file { "${jira::webappdir}/lib/mysql-connector-java.jar":
        ensure => link,
        target => "${installdir}/${product}-${version}-bin.jar",
      }
    }
    default: {
      fail('deploy_module parameter must equal "archive" or staging""')
    }
  }




}
