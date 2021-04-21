# @summary A set of attribute hashes keyed by connector port number
type Jira::Tomcat_connectors = Hash[Stdlib::Port::Unprivileged, Jira::Tomcat_attributes]
