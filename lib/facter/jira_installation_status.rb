# frozen_string_literal: true

Facter.add('jira_service_status') do
  setcode do
    Facter::Core::Execution.execute('systemctl is-active jira') == 'active' ? 'active' : 'inactive'
  end
end

Facter.add('jira_running_pid') do
  setcode do
    Facter::Core::Execution.execute('systemctl show -p MainPID --value jira')
  end
end

Facter.add('jira_running_user') do
  setcode do
    if Facter.value('jira_service_status') == 'active' && Facter.value('jira_running_pid') != ''
      Facter::Core::Execution.execute(format('stat -c %%U /proc/%s', Facter.value('jira_running_pid')))
    else
      '<unknown>'
    end
  end
end

Facter.add('jira_running_dbconfig_exists') do
  setcode do
    if Facter.value('jira_running_user') == '<unknown>'
      false
    else
      File.exist? format('%s/dbconfig.xml', Dir.home(Facter.value('jira_running_user')))
    end
  end
end

Facter.add('jira_running_version') do
  setcode do
    if Facter.value('jira_running_user') == '<unknown>'
      '<unknown>'
    else
      Facter::Core::Execution.execute('systemctl show --property ExecStart --value jira | grep -o -E "path=[^ ]+" | grep -o -E "\-[0-9\.]+\-" | tr -d "-"')
    end
  end
end
