# == Class: confluence::sso
#
# Install confluence SSO via crowd, See README.md for more.
#
class jira::sso(
  $application_name = $::jira::application_name,
  $application_password = $::jira::application_password,
  $application_login_url = $::jira::application_login_url,
  $crowd_server_url = $::jira::crowd_server_url,
  $crowd_base_url = $::jira::crowd_base_url,
  $session_isauthenticated = $::jira::session_isauthenticated,
  $session_tokenkey = $::jira::session_tokenkey,
  $session_validationinterval = $::jira::session_validationinterval,
  $session_lastvalidation = $::jira::session_lastvalidation,
) {

  validate_re($application_login_url,'^https?\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(/\S*)?$')
  validate_re($crowd_server_url,'^https?\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(/\S*)?$')
  validate_re($crowd_base_url,'^https?\://[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,3}(/\S*)?$')

  file { "${jira::webappdir}/atlassian-jira/WEB-INF/classes/crowd.properties":
    ensure  => present,
    content => template('jira/crowd.properties'),
    mode    => '0660',
    owner   => $::jira::user,
    group   => $::jira::group,
    require => Class['jira::install'],
    notify  => Class['jira::service'],
  }
  file { "${jira::webappdir}/atlassian-jira/WEB-INF/classes/seraph-config.xml":
    source  => 'puppet:///modules/jira/seraph-config_withSSO.xml',
    mode    => '0660',
    owner   => $::jira::user,
    group   => $::jira::group,
    require => Class['jira::install'],
    notify  => Class['jira::service'],
  }
}
