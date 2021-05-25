# @api private
class jira::sso (
  $application_name                                                 = $jira::application_name,
  $application_password                                             = $jira::application_password,
  Variant[Stdlib::HTTPUrl, Stdlib::HTTPSUrl] $application_login_url = $jira::application_login_url,
  Variant[Stdlib::HTTPUrl, Stdlib::HTTPSUrl] $crowd_server_url      = $jira::crowd_server_url,
  Variant[Stdlib::HTTPUrl, Stdlib::HTTPSUrl] $crowd_base_url        = $jira::crowd_base_url,
  $session_isauthenticated                                          = $jira::session_isauthenticated,
  $session_tokenkey                                                 = $jira::session_tokenkey,
  $session_validationinterval                                       = $jira::session_validationinterval,
  $session_lastvalidation                                           = $jira::session_lastvalidation,
) {
  assert_private()
  file { "${jira::webappdir}/atlassian-jira/WEB-INF/classes/crowd.properties":
    ensure  => file,
    content => epp('jira/crowd.properties.epp'),
    mode    => '0660',
    owner   => $jira::user,
    group   => $jira::group,
    require => Class['jira::install'],
    notify  => Class['jira::service'],
  }
  file { "${jira::webappdir}/atlassian-jira/WEB-INF/classes/seraph-config.xml":
    source  => 'puppet:///modules/jira/seraph-config_withSSO.xml',
    mode    => '0660',
    owner   => $jira::user,
    group   => $jira::group,
    require => Class['jira::install'],
    notify  => Class['jira::service'],
  }
}
