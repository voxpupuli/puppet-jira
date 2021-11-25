# set some constants to keep it DRY
DEFAULT_VERSION = '8.13.5'.freeze
PRODUCT_VERSION_STRING = "atlassian-jira-software-#{DEFAULT_VERSION}".freeze
PRODUCT_VERSION_STRING_CORE = "atlassian-jira-core-#{DEFAULT_VERSION}".freeze

PATH_JAVA_HOME = '/opt/java'.freeze
PATH_JIRA_DIR = '/opt/jira'.freeze
PATH_INSTALLATION_BASE = "#{PATH_JIRA_DIR}/#{PRODUCT_VERSION_STRING}-standalone".freeze

FILENAME_SETENV_SH = "#{PATH_INSTALLATION_BASE}/bin/setenv.sh".freeze
FILENAME_USER_SH = "#{PATH_INSTALLATION_BASE}/bin/user.sh".freeze
FILENAME_CHECK_JAVA_SH = "#{PATH_INSTALLATION_BASE}/bin/check-java.sh".freeze
FILENAME_SERVER_XML = "#{PATH_INSTALLATION_BASE}/conf/server.xml".freeze
FILENAME_DBCONFIG_XML = '/home/jira/dbconfig.xml'.freeze
FILENAME_CLUSTER_PROPS = '/home/jira/cluster.properties'.freeze
FILENAME_JIRA_CONFIG_PROPS = '/home/jira/jira-config.properties'.freeze
