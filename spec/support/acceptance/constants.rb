# frozen_string_literal: true

# set some constants to keep it DRY
DEFAULT_VERSION = '8.13.5'
PRODUCT_VERSION_STRING = "atlassian-jira-software-#{DEFAULT_VERSION}"
PRODUCT_VERSION_STRING_CORE = "atlassian-jira-core-#{DEFAULT_VERSION}"

PATH_JAVA_HOME = '/opt/java'
PATH_JIRA_DIR = '/opt/jira'
PATH_INSTALLATION_BASE = "#{PATH_JIRA_DIR}/#{PRODUCT_VERSION_STRING}-standalone"

FILENAME_SETENV_SH = "#{PATH_INSTALLATION_BASE}/bin/setenv.sh"
FILENAME_USER_SH = "#{PATH_INSTALLATION_BASE}/bin/user.sh"
FILENAME_CHECK_JAVA_SH = "#{PATH_INSTALLATION_BASE}/bin/check-java.sh"
FILENAME_SERVER_XML = "#{PATH_INSTALLATION_BASE}/conf/server.xml"
FILENAME_DBCONFIG_XML = '/home/jira/dbconfig.xml'
FILENAME_CLUSTER_PROPS = '/home/jira/cluster.properties'
FILENAME_JIRA_CONFIG_PROPS = '/home/jira/jira-config.properties'
