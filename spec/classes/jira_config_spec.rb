# frozen_string_literal: true

require 'spec_helper'

require 'rspec-puppet/cache'

module RSpec::Puppet
  module Support
    def self.clear_cache
      @@cache = RSpec::Puppet::Cache.new # rubocop:disable Style/ClassVars
    end
  end
end

# set some constants to keep it DRY
REGEXP_DISABLE_NOTIFICATIONS = %r{#DISABLE_NOTIFICATIONS=}.freeze
REGEXP_POSTGRESQL_URL = %r{jdbc:postgresql://localhost:5432/jira}.freeze
REGEXP_PUBLIC_SCHEMA = %r{<schema-name>public</schema-name>}.freeze
HTTP11 = 'HTTP/1.1'
PLUGIN_SOURCE_URL = 'https://www.example.com/fine-jira-plugin.tgz'
describe 'jira' do
  describe 'jira::config' do
    let(:params) do
      {
        javahome: '/opt/java',
        version: DEFAULT_VERSION,
      }
    end

    context 'supported operating systems' do
      on_supported_os.each do |os, facts|
        context "on #{os}" do
          let(:facts) do
            facts
          end

          context 'with default params' do
            it { is_expected.to compile.with_all_deps }

            it do
              is_expected.to contain_file(FILENAME_SETENV_SH).
                with_content(REGEXP_DISABLE_NOTIFICATIONS)
            end

            it { is_expected.to contain_file(FILENAME_USER_SH) }
            it { is_expected.to contain_file(FILENAME_SERVER_XML) }

            # Also ensure that we actually omit elements by default

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(REGEXP_POSTGRESQL_URL).
                with_content(REGEXP_PUBLIC_SCHEMA).
                with_content(%r{<pool-max-size>20}).
                with_content(%r{<pool-min-size>20}).
                with_content(%r{<pool-max-wait>30000}).
                with_content(%r{<pool-max-idle>20}).
                with_content(%r{<pool-remove-abandoned>true}).
                with_content(%r{<pool-remove-abandoned-timeout>300}).
                with_content(%r{<min-evictable-idle-time-millis>60000}).
                with_content(%r{<time-between-eviction-runs-millis>300000}).
                with_content(%r{<pool-test-while-idle>true}).
                with_content(%r{<pool-test-on-borrow>false}).
                with_content(%r{<validation-query>select version\(\);}).
                with_content(%r{<connection-properties>tcpKeepAlive=true;socketTimeout=240}).
                without_content(%r{<validation-query-timeout>})
            end

            it { is_expected.not_to contain_file(FILENAME_CLUSTER_PROPS) }
            it { is_expected.not_to contain_file(FILENAME_CHECK_JAVA_SH) }

            # Test web.xml management with default values
            it do
              is_expected.to contain_augeas('jira-web.xml-session-timeout').
                with_changes(['set session-config/session-timeout/#text 300'])
            end

            it 'removes HTTPS redirect when disabled' do
              is_expected.to contain_augeas('jira-web.xml-https-redirect').
                with_changes(['rm security-constraint[user-data-constraint/transport-guarantee/#text="CONFIDENTIAL"]']).
                with_onlyif('match security-constraint/user-data-constraint/transport-guarantee[#text="CONFIDENTIAL"] size > 0')
            end
          end

          context 'with enable_https_redirect' do
            let(:params) do
              {
                javahome: '/opt/java',
                version: DEFAULT_VERSION,
                enable_https_redirect: true,
              }
            end

            it { is_expected.to compile.with_all_deps }

            it 'configures HTTPS redirect in web.xml' do
              is_expected.to contain_augeas('jira-web.xml-https-redirect').
                with_onlyif('match security-constraint/user-data-constraint/transport-guarantee[#text="CONFIDENTIAL"] size == 0').
                with_changes([
                               'set security-constraint[last()+1]/web-resource-collection/web-resource-name/#text "all-except-attachments"',
                               'set security-constraint[last()]/web-resource-collection/url-pattern[1]/#text "*.jsp"',
                               'set security-constraint[last()]/web-resource-collection/url-pattern[2]/#text "*.jspa"',
                               'set security-constraint[last()]/web-resource-collection/url-pattern[3]/#text "/browse/*"',
                               'set security-constraint[last()]/web-resource-collection/url-pattern[4]/#text "/issues/*"',
                               'set security-constraint[last()]/user-data-constraint/transport-guarantee/#text "CONFIDENTIAL"',
                             ])
            end

            it 'does not remove HTTPS redirect' do
              is_expected.to contain_augeas('jira-web.xml-https-redirect').
                with_onlyif('match security-constraint/user-data-constraint/transport-guarantee[#text="CONFIDENTIAL"] size == 0')
            end
          end

          context 'with custom session_timeout' do
            let(:params) do
              {
                javahome: '/opt/java',
                version: DEFAULT_VERSION,
                session_timeout: 480,
              }
            end

            it { is_expected.to compile.with_all_deps }

            it 'sets custom session timeout' do
              is_expected.to contain_augeas('jira-web.xml-session-timeout').
                with_changes(['set session-config/session-timeout/#text 480'])
            end

            it 'removes HTTPS redirect when disabled' do
              is_expected.to contain_augeas('jira-web.xml-https-redirect').
                with_changes(['rm security-constraint[user-data-constraint/transport-guarantee/#text="CONFIDENTIAL"]']).
                with_onlyif('match security-constraint/user-data-constraint/transport-guarantee[#text="CONFIDENTIAL"] size > 0')
            end
          end

          context 'with both enable_https_redirect and custom session_timeout' do
            let(:params) do
              {
                javahome: '/opt/java',
                version: DEFAULT_VERSION,
                enable_https_redirect: true,
                session_timeout: 600,
              }
            end

            it { is_expected.to compile.with_all_deps }

            it 'sets custom session timeout' do
              is_expected.to contain_augeas('jira-web.xml-session-timeout').
                with_changes(['set session-config/session-timeout/#text 600'])
            end

            it 'configures HTTPS redirect' do
              is_expected.to contain_augeas('jira-web.xml-https-redirect')
            end
          end

          context 'web.xml augeas resources' do
            let(:params) do
              {
                javahome: '/opt/java',
                version: DEFAULT_VERSION,
              }
            end

            it 'manages session timeout with augeas' do
              is_expected.to contain_augeas('jira-web.xml-session-timeout').
                with_incl("#{PATH_INSTALLATION_BASE}/atlassian-jira/WEB-INF/web.xml").
                with_lens('Xml.lns').
                with_context("/files#{PATH_INSTALLATION_BASE}/atlassian-jira/WEB-INF/web.xml/web-app")
            end

            it 'manages https redirect with augeas' do
              is_expected.to contain_augeas('jira-web.xml-https-redirect').
                with_incl("#{PATH_INSTALLATION_BASE}/atlassian-jira/WEB-INF/web.xml").
                with_lens('Xml.lns').
                with_onlyif('match security-constraint/user-data-constraint/transport-guarantee[#text="CONFIDENTIAL"] size > 0')
            end
          end

          context 'with web.xml and different JIRA versions' do
            let(:params) do
              {
                javahome: '/opt/java',
                version: '9.4.0',
                enable_https_redirect: true,
                session_timeout: 360,
              }
            end

            it { is_expected.to compile.with_all_deps }

            it 'manages custom session timeout' do
              is_expected.to contain_augeas('jira-web.xml-session-timeout').
                with_changes(['set session-config/session-timeout/#text 360'])
            end

            it 'enables https redirect' do
              is_expected.to contain_augeas('jira-web.xml-https-redirect').
                with_onlyif('match security-constraint/user-data-constraint/transport-guarantee[#text="CONFIDENTIAL"] size == 0').
                with_changes([
                               'set security-constraint[last()+1]/web-resource-collection/web-resource-name/#text "all-except-attachments"',
                               'set security-constraint[last()]/web-resource-collection/url-pattern[1]/#text "*.jsp"',
                               'set security-constraint[last()]/web-resource-collection/url-pattern[2]/#text "*.jspa"',
                               'set security-constraint[last()]/web-resource-collection/url-pattern[3]/#text "/browse/*"',
                               'set security-constraint[last()]/web-resource-collection/url-pattern[4]/#text "/issues/*"',
                               'set security-constraint[last()]/user-data-constraint/transport-guarantee/#text "CONFIDENTIAL"',
                             ])
            end
          end

          context 'with web.xml and OpenJDK 11' do
            let(:params) do
              {
                javahome: '/usr/lib/jvm/jre-11-openjdk',
                java_package: 'java-11-openjdk-headless',
                jvm_type: 'openjdk-11',
                enable_https_redirect: true,
                session_timeout: 420,
              }
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_package('java-11-openjdk-headless') }

            it 'manages custom session timeout' do
              is_expected.to contain_augeas('jira-web.xml-session-timeout').
                with_changes(['set session-config/session-timeout/#text 420'])
            end

            it 'enables https redirect' do
              is_expected.to contain_augeas('jira-web.xml-https-redirect').
                with_onlyif('match security-constraint/user-data-constraint/transport-guarantee[#text="CONFIDENTIAL"] size == 0').
                with_changes([
                               'set security-constraint[last()+1]/web-resource-collection/web-resource-name/#text "all-except-attachments"',
                               'set security-constraint[last()]/web-resource-collection/url-pattern[1]/#text "*.jsp"',
                               'set security-constraint[last()]/web-resource-collection/url-pattern[2]/#text "*.jspa"',
                               'set security-constraint[last()]/web-resource-collection/url-pattern[3]/#text "/browse/*"',
                               'set security-constraint[last()]/web-resource-collection/url-pattern[4]/#text "/issues/*"',
                               'set security-constraint[last()]/user-data-constraint/transport-guarantee/#text "CONFIDENTIAL"',
                             ])
            end
          end

          context 'with minimum session timeout' do
            let(:params) do
              {
                javahome: '/opt/java',
                version: DEFAULT_VERSION,
                session_timeout: 1,
              }
            end

            it { is_expected.to compile.with_all_deps }

            it 'allows minimum valid session timeout' do
              is_expected.to contain_augeas('jira-web.xml-session-timeout').
                with_changes(['set session-config/session-timeout/#text 1'])
            end
          end

          context 'with large session timeout' do
            let(:params) do
              {
                javahome: '/opt/java',
                version: DEFAULT_VERSION,
                session_timeout: 1440,
              }
            end

            it { is_expected.to compile.with_all_deps }

            it 'allows large session timeout (24 hours)' do
              is_expected.to contain_augeas('jira-web.xml-session-timeout').
                with_changes(['set session-config/session-timeout/#text 1440'])
            end
          end

          context 'with java install' do
            let(:params) do
              {
                javahome: '/usr/lib/jvm/jre-11-openjdk',
                java_package: 'java-11-openjdk-headless',
              }
            end

            it { is_expected.to compile.with_all_deps }
            it { is_expected.to contain_package('java-11-openjdk-headless') }
          end

          context 'with version < 1.3.0' do
            let(:params) do
              {
                javahome: '/opt/java',
                version: DEFAULT_VERSION,
                dbpassword: 'test',
              }
            end

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{<password>test</password>})
            end

            context 'change_dbpassword=true' do
              let(:params) do
                {
                  javahome: '/opt/java',
                  version: DEFAULT_VERSION,
                  dbpassword: 'test',
                  change_dbpassword: true,
                }
              end

              it do
                is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                  with_content(%r{<password>test</password>})
              end
            end
          end

          context 'with version >= 10.3.0' do
            context 'no atl_secured password' do
              let(:params) do
                {
                  javahome: '/usr/lib/jvm/jre-11-openjdk',
                  version: '10.3.3',
                  dbpassword: 'test',
                }
              end

              before do
                RSpec::Puppet::Support.clear_cache
                allow(PuppetX::Jira::Jira).to receive(:db_password_atl_secured).and_return(false)
              end

              after do
                RSpec::Puppet::Support.clear_cache
              end

              it do
                is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                  with_content(%r{<password>test</password>})
              end
            end

            context 'atl_secured password' do
              let(:params) do
                {
                  javahome: '/usr/lib/jvm/jre-11-openjdk',
                  version: '10.3.3',
                  dbpassword: 'test',
                }
              end

              before do
                RSpec::Puppet::Support.clear_cache
                allow(PuppetX::Jira::Jira).to receive(:db_password_atl_secured).and_return(true)
              end

              after do
                RSpec::Puppet::Support.clear_cache
              end

              it do
                is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                  with_content(%r{<password>{ATL_SECURED}</password>})
              end
            end

            context 'change_dbpassword=true' do
              context 'no atl_secured password' do
                let(:params) do
                  {
                    javahome: '/usr/lib/jvm/jre-11-openjdk',
                    version: '10.3.3',
                    dbpassword: 'test',
                    change_dbpassword: true,
                  }
                end

                before do
                  RSpec::Puppet::Support.clear_cache
                  allow(PuppetX::Jira::Jira).to receive(:db_password_atl_secured).and_return(false)
                end

                after do
                  RSpec::Puppet::Support.clear_cache
                end

                it do
                  is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                    with_content(%r{<password>test</password>})
                end
              end

              context 'atl_secured password' do
                let(:params) do
                  {
                    javahome: '/usr/lib/jvm/jre-11-openjdk',
                    version: '10.3.3',
                    dbpassword: 'test',
                    change_dbpassword: true,
                  }
                end

                before do
                  RSpec::Puppet::Support.clear_cache
                  allow(PuppetX::Jira::Jira).to receive(:db_password_atl_secured).and_return(true)
                end

                after do
                  RSpec::Puppet::Support.clear_cache
                end

                it do
                  is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                    with_content(%r{<password>test</password>})
                end
              end
            end
          end

          context 'with unsupported db' do
            let(:params) do
              super().merge(
                db: 'imaginarydb'
              )
            end

            it { is_expected.not_to compile }
          end

          context 'with default db and custom database settings' do
            let(:params) do
              super().merge(
                connection_settings: 'TEST-SETTING;',
                pool_max_size: 200,
                pool_min_size: 10,
                validation_query: 'SELECT myfunction();'
              )
            end

            it { is_expected.to contain_file(FILENAME_SETENV_SH) }
            it { is_expected.to contain_file(FILENAME_USER_SH) }
            it { is_expected.to contain_file(FILENAME_SERVER_XML) }

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{<database-type>postgres72</database-type>}).
                with_content(%r{<url>jdbc:postgresql://localhost:5432/jira</url>}).
                with_content(%r{<driver-class>org.postgresql.Driver</driver-class>}).
                with_content(%r{<connection-properties>TEST-SETTING;</connection-properties>}).
                with_content(%r{<pool-max-size>200</pool-max-size>}).
                with_content(%r{<pool-min-size>10</pool-min-size>}).
                with_content(%r{<validation-query>SELECT myfunction\(\);</validation-query>})
            end
          end

          context 'with default db and custom dbport' do
            let(:params) do
              super().merge(
                dbport: '666'
              )
            end

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{<url>jdbc:postgresql://localhost:666/jira</url>})
            end
          end

          context 'with default db and custom dbriver' do
            let(:params) do
              super().merge(
                dbdriver: 'mydriver'
              )
            end

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{<url>jdbc:postgresql://localhost:5432/jira</url>}).
                with_content(%r{<driver-class>mydriver</driver-class>})
            end
          end

          context 'with default db and custom dbtype' do
            let(:params) do
              super().merge(
                dbtype: 'mydbtype'
              )
            end

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{<database-type>mydbtype</database-type>}).
                with_content(%r{<url>jdbc:postgresql://localhost:5432/jira</url>})
            end
          end

          context 'with mysql db and default database settings' do
            let(:params) do
              super().merge(
                db: 'mysql'
              )
            end

            it { is_expected.to compile.with_all_deps }

            it { is_expected.to contain_file(FILENAME_SETENV_SH) }
            it { is_expected.to contain_file(FILENAME_USER_SH) }
            it { is_expected.to contain_file(FILENAME_SERVER_XML) }

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{<database-type>mysql</database-type>}).
                with_content(%r{<url>jdbc:mysql://localhost:3306/jira\?useUnicode=true&amp;characterEncoding=UTF8&amp;sessionVariables=default_storage_engine=InnoDB</url>}).
                with_content(%r{<driver-class>com.mysql.jdbc.Driver</driver-class>}).
                with_content(%r{<validation-query>select 1</validation-query>}).
                with_content(%r{<validation-query-timeout>3</validation-query-timeout>}).
                without_content(%r{<connection-properties>})
            end
          end

          context 'with mysql db and custom url' do
            let(:params) do
              super().merge(
                db: 'mysql',
                dburl: 'jdbc:mysql://localhost:9999/myjira'
              )
            end

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{<url>jdbc:mysql://localhost:9999/myjira</url>})
            end
          end

          context 'with mysql db and custom url with dbname and dbserver' do
            let(:params) do
              super().merge(
                db: 'mysql',
                dburl: 'jdbc:mysql://localhost:666/jiradb',
                dbname: 'mydatabase',
                dbserver: 'myhost'
              )
            end

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{<url>jdbc:mysql://localhost:666/jiradb</url>})
            end
          end

          context 'with sqlserver db and default database settings' do
            let(:params) do
              super().merge(
                db: 'sqlserver'
              )
            end

            it { is_expected.to compile.with_all_deps }

            it { is_expected.to contain_file(FILENAME_SETENV_SH) }
            it { is_expected.to contain_file(FILENAME_USER_SH) }
            it { is_expected.to contain_file(FILENAME_SERVER_XML) }

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{<database-type>mssql</database-type>}).
                with_content(%r{<url>jdbc:jtds:sqlserver://localhost:1433/jira</url>}).
                with_content(%r{<driver-class>com.microsoft.sqlserver.jdbc.SQLServerDriver</driver-class>}).
                with_content(%r{<validation-query>select 1</validation-query>}).
                without_content(%r{<validation-query-timeout>}).
                without_content(%r{<connection-properties>})
            end
          end

          context 'with sqlserver db and custom url' do
            let(:params) do
              super().merge(
                db: 'sqlserver',
                dburl: 'jdbc:sqlserver://localhost:9999/myjira'
              )
            end

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{<url>jdbc:sqlserver://localhost:9999/myjira</url>})
            end
          end

          context 'with sqlserver db and custom url with dbname and dbserver' do
            let(:params) do
              super().merge(
                db: 'sqlserver',
                dburl: 'jdbc:jtds:sqlserver://localhost:666/jiradb',
                dbname: 'mydatabase',
                dbserver: 'myhost'
              )
            end

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{<url>jdbc:jtds:sqlserver://localhost:666/jiradb</url>})
            end
          end

          context 'with oracle db and default database settings' do
            let(:params) do
              super().merge(
                db: 'oracle'
              )
            end

            it { is_expected.to compile.with_all_deps }

            it { is_expected.to contain_file(FILENAME_SETENV_SH) }
            it { is_expected.to contain_file(FILENAME_USER_SH) }
            it { is_expected.to contain_file(FILENAME_SERVER_XML) }

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{<database-type>oracle10g</database-type>}).
                with_content(%r{<url>jdbc:oracle:thin:@localhost:1521:jira</url>}).
                with_content(%r{<driver-class>oracle.jdbc.OracleDriver</driver-class>}).
                with_content(%r{<validation-query>select 1 from dual</validation-query>}).
                without_content(%r{<validation-query-timeout>}).
                without_content(%r{<connection-properties>})
            end
          end

          context 'with oracle db and custom url' do
            let(:params) do
              super().merge(
                db: 'oracle',
                dburl: 'jdbc:oracle:thin:@localhost:9999/mydatabase'
              )
            end

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{<url>jdbc:oracle:thin:@localhost:9999/mydatabase</url>})
            end
          end

          context 'with oracle db and custom url with dbname and dbserver' do
            let(:params) do
              super().merge(
                db: 'oracle',
                dburl: 'jdbc:oracle:thin:@localhost:666/mydatabase',
                dbname: 'mydatabase',
                dbserver: 'myhost'
              )
            end

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{<url>jdbc:oracle:thin:@localhost:666/mydatabase</url>})
            end
          end

          context 'with oracle db and not use oracle sid' do
            let(:params) do
              super().merge(
                db: 'oracle',
                dbserver: 'oracleserver',
                oracle_use_sid: false,
                dbname: 'mydatabase'
              )
            end

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{jdbc:oracle:thin:@oracleserver:1521/mydatabase})
            end
          end

          context 'with h2 db and default database settings' do
            let(:params) do
              super().merge(
                db: 'h2'
              )
            end

            it { is_expected.to compile.with_all_deps }

            it { is_expected.to contain_file(FILENAME_SETENV_SH) }
            it { is_expected.to contain_file(FILENAME_USER_SH) }
            it { is_expected.to contain_file(FILENAME_SERVER_XML) }

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{<database-type>h2</database-type>}).
                with_content(%r{<url>jdbc:h2:file://home/jira/database/jira</url>}).
                with_content(%r{<driver-class>org.h2.Driver</driver-class>}).
                without_content(%r{<validation-query>}).
                without_content(%r{<validation-query-timeout>}).
                without_content(%r{<connection-properties>})
            end
          end

          context 'with h2 db and custom url' do
            let(:params) do
              super().merge(
                db: 'h2',
                dburl: 'jdbc:h2:file://home/jira/database/myjira'
              )
            end

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{<url>jdbc:h2:file://home/jira/database/myjira</url>})
            end
          end

          context 'with h2 db and custom url with dbname and dbserver' do
            let(:params) do
              super().merge(
                db: 'h2',
                dburl: 'jdbc:h2:file://var/opt/jira/database/jiradb',
                dbname: 'mydatabase',
                dbserver: 'myhost'
              )
            end

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{<url>jdbc:h2:file://var/opt/jira/database/jiradb</url>})
            end
          end

          context 'oracle custom dburl' do
            let(:params) do
              super().merge(
                db: 'oracle',
                dburl: 'jdbc:oracle:thin:@localhost:1521/mydatabase'
              )
            end

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{jdbc:oracle:thin:@localhost:1521/mydatabase})
            end
          end

          context 'postgres params' do
            let(:params) do
              super().merge(
                db: 'postgresql',
                dbport: 4711,
                dbserver: 'TheSQLServer',
                dbname: 'TheJiraDB',
                dbuser: 'TheDBUser',
                dbpassword: 'TheDBPassword'
              )
            end

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{jdbc:postgresql://TheSQLServer:4711/TheJiraDB}).
                with_content(REGEXP_PUBLIC_SCHEMA).
                with_content(%r{<username>TheDBUser</username>}).
                with_content(%r{<password>TheDBPassword</password>})
            end
          end

          context 'JNDI DS usage' do
            let(:params) do
              super().merge(
                use_jndi_ds: true,
                jndi_ds_name: 'TestJndiDSName',
                db: 'postgresql',
                dbport: 4711,
                dbserver: 'TheSQLServer',
                dbname: 'TheJiraDB',
                dbuser: 'TheDBUser',
                dbpassword: 'TheDBPassword'
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                with_content(%r{Resource name="jdbc/TestJndiDSName"}).
                with_content(%r{driverClassName="org.postgresql.Driver"}).
                with_content(%r{url="jdbc:postgresql://TheSQLServer:4711/TheJiraDB"}).
                with_content(%r{username="TheDBUser"}).
                with_content(%r{password="TheDBPassword"}).
                with_content(%r{maxTotal="20"}).
                with_content(%r{maxIdle="20"}).
                with_content(%r{validationQuery="select 1"})
            end

            it do
              is_expected.not_to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{jdbc:postgresql://TheSQLServer:4711/TheJiraDB}).
                with_content(%r{<pool-max-size>20</pool-max-size>}).
                with_content(%r{<pool-min-size>20</pool-min-size>}).
                with_content(%r{<validation-query>select version\(\);</validation-query>})
            end

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{<name>defaultDS</name>}).
                with_content(%r{<delegator-name>default</delegator-name>}).
                with_content(%r{<database-type>postgres72</database-type>}).
                with_content(REGEXP_PUBLIC_SCHEMA).
                with_content(%r{<jndi-datasource>\s*<jndi-name>java:comp/env/jdbc/TestJndiDSName</jndi-name>\s*</jndi-datasource>})
            end
          end

          context 'Non JNDI DS usage' do
            let(:params) do
              super().merge(
                db: 'postgresql',
                dbport: 4711,
                dbserver: 'TheSQLServer',
                dbname: 'TheJiraDB',
                dbuser: 'TheDBUser',
                dbpassword: 'TheDBPassword'
              )
            end

            it do
              is_expected.not_to contain_file(FILENAME_SERVER_XML).
                with_content(%r{Resource name="jdbc/TestJndiDSName"}).
                with_content(%r{driverClassName="org.postgresql.Driver"}).
                with_content(%r{url="jdbc:postgresql://TheSQLServer:4711/TheJiraDB"}).
                with_content(%r{username="TheDBUser"}).
                with_content(%r{password="TheDBPassword"}).
                with_content(%r{maxTotal="20"}).
                with_content(%r{maxIdle="20"}).
                with_content(%r{validationQuery="select 1"})
            end

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{jdbc:postgresql://TheSQLServer:4711/TheJiraDB}).
                with_content(%r{<pool-max-size>20</pool-max-size>}).
                with_content(%r{<pool-min-size>20</pool-min-size>}).
                with_content(%r{<validation-query>select version\(\);</validation-query>})
            end

            it do
              is_expected.not_to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{<name>defaultDS</name>}).
                with_content(%r{<delegator-name>default</delegator-name>}).
                with_content(%r{<database-type>postgres72</database-type>}).
                with_content(REGEXP_PUBLIC_SCHEMA).
                with_content(%r{<jndi-datasource>\s*<jndi-name>java:comp/env/jdbc/TestJndiDSName</jndi-name>\s*</jndi-datasource>})
            end
          end

          context 'sqlserver params' do
            let(:params) do
              super().merge(
                db: 'sqlserver',
                dbport: '1433',
                dbschema: 'public'
              )
            end

            it { is_expected.to contain_file(FILENAME_SETENV_SH) }
            it { is_expected.to contain_file(FILENAME_USER_SH) }
            it { is_expected.to contain_file(FILENAME_SERVER_XML) }

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(REGEXP_PUBLIC_SCHEMA)
            end
          end

          context 'customise tomcat connector' do
            let(:params) do
              super().merge(
                tomcat_port: 9229
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                with_content(%r{<Connector port="9229"\s+relaxedPathChars=}m)
            end
          end

          context 'server.xml listeners' do
            context 'version greater than 8' do
              let(:params) do
                super().merge(
                  version: '8.1.0'
                )
              end

              it do
                is_expected.to contain_file('/opt/jira/atlassian-jira-software-8.1.0-standalone/conf/server.xml').
                  with_content(%r{<Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener"})
              end
            end
          end

          context 'customise tomcat connector with a binding address' do
            let(:params) do
              super().merge(
                tomcat_port: 9229,
                tomcat_address: '127.0.0.1'
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                with_content(%r{<Connector port="9229"\s+address="127\.0\.0\.1"\s+relaxedPathChars=}m)
            end
          end

          context 'tomcat context path' do
            let(:params) do
              super().merge(
                contextpath: '/jira'
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                with_content(%r{path="/jira"})
            end
          end

          context 'tomcat port' do
            let(:params) do
              super().merge(
                tomcat_port: 8888
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                with_content(%r{port="8888"})
            end
          end

          context 'tomcat acceptCount' do
            let(:params) do
              super().merge(
                tomcat_accept_count: 200
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                with_content(%r{acceptCount="200"})
            end
          end

          context 'tomcat MaxHttpHeaderSize' do
            let(:params) do
              super().merge(
                tomcat_max_http_header_size: 4096
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                with_content(%r{maxHttpHeaderSize="4096"})
            end
          end

          context 'tomcat MinSpareThreads' do
            let(:params) do
              super().merge(
                tomcat_min_spare_threads: 50
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                with_content(%r{minSpareThreads="50"})
            end
          end

          context 'tomcat ConnectionTimeout' do
            let(:params) do
              super().merge(
                tomcat_connection_timeout: 25_000
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                with_content(%r{connectionTimeout="25000"})
            end
          end

          context 'tomcat EnableLookups' do
            let(:params) do
              super().merge(
                tomcat_enable_lookups: true
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                with_content(%r{enableLookups="true"})
            end
          end

          context 'tomcat Protocol' do
            let(:params) do
              super().merge(
                tomcat_protocol: HTTP11
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                with_content(%r{protocol="HTTP/1.1"})
            end
          end

          context 'tomcat UseBodyEncodingForURI' do
            let(:params) do
              super().merge(
                tomcat_use_body_encoding_for_uri: false
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                with_content(%r{useBodyEncodingForURI="false"})
            end
          end

          context 'tomcat DisableUploadTimeout' do
            let(:params) do
              super().merge(
                tomcat_disable_upload_timeout: false
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                with_content(%r{disableUploadTimeout="false"})
            end
          end

          context 'tomcat maxThreads' do
            let(:params) do
              super().merge(
                tomcat_max_threads: 300
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                with_content(%r{maxThreads="300"})
            end
          end

          context 'tomcat proxy path' do
            let(:params) do
              super().merge(
                proxy: {
                  'scheme' => 'https',
                  'proxyName' => 'www.example.com',
                  'proxyPort' => '9999'
                }
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                without_content(%r{scheme="http"}).
                with_content(%r{proxyName = 'www\.example\.com'}).
                with_content(%r{scheme = 'https'}).
                with_content(%r{proxyPort = '9999'})
            end
          end

          context 'tomcat native ssl default params' do
            let(:params) do
              super().merge(
                tomcat_native_ssl: true
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                with_content(%r{scheme="http"}).
                with_content(%r{scheme="https"}).
                without_content(%r{proxyName = 'www\.example\.com'}).
                without_content(%r{scheme = 'https'}).
                without_content(%r{proxyPort = '9999'}).
                with_content(%r{redirectPort="8443"}).
                with_content(%r{port="8443"}).
                with_content(%r{keyAlias="jira"}).
                with_content(%r{keystoreFile="/home/jira/jira.jks"}).
                with_content(%r{keystorePass="changeit"}).
                with_content(%r{keystoreType="JKS"}).
                with_content(%r{port="8443".*acceptCount="100"}m).
                with_content(%r{port="8443".*maxThreads="150"}m)
            end
          end

          context 'tomcat native ssl default params with proxy path' do
            let(:params) do
              super().merge(
                proxy: {
                  'scheme' => 'https',
                  'proxyName' => 'www.example.com',
                  'proxyPort' => '9999'
                },
                tomcat_native_ssl: true
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                without_content(%r{scheme="http"}).
                with_content(%r{proxyName = 'www\.example\.com'}).
                with_content(%r{scheme = 'https'}).
                with_content(%r{proxyPort = '9999'})
            end
          end

          context 'ajp proxy' do
            context 'with valid config including protocol AJP/1.3' do
              let(:params) do
                super().merge(
                  ajp: {
                    'port' => '8009',
                    'protocol' => 'AJP/1.3'
                  }
                )
              end

              it do
                is_expected.to contain_file(FILENAME_SERVER_XML).
                  with_content(%r{<Connector enableLookups="false" URIEncoding="UTF-8"\s+port = "8009"\s+protocol = "AJP/1.3"\s+/>})
              end
            end

            context 'with valid config including protocol org.apache.coyote.ajp.AjpNioProtocol' do
              let(:params) do
                super().merge(
                  ajp: {
                    'port' => '8009',
                    'protocol' => 'org.apache.coyote.ajp.AjpNioProtocol'
                  }
                )
              end

              it do
                is_expected.to contain_file(FILENAME_SERVER_XML).
                  with_content(%r{<Connector enableLookups="false" URIEncoding="UTF-8"\s+port = "8009"\s+protocol = "org.apache.coyote.ajp.AjpNioProtocol"\s+/>})
              end
            end
          end

          context 'tomcat additional connectors, without default' do
            let(:params) do
              super().merge(
                tomcat_default_connector: false,
                tomcat_additional_connectors: {
                  8081 => {
                    'URIEncoding' => 'UTF-8',
                    'connectionTimeout' => '20000',
                    'protocol' => HTTP11,
                    'proxyName' => 'foo.example.com',
                    'proxyPort' => '8123',
                    'secure' => true,
                    'scheme' => 'https'
                  },
                  8082 => {
                    'URIEncoding' => 'UTF-8',
                    'connectionTimeout' => '20000',
                    'protocol' => HTTP11,
                    'proxyName' => 'bar.example.com',
                    'proxyPort' => '8124',
                    'scheme' => 'http'
                  }
                }
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                without_content(%r{<Connector port="8080"}).
                with_content(%r{<Connector port="8081"}).
                with_content(%r{connectionTimeout="20000"}).
                with_content(%r{protocol="HTTP/1\.1"}).
                with_content(%r{proxyName="foo\.example\.com"}).
                with_content(%r{proxyPort="8123"}).
                with_content(%r{scheme="https"}).
                with_content(%r{secure="true"}).
                with_content(%r{URIEncoding="UTF-8"}).
                with_content(%r{<Connector port="8082"}).
                with_content(%r{connectionTimeout="20000"}).
                with_content(%r{protocol="HTTP/1\.1"}).
                with_content(%r{proxyName="bar\.example\.com"}).
                with_content(%r{proxyPort="8124"}).
                with_content(%r{scheme="http"}).
                with_content(%r{URIEncoding="UTF-8"})
            end
          end

          context 'tomcat access log format' do
            let(:params) do
              super().merge(
                tomcat_accesslog_format: '%a %{jira.request.id}r %{jira.request.username}r %t %I'
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                with_content(%r{pattern="%a %{jira.request.id}r %{jira.request.username}r %t %I"/>})
            end
          end

          context 'tomcat access log format with x-forward-for handling' do
            let(:params) do
              super().merge(
                tomcat_accesslog_enable_xforwarded_for: true
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                with_content(%r{org.apache.catalina.valves.RemoteIpValve}).
                with_content(%r{requestAttributesEnabled="true"})
            end
          end

          context 'with script_check_java_managed enabled' do
            let(:params) do
              super().merge(
                script_check_java_manage: true
              )
            end

            it do
              is_expected.to contain_file(FILENAME_CHECK_JAVA_SH).
                with_content(%r{Wrong JVM version})
            end
          end

          context 'context resources' do
            let(:params) do
              super().merge(
                resources: { 'testdb' => { 'auth' => 'Container' } }
              )
            end

            it do
              is_expected.to contain_file("#{PATH_INSTALLATION_BASE}/conf/context.xml").
                with_content(%r{<Resource name = "testdb"\n        auth = "Container"\n    />})
            end
          end

          context 'disable notifications' do
            let(:params) do
              super().merge(
                disable_notifications: true
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SETENV_SH).
                with_content(%r{^DISABLE_NOTIFICATIONS=})
            end
          end

          context 'native ssl support default params' do
            let(:params) do
              super().merge(
                tomcat_native_ssl: true
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                with_content(%r{redirectPort="8443"}).
                with_content(%r{port="8443"}).
                with_content(%r{keyAlias="jira"}).
                with_content(%r{keystoreFile="/home/jira/jira.jks"}).
                with_content(%r{keystorePass="changeit"}).
                with_content(%r{keystoreType="JKS"}).
                with_content(%r{port="8443".*acceptCount="100"}m).
                with_content(%r{port="8443".*maxThreads="150"}m)
            end
          end

          context 'native ssl support custom params' do
            let(:params) do
              super().merge(
                tomcat_native_ssl: true,
                tomcat_https_port: 9443,
                tomcat_address: '127.0.0.1',
                tomcat_max_threads: 600,
                tomcat_accept_count: 600,
                tomcat_key_alias: 'keystorealias',
                tomcat_keystore_file: '/tmp/keyfile.ks',
                tomcat_keystore_pass: 'keystorepass',
                tomcat_keystore_type: 'PKCS12'
              )
            end

            it do
              is_expected.to contain_file(FILENAME_SERVER_XML).
                with_content(%r{redirectPort="9443"}).
                with_content(%r{port="9443"}).
                with_content(%r{keyAlias="keystorealias"}).
                with_content(%r{keystoreFile="/tmp/keyfile.ks"}).
                with_content(%r{keystorePass="keystorepass"}).
                with_content(%r{keystoreType="PKCS12"}).
                with_content(%r{port="9443".*acceptCount="600"}m).
                with_content(%r{port="9443".*maxThreads="600"}m).
                with_content(%r{port="9443".*address="127\.0\.0\.1"}m)
            end
          end

          context 'enable secure admin sessions' do
            let(:params) do
              super().merge(
                enable_secure_admin_sessions: true
              )
            end

            it do
              is_expected.to contain_file(FILENAME_JIRA_CONFIG_PROPS).
                with_content(%r{jira.websudo.is.disabled = false})
            end
          end

          context 'disable secure admin sessions' do
            let(:params) do
              super().merge(
                enable_secure_admin_sessions: false
              )
            end

            it do
              is_expected.to contain_file(FILENAME_JIRA_CONFIG_PROPS).
                with_content(%r{jira.websudo.is.disabled = true})
            end
          end

          context 'jira-config.properties' do
            let(:params) do
              super().merge(
                jira_config_properties: {
                  'ops.bar.group.size.opsbar-transitions' => '4'
                }
              )
            end

            it do
              is_expected.to contain_file(FILENAME_JIRA_CONFIG_PROPS).
                with_content(%r{jira.websudo.is.disabled = false}).
                with_content(%r{ops.bar.group.size.opsbar-transitions = 4})
            end
          end

          context 'enable clustering' do
            let(:params) do
              super().merge(
                datacenter: true,
                shared_homedir: '/mnt/jira_shared_home_dir'
              )
            end

            it do
              is_expected.to contain_file(FILENAME_CLUSTER_PROPS).
                with_content(%r{jira.node.id = \S+}).
                with_content(%r{jira.shared.home = /mnt/jira_shared_home_dir})
            end
          end

          context 'enable clustering with ehcache options' do
            let(:params) do
              super().merge(
                datacenter: true,
                shared_homedir: '/mnt/jira_shared_home_dir',
                ehcache_listener_host: 'jira.foo.net',
                ehcache_listener_port: 42,
                ehcache_object_port: 401
              )
            end

            it do
              is_expected.to contain_file(FILENAME_CLUSTER_PROPS).
                with_content(%r{jira.node.id = \S+}).
                with_content(%r{jira.shared.home = /mnt/jira_shared_home_dir}).
                with_content(%r{ehcache.listener.hostName = jira.foo.net}).
                with_content(%r{ehcache.listener.port = 42}).
                with_content(%r{ehcache.object.port = 401})
            end
          end

          context 'enable clustering with short fqdn' do
            let(:params) do
              super().merge(
                datacenter: true,
                shared_homedir: '/mnt/jira_shared_home_dir'
              )
            end

            let(:facts) do
              super().merge(
                networking: {
                  'fqdn' => 'short-hostname.example.com',
                  'hostname' => 'short-hostname'
                }
              )
            end

            it do
              is_expected.to contain_file(FILENAME_CLUSTER_PROPS).
                with_content(%r{jira.node.id = short-hostname.example.com}).
                with_content(%r{jira.shared.home = /mnt/jira_shared_home_dir})
            end
          end

          context 'enable clustering with long fqdn exceeding 60 characters' do
            let(:params) do
              super().merge(
                datacenter: true,
                shared_homedir: '/mnt/jira_shared_home_dir'
              )
            end

            let(:facts) do
              super().merge(
                networking: {
                  'fqdn' => 'this-is-a-very-long-hostname-that-exceeds-sixty-characters.example.com',
                  'hostname' => 'long-hostname'
                }
              )
            end

            it do
              is_expected.to contain_file(FILENAME_CLUSTER_PROPS).
                with_content(%r{jira.node.id = long-hostname}).
                with_content(%r{jira.shared.home = /mnt/jira_shared_home_dir})
            end
          end

          context 'OpenJDK jvm params' do
            let(:params) do
              super().merge(
                jvm_type: 'openjdk-11'
              )
            end

            it { is_expected.to compile.with_all_deps }

            it do
              is_expected.to contain_file(FILENAME_SETENV_SH).
                with_content(REGEXP_DISABLE_NOTIFICATIONS).
                with_content(%r{JVM_SUPPORT_RECOMMENDED_ARGS=''}).
                with_content(%r{JVM_GC_ARGS='.+ -XX:\+ExplicitGCInvokesConcurrent}).
                with_content(%r{JVM_CODE_CACHE_ARGS='\S+InitialCodeCacheSize=32m \S+ReservedCodeCacheSize=512m}).
                with_content(%r{JVM_REQUIRED_ARGS='.+InterningDocumentFactory})
            end

            it { is_expected.to contain_file(FILENAME_USER_SH) }
            it { is_expected.to contain_file(FILENAME_SERVER_XML) }

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(REGEXP_POSTGRESQL_URL).
                with_content(REGEXP_PUBLIC_SCHEMA)
            end

            it { is_expected.not_to contain_file(FILENAME_CLUSTER_PROPS) }
            it { is_expected.not_to contain_file(FILENAME_CHECK_JAVA_SH) }
          end

          context 'custom jvm params' do
            let(:params) do
              super().merge(
                java_opts: '-XX:-TEST_OPTIONAL',
                jvm_gc_args: '-XX:-TEST_GC_ARG',
                jvm_code_cache_args: '-XX:-TEST_CODECACHE',
                jvm_extra_args: '-XX:-TEST_EXTRA'
              )
            end

            it { is_expected.to compile.with_all_deps }

            it do
              is_expected.to contain_file(FILENAME_SETENV_SH).
                with_content(REGEXP_DISABLE_NOTIFICATIONS).
                with_content(%r{JVM_SUPPORT_RECOMMENDED_ARGS=\S+TEST_OPTIONAL}).
                with_content(%r{JVM_GC_ARGS=\S+TEST_GC_ARG}).
                with_content(%r{JVM_CODE_CACHE_ARGS=\S+TEST_CODECACHE}).
                with_content(%r{JVM_EXTRA_ARGS=\S+TEST_EXTRA})
            end

            it { is_expected.to contain_file(FILENAME_USER_SH) }
            it { is_expected.to contain_file(FILENAME_SERVER_XML) }

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(REGEXP_POSTGRESQL_URL).
                with_content(REGEXP_PUBLIC_SCHEMA)
            end

            it { is_expected.not_to contain_file(FILENAME_CLUSTER_PROPS) }
            it { is_expected.not_to contain_file(FILENAME_CHECK_JAVA_SH) }
          end

          context 'simple plugin download without username and password' do
            let(:params) do
              super().merge(
                plugins: [
                  {
                    installation_name: 'fine-jira-plugin.jar',
                    source: PLUGIN_SOURCE_URL,
                    ensure: 'present',
                    checksum: '123abc',
                    checksum_type: 'sha512'
                  }
                ]
              )
            end

            it { is_expected.to compile.with_all_deps }

            it do
              is_expected.to contain_archive("#{PATH_INSTALLATION_BASE}/atlassian-jira/WEB-INF/lib/fine-jira-plugin.jar").
                with({
                       source: PLUGIN_SOURCE_URL,
                       ensure: 'present',
                       checksum: '123abc',
                       checksum_type: 'sha512'
                     })
            end
          end

          context 'simple plugin download with username' do
            let(:params) do
              super().merge(
                plugins: [
                  {
                    installation_name: 'fine-jira-plugin.jar',
                    source: PLUGIN_SOURCE_URL,
                    ensure: 'present',
                    username: 'TheUser',
                    checksum: '123abc',
                    checksum_type: 'sha512'
                  }
                ]
              )
            end

            it { is_expected.to compile.with_all_deps }

            it do
              is_expected.to contain_archive("#{PATH_INSTALLATION_BASE}/atlassian-jira/WEB-INF/lib/fine-jira-plugin.jar").
                with({
                       source: PLUGIN_SOURCE_URL,
                       ensure: 'present',
                       username: 'TheUser',
                       checksum: '123abc',
                       checksum_type: 'sha512'
                     })
            end
          end

          context 'simple plugin download with password' do
            let(:params) do
              super().merge(
                plugins: [
                  {
                    installation_name: 'fine-jira-plugin.jar',
                    source: PLUGIN_SOURCE_URL,
                    ensure: 'present',
                    password: 'ThePassword',
                    checksum: '123abc',
                    checksum_type: 'sha512'
                  }
                ]
              )
            end

            it { is_expected.to compile.with_all_deps }

            it do
              is_expected.to contain_archive("#{PATH_INSTALLATION_BASE}/atlassian-jira/WEB-INF/lib/fine-jira-plugin.jar").
                with({
                       source: PLUGIN_SOURCE_URL,
                       ensure: 'present',
                       password: 'ThePassword',
                       checksum: '123abc',
                       checksum_type: 'sha512'
                     })
            end
          end

          context 'simple plugin download with username and password' do
            let(:params) do
              super().merge(
                plugins: [
                  {
                    installation_name: 'fine-jira-plugin.jar',
                    source: PLUGIN_SOURCE_URL,
                    ensure: 'present',
                    username: 'TheUser',
                    password: 'ThePassword',
                    checksum: '123abc',
                    checksum_type: 'sha512'
                  }
                ]
              )
            end

            it { is_expected.to compile.with_all_deps }

            it do
              is_expected.to contain_archive("#{PATH_INSTALLATION_BASE}/atlassian-jira/WEB-INF/lib/fine-jira-plugin.jar").
                with({
                       source: PLUGIN_SOURCE_URL,
                       ensure: 'present',
                       username: 'TheUser',
                       password: 'ThePassword',
                       checksum: '123abc',
                       checksum_type: 'sha512'
                     })
            end

            context 'ensure absent marked plugin isn\'t downloaded' do
              let(:params) do
                super().merge(
                  plugins: [
                    {
                      'installation_name' => 'fine-jira-plugin.jar',
                      'ensure' => 'absent'
                    }
                  ]
                )
              end

              it do
                is_expected.to contain_archive("#{PATH_INSTALLATION_BASE}/atlassian-jira/WEB-INF/lib/fine-jira-plugin.jar").
                  with({ 'ensure' => 'absent' })
              end
            end
          end

          context 'with version >= 9.4.0' do
            let(:params) do
              {
                javahome: '/opt/java',
                version: '9.4.0',
              }
            end

            it do
              is_expected.to contain_file(FILENAME_DBCONFIG_XML).
                with_content(%r{<connection-properties>tcpKeepAlive=true}).
                without_content(%r{socketTimeout=240})
            end
          end
        end
      end
    end
  end
end
