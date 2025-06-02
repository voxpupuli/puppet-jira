# Changelog

All notable changes to this project will be documented in this file.
Each new release typically also includes the latest modulesync defaults.
These should not affect the functionality of the module.

## [v6.2.1](https://github.com/voxpupuli/puppet-jira/tree/v6.2.1) (2025-06-02)

[Full Changelog](https://github.com/voxpupuli/puppet-jira/compare/v6.2.0...v6.2.1)

**Fixed bugs:**

- Use Deferred on epp call to generate dbconfig.xml [\#445](https://github.com/voxpupuli/puppet-jira/pull/445) ([h-haaks](https://github.com/h-haaks))

**Closed issues:**

- With release 6.2.0 puppet again starts to change dbconfig.xml on every agent run [\#444](https://github.com/voxpupuli/puppet-jira/issues/444)

## [v6.2.0](https://github.com/voxpupuli/puppet-jira/tree/v6.2.0) (2025-03-27)

[Full Changelog](https://github.com/voxpupuli/puppet-jira/compare/v6.1.1...v6.2.0)

**Implemented enhancements:**

- metadata.json: Add OpenVox [\#442](https://github.com/voxpupuli/puppet-jira/pull/442) ([jstraw](https://github.com/jstraw))
- Add AlmaLinux/Rocky support [\#438](https://github.com/voxpupuli/puppet-jira/pull/438) ([bastelfreak](https://github.com/bastelfreak))
- Add Ubuntu 22.04 support [\#437](https://github.com/voxpupuli/puppet-jira/pull/437) ([bastelfreak](https://github.com/bastelfreak))
- Add EL9 support [\#435](https://github.com/voxpupuli/puppet-jira/pull/435) ([bastelfreak](https://github.com/bastelfreak))

**Fixed bugs:**

- Fix breaking change regression of PR \#429 [\#434](https://github.com/voxpupuli/puppet-jira/pull/434) ([diLLec](https://github.com/diLLec))

## [v6.1.1](https://github.com/voxpupuli/puppet-jira/tree/v6.1.1) (2025-02-24)

[Full Changelog](https://github.com/voxpupuli/puppet-jira/compare/v6.1.0...v6.1.1)

Due to some CI issues, the `v6.1.0` release was tagged as `v6.1.0` but contains `v6.1.0-rc0` in metadata.json. `v6.1.1` is just a rerelease.

## [v6.1.0](https://github.com/voxpupuli/puppet-jira/tree/v6.1.0) (2025-02-24)

[Full Changelog](https://github.com/voxpupuli/puppet-jira/compare/v6.0.0...v6.1.0)

**Implemented enhancements:**

- Add manage\_homedir support [\#392](https://github.com/voxpupuli/puppet-jira/issues/392)
- Add "change database password" parameter - JIRA \>10.3 [\#429](https://github.com/voxpupuli/puppet-jira/pull/429) ([diLLec](https://github.com/diLLec))
- Add `manage_homedir` parameter [\#428](https://github.com/voxpupuli/puppet-jira/pull/428) ([Joris29](https://github.com/Joris29))
- Allow puppet/systemd 8.x [\#427](https://github.com/voxpupuli/puppet-jira/pull/427) ([jay7x](https://github.com/jay7x))
- update puppet-systemd upper bound to 8.0.0 [\#423](https://github.com/voxpupuli/puppet-jira/pull/423) ([TheMeier](https://github.com/TheMeier))
- Add Debian 11 support [\#397](https://github.com/voxpupuli/puppet-jira/pull/397) ([root-expert](https://github.com/root-expert))

**Fixed bugs:**

- Update Readme, fix CI Badge, Links, Code Block formats, add Reference… [\#420](https://github.com/voxpupuli/puppet-jira/pull/420) ([rwaffen](https://github.com/rwaffen))

## [v6.0.0](https://github.com/voxpupuli/puppet-jira/tree/v6.0.0) (2024-02-13)

[Full Changelog](https://github.com/voxpupuli/puppet-jira/compare/v5.1.0...v6.0.0)

**Breaking changes:**

- Drop Puppet 6 support [\#404](https://github.com/voxpupuli/puppet-jira/pull/404) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Fix tests with modulesync 7.3.0; allow latest dependency versions [\#414](https://github.com/voxpupuli/puppet-jira/pull/414) ([h-haaks](https://github.com/h-haaks))
- Add Puppet 8 support [\#408](https://github.com/voxpupuli/puppet-jira/pull/408) ([bastelfreak](https://github.com/bastelfreak))
- Allow custom plugin installation and usage of JNDI database connections [\#389](https://github.com/voxpupuli/puppet-jira/pull/389) ([ThomasMinor](https://github.com/ThomasMinor))

**Fixed bugs:**

- Update setenv.sh.epp if statement to work with service desk [\#400](https://github.com/voxpupuli/puppet-jira/pull/400) ([techtino](https://github.com/techtino))
- Avoid duplicate scheme declaration when using proxy with SSL [\#396](https://github.com/voxpupuli/puppet-jira/pull/396) ([jmcnatt](https://github.com/jmcnatt))

**Closed issues:**

- JVM\_OPENS not set for JIRA Java 17 support [\#412](https://github.com/voxpupuli/puppet-jira/issues/412)
- cluster.properties.epp - soon to be deprecated code by Puppet 8 [\#411](https://github.com/voxpupuli/puppet-jira/issues/411)

**Merged pull requests:**

- Bugfix java 17 support per atlassian upstream [\#413](https://github.com/voxpupuli/puppet-jira/pull/413) ([valentino-aguiar-gsa](https://github.com/valentino-aguiar-gsa))
- Remove legacy top-scope syntax [\#410](https://github.com/voxpupuli/puppet-jira/pull/410) ([smortex](https://github.com/smortex))
- Allow up-to-date dependencies [\#393](https://github.com/voxpupuli/puppet-jira/pull/393) ([smortex](https://github.com/smortex))

## [v5.1.0](https://github.com/voxpupuli/puppet-jira/tree/v5.1.0) (2021-08-20)

[Full Changelog](https://github.com/voxpupuli/puppet-jira/compare/v5.0.1...v5.1.0)

**Implemented enhancements:**

- Configure recommended JDBC connection-properties by default for PostgreSQL databases [\#381](https://github.com/voxpupuli/puppet-jira/pull/381) ([oranenj](https://github.com/oranenj))
- Allow managing installation and home directory modes and enforce installdir permissions by default [\#378](https://github.com/voxpupuli/puppet-jira/pull/378) ([oranenj](https://github.com/oranenj))

**Fixed bugs:**

- use variable instead of literal in server.xml [\#385](https://github.com/voxpupuli/puppet-jira/pull/385) ([dacron](https://github.com/dacron))

**Closed issues:**

- connection-settings parameter in dbconfig.xml template should be connection-properties instead [\#380](https://github.com/voxpupuli/puppet-jira/issues/380)
- JIRA will not start if the installation directory mode is missing o+x [\#377](https://github.com/voxpupuli/puppet-jira/issues/377)

**Merged pull requests:**

- switch from camptocamp/systemd to voxpupuli/systemd [\#386](https://github.com/voxpupuli/puppet-jira/pull/386) ([bastelfreak](https://github.com/bastelfreak))
- Extend the version check to the tailored jira servicedesk version [\#383](https://github.com/voxpupuli/puppet-jira/pull/383) ([diLLec](https://github.com/diLLec))
- Add note about RHEL 8 and SELinux and clean up a bit [\#379](https://github.com/voxpupuli/puppet-jira/pull/379) ([oranenj](https://github.com/oranenj))

## [v5.0.1](https://github.com/voxpupuli/puppet-jira/tree/v5.0.1) (2021-04-23)

[Full Changelog](https://github.com/voxpupuli/puppet-jira/compare/v5.0.0...v5.0.1)

**Fixed bugs:**

- Explicitly configure dbconfig.xml parameters again to stop JIRA's healthcheck from complaining. This restores the behaviour prior to 5.0.0 [\#375](https://github.com/voxpupuli/puppet-jira/pull/375) ([oranenj](https://github.com/oranenj))

## [v5.0.0](https://github.com/voxpupuli/puppet-jira/tree/v5.0.0) (2021-04-21)

[Full Changelog](https://github.com/voxpupuli/puppet-jira/compare/v4.0.1...v5.0.0)

Version 5.0.0 is a major release of the `puppet/jira` module. The API stays mostly the same, but there are a few changes that users should take into account:

### Only JIRA version 8.0.0 and newer are supported.
- The module's templates have been synchronized with the latest LTS release of JIRA (8.13.5)
- Upgrade your JIRA installation to a supported version using a previous version of this module first.
### The `jira::facts` class has been removed
- The `jira_version` fact is no longer required for upgrades and the facts weren't particularly useful, so they have been removed. The module will not remove existing files, however, so existing installations will continue reporting jira facts.
- Note: upgrading to this version will cause jira to restart once due to the way updates are detected. If you would like to avoid this, create a `${jira::installdir}/atlassian-${jira::product_name}-running` symlink pointing to your current active installation.
### Default versions have changed
- The module will now install 8.13.5 by default. If you for some reason don't explicitly specify a JIRA version in your installation, you will get an automatic upgrade.
- The MySQL connector, if installed, is now 8.0.23 by default, as the previous default is EOL.
### The API is now typed
The type enforcement is mostly backwards compatible, but some variables which previously accepted integer-looking strings will now require actual integers.
### Database configuration is overhauled
- Most settings in `dbconfig.xml` are now *omitted* of not explicitly configured by the user. JIRA will fall back to its built-in default values, which mostly matched what the module configured previously.
**If this causes adverse effects with your installation, please report a bug.**
- `jira::poolsize` is now a deprecated parameter and merely an alias for `$jira::pool_max_size`. If both are configured, the latter takes precedence. Jira's default value for this parameter is 20, which matches the module's previous default
- `jira::enable_connection_pooling` is now deprecated and has no effect. It previously only affected users using PostgreSQL databases, and served no useful purpose.
### Changes to default behaviour
- We now use the `camptocamp/systemd` module, and the unit file is installed in `/etc/systemd/system/jira.service`. The old file at `/lib/systemd/system/jira.service` can be removed, though its existence should not matter.
- `jira::java_opts` no longer defaults to `-XX:-HeapDumpOnOutOfMemoryError` as it is not on by default in Atlassian's configuration. If you want this, please add it to your configuration explicitly. The old name for the parameter is maintained
- The module selects some defaults for `setenv.sh` based on the value of `jira::jvm_type`. This parameter **defaults to** `openjdk-11`. You may override the module's choices by using the new `jira::jvm_gc_args`, `jira::jvm_code_cache_args` and `jira::jvm_extra_args` parameters. For backwards compatibility, `JVM_SUPPORT_RECOMMENDED_ARGS` is configured by `jira::java_opts`
### Broken / deprecated functionality has been removed
- The `jira::service` class is now private, and overriding the service template is no longer possible. Use systemd drop-ins instead.
- Only `puppet/archive` is supported for downloading the installation packages, and this is not configurable
- `jira::format` no longer exists; it's always `tar.gz`. This parameter never worked properly.

**Breaking changes:**

- Remove jira::facts and rewrite upgrade logic [\#372](https://github.com/voxpupuli/puppet-jira/pull/372) ([oranenj](https://github.com/oranenj))
- Bump default MySQL connector version to 8.0.23 and allow disabling the default HTTP connector [\#369](https://github.com/voxpupuli/puppet-jira/pull/369) ([oranenj](https://github.com/oranenj))
- Add newer OSes and Puppet 7 to test matrix, drop Puppet 5 [\#364](https://github.com/voxpupuli/puppet-jira/pull/364) ([oranenj](https://github.com/oranenj))
- Drop support for JIRA \<8.0.0 [\#359](https://github.com/voxpupuli/puppet-jira/pull/359) ([oranenj](https://github.com/oranenj))
- Sync setenv.sh with upstream 8.13.5 \(LTS\) [\#357](https://github.com/voxpupuli/puppet-jira/pull/357) ([oranenj](https://github.com/oranenj))
- Remove support for the deprecated staging module [\#355](https://github.com/voxpupuli/puppet-jira/pull/355) ([oranenj](https://github.com/oranenj))
- Refactor database configuration and make the main API typed [\#352](https://github.com/voxpupuli/puppet-jira/pull/352) ([oranenj](https://github.com/oranenj))
- Drop support for sysvinit [\#344](https://github.com/voxpupuli/puppet-jira/pull/344) ([ekohl](https://github.com/ekohl))

**Implemented enhancements:**

- Add provider to set server ID and install License [\#36](https://github.com/voxpupuli/puppet-jira/issues/36)
- Test with Ubuntu 20.04 [\#371](https://github.com/voxpupuli/puppet-jira/pull/371) ([oranenj](https://github.com/oranenj))
- Depend on camptocamp/systemd and clean up service handling [\#368](https://github.com/voxpupuli/puppet-jira/pull/368) ([oranenj](https://github.com/oranenj))
- puppetlabs/stdlib: Allow 7.x [\#367](https://github.com/voxpupuli/puppet-jira/pull/367) ([bastelfreak](https://github.com/bastelfreak))
- Add support for Oracle service names [\#365](https://github.com/voxpupuli/puppet-jira/pull/365) ([oranenj](https://github.com/oranenj))
- Provide jira::java\_package option to allow installing a java package directly via this module [\#363](https://github.com/voxpupuli/puppet-jira/pull/363) ([oranenj](https://github.com/oranenj))
- Allow specifying JDBC connection parameters with jira::connection\_settings [\#353](https://github.com/voxpupuli/puppet-jira/pull/353) ([oranenj](https://github.com/oranenj))
- Add handling for X-Forwarded-For in access logs [\#350](https://github.com/voxpupuli/puppet-jira/pull/350) ([diLLec](https://github.com/diLLec))
- Allow defining additional Tomcat connectors [\#316](https://github.com/voxpupuli/puppet-jira/pull/316) ([antaflos](https://github.com/antaflos))

**Fixed bugs:**

- systemd provider has incorrect file-mode [\#289](https://github.com/voxpupuli/puppet-jira/issues/289)
- Restore $jira::java\_opts for compatibility and remove $jira::jvm\_\*\_additional from the API, as setting JDK type to custom allows full control anyway. [\#351](https://github.com/voxpupuli/puppet-jira/pull/351) ([oranenj](https://github.com/oranenj))
- Fixing that the suffix can be empty as well \(needed for mysql-connector \> 8\) [\#337](https://github.com/voxpupuli/puppet-jira/pull/337) ([diLLec](https://github.com/diLLec))

**Closed issues:**

- Test with Puppet 7 and fresher OSes [\#361](https://github.com/voxpupuli/puppet-jira/issues/361)
- Drop Ubuntu 16.04, Add 18.04 instead [\#346](https://github.com/voxpupuli/puppet-jira/issues/346)
- server.xml - StuckThreadDetectionValve introduced in 7.6.12 [\#339](https://github.com/voxpupuli/puppet-jira/issues/339)
- jira::java\_opts defined as YAML multiline block string generates incorrect JAVA\_OPTS string in setenv.sh [\#333](https://github.com/voxpupuli/puppet-jira/issues/333)
- Jira\_facts deprecation warnings [\#330](https://github.com/voxpupuli/puppet-jira/issues/330)
- Add optional MySQL connection string options [\#323](https://github.com/voxpupuli/puppet-jira/issues/323)
- jira service not restarted when changing systemd file [\#315](https://github.com/voxpupuli/puppet-jira/issues/315)
- remove dependency to puppet/staging [\#313](https://github.com/voxpupuli/puppet-jira/issues/313)
- JVM\_REQUIRED\_ARGS is missing -Dorg.dom4j.factory=com.atlassian.core.xml.InterningDocumentFactory [\#309](https://github.com/voxpupuli/puppet-jira/issues/309)
- JVM\_CODE\_CACHE\_ARGS not set [\#308](https://github.com/voxpupuli/puppet-jira/issues/308)
- Please allow adding properties to server.xml that would add the clients' real ip address to jira access logs when running behind a proxy server [\#305](https://github.com/voxpupuli/puppet-jira/issues/305)
- Java 11 Compatibility [\#300](https://github.com/voxpupuli/puppet-jira/issues/300)
- Mysql connector is not respecting the deploy\_module choice [\#293](https://github.com/voxpupuli/puppet-jira/issues/293)
- Oracle real url has : instead of / [\#283](https://github.com/voxpupuli/puppet-jira/issues/283)
- jira user depends on install dir \(unable to set home dir inside install dir as per example\) [\#255](https://github.com/voxpupuli/puppet-jira/issues/255)
- MySQL Connector is not installing with correct directory permissions [\#241](https://github.com/voxpupuli/puppet-jira/issues/241)
- Connector class incompatibility since JIRA 7.3.0. [\#213](https://github.com/voxpupuli/puppet-jira/issues/213)
- Can't create parent directories if they dont exist [\#150](https://github.com/voxpupuli/puppet-jira/issues/150)
- Oracle connection string incorrect [\#146](https://github.com/voxpupuli/puppet-jira/issues/146)
- HTTP to HTTPS redirect [\#138](https://github.com/voxpupuli/puppet-jira/issues/138)
- Seems to be obsolete - JIRA 7.1.4 [\#137](https://github.com/voxpupuli/puppet-jira/issues/137)
- Use service\_provider for init management [\#124](https://github.com/voxpupuli/puppet-jira/issues/124)
- JIRA 7.1.x compatibility [\#120](https://github.com/voxpupuli/puppet-jira/issues/120)
- Jira don't want to use my created database [\#117](https://github.com/voxpupuli/puppet-jira/issues/117)
- Add workaround for staging strip with zip archive [\#103](https://github.com/voxpupuli/puppet-jira/issues/103)
- puppet-jira -- Upgrade howto & addons management questions  [\#102](https://github.com/voxpupuli/puppet-jira/issues/102)
- Add support to configure AJP as the only enabled connector [\#85](https://github.com/voxpupuli/puppet-jira/issues/85)
- Add support for handling archive permisions on hardened servers [\#77](https://github.com/voxpupuli/puppet-jira/issues/77)
- jira::facts cannot access $jira::tomcatPort [\#63](https://github.com/voxpupuli/puppet-jira/issues/63)
- Add tests for oracle database [\#53](https://github.com/voxpupuli/puppet-jira/issues/53)
- Validate all parameters [\#49](https://github.com/voxpupuli/puppet-jira/issues/49)
- JIRA can't parse the JVM arguments when delimited with spaces instead of semicolons. [\#44](https://github.com/voxpupuli/puppet-jira/issues/44)

**Merged pull requests:**

- Convert documentation to puppet strings [\#373](https://github.com/voxpupuli/puppet-jira/pull/373) ([oranenj](https://github.com/oranenj))
- $installdir was previously unnecessarily owned by the jira user. It will now be owned by root. [\#366](https://github.com/voxpupuli/puppet-jira/pull/366) ([oranenj](https://github.com/oranenj))
- Minor documentation updates [\#360](https://github.com/voxpupuli/puppet-jira/pull/360) ([oranenj](https://github.com/oranenj))
- Make MySQL connector library world-readable [\#356](https://github.com/voxpupuli/puppet-jira/pull/356) ([oranenj](https://github.com/oranenj))
- Refactor most configuration to use EPP templates [\#354](https://github.com/voxpupuli/puppet-jira/pull/354) ([oranenj](https://github.com/oranenj))
- Fix Ruby path expectation [\#349](https://github.com/voxpupuli/puppet-jira/pull/349) ([ekohl](https://github.com/ekohl))
- Updating check-java.sh and server.xml templates to upstream version [\#348](https://github.com/voxpupuli/puppet-jira/pull/348) ([timdeluxe](https://github.com/timdeluxe))
- Remove special code path for Puppet Enterprise [\#347](https://github.com/voxpupuli/puppet-jira/pull/347) ([ekohl](https://github.com/ekohl))
- Fix unit tests after sysvinit patch broke them [\#345](https://github.com/voxpupuli/puppet-jira/pull/345) ([ekohl](https://github.com/ekohl))
- facts.pp: use less restrictive mode for the external fact script [\#343](https://github.com/voxpupuli/puppet-jira/pull/343) ([kenyon](https://github.com/kenyon))
- templates/facts.rb.erb: update URI.open syntax to fix deprecation warnings [\#342](https://github.com/voxpupuli/puppet-jira/pull/342) ([kenyon](https://github.com/kenyon))
- acceptance tests: use the default version of postgresql [\#340](https://github.com/voxpupuli/puppet-jira/pull/340) ([kenyon](https://github.com/kenyon))
- facts.pp: use localhost instead of 127.0.0.1 [\#338](https://github.com/voxpupuli/puppet-jira/pull/338) ([kenyon](https://github.com/kenyon))
- remove incorrect apostrophe in example [\#332](https://github.com/voxpupuli/puppet-jira/pull/332) ([wolfaba](https://github.com/wolfaba))
- Make JVM\_EXTRA\_ARGS manageable for java 11 compatibility [\#326](https://github.com/voxpupuli/puppet-jira/pull/326) ([diLLec](https://github.com/diLLec))

## [v4.0.1](https://github.com/voxpupuli/puppet-jira/tree/v4.0.1) (2020-06-17)

[Full Changelog](https://github.com/voxpupuli/puppet-jira/compare/v4.0.0...v4.0.1)

**Fixed bugs:**

- Added \>= to capture version 7.0.0 as using the "software" url [\#291](https://github.com/voxpupuli/puppet-jira/pull/291) ([rfreiberger](https://github.com/rfreiberger))

**Closed issues:**

- Bump puppetlabs-stdlib dependency [\#318](https://github.com/voxpupuli/puppet-jira/issues/318)
- Raise puppet-archive version [\#304](https://github.com/voxpupuli/puppet-jira/issues/304)
- Server.xml for servicedesk [\#295](https://github.com/voxpupuli/puppet-jira/issues/295)
- Jira 7.12 needs relaxedPathChars & relaxedQueryChars [\#269](https://github.com/voxpupuli/puppet-jira/issues/269)
- Puppet 4 support? [\#168](https://github.com/voxpupuli/puppet-jira/issues/168)
- jira::facts don't work with All-in-One Puppet 4.x agent [\#151](https://github.com/voxpupuli/puppet-jira/issues/151)

**Merged pull requests:**

- Update jira::facts to check for Puppet AIO agent [\#321](https://github.com/voxpupuli/puppet-jira/pull/321) ([dpisano](https://github.com/dpisano))

## [v4.0.0](https://github.com/voxpupuli/puppet-jira/tree/v4.0.0) (2019-06-19)

[Full Changelog](https://github.com/voxpupuli/puppet-jira/compare/v3.5.2...v4.0.0)

**Breaking changes:**

- modulesync 2.7.0 and drop puppet 4 [\#292](https://github.com/voxpupuli/puppet-jira/pull/292) ([bastelfreak](https://github.com/bastelfreak))

**Implemented enhancements:**

- Cannot add wished tag to server.xml [\#234](https://github.com/voxpupuli/puppet-jira/issues/234)
- Better Amazon support [\#287](https://github.com/voxpupuli/puppet-jira/pull/287) ([cpepe](https://github.com/cpepe))
- Added relaxedPath xml attributes as per jira apache tomcat upgrade file [\#280](https://github.com/voxpupuli/puppet-jira/pull/280) ([domgoodwin](https://github.com/domgoodwin))

**Fixed bugs:**

- Jira Service Desk doesn't start with JasperListener / need relaxedPath with correct version comp [\#288](https://github.com/voxpupuli/puppet-jira/pull/288) ([thonixx](https://github.com/thonixx))
- Update default `download_url` [\#286](https://github.com/voxpupuli/puppet-jira/pull/286) ([alexjfisher](https://github.com/alexjfisher))
- Remove messy warnings. Fixes \#234 [\#272](https://github.com/voxpupuli/puppet-jira/pull/272) ([br0ch0n](https://github.com/br0ch0n))

**Closed issues:**

- Jira downloads url default [\#294](https://github.com/voxpupuli/puppet-jira/issues/294)
- download url has changed [\#285](https://github.com/voxpupuli/puppet-jira/issues/285)
- Support for additional cluster.properties config [\#245](https://github.com/voxpupuli/puppet-jira/issues/245)

**Merged pull requests:**

- Update `download_url` default value in documentation [\#297](https://github.com/voxpupuli/puppet-jira/pull/297) ([towo](https://github.com/towo))
- Add Ehcache options; require stdlib 4.25.0 [\#282](https://github.com/voxpupuli/puppet-jira/pull/282) ([nrhtr](https://github.com/nrhtr))
- replace deprecated has\_key\(\) with `in` [\#276](https://github.com/voxpupuli/puppet-jira/pull/276) ([bastelfreak](https://github.com/bastelfreak))
- replace validate\_\* with assert\_type in init.pp [\#275](https://github.com/voxpupuli/puppet-jira/pull/275) ([bastelfreak](https://github.com/bastelfreak))

## [v3.5.2](https://github.com/voxpupuli/puppet-jira/tree/v3.5.2) (2018-10-14)

[Full Changelog](https://github.com/voxpupuli/puppet-jira/compare/v3.5.1...v3.5.2)

**Merged pull requests:**

- modulesync 2.1.0 and allow puppet 6.x [\#268](https://github.com/voxpupuli/puppet-jira/pull/268) ([bastelfreak](https://github.com/bastelfreak))
- modulesync 1.9.6; update all dependencies [\#264](https://github.com/voxpupuli/puppet-jira/pull/264) ([bastelfreak](https://github.com/bastelfreak))

## [v3.5.1](https://github.com/voxpupuli/puppet-jira/tree/v3.5.1) (2018-07-16)

[Full Changelog](https://github.com/voxpupuli/puppet-jira/compare/v3.5.0...v3.5.1)

**Fixed bugs:**

- Update server.xml.erb to allow for jsd [\#260](https://github.com/voxpupuli/puppet-jira/pull/260) ([cpepe](https://github.com/cpepe))
- Check `ps` for a process with the jira pid, not a the jira user [\#258](https://github.com/voxpupuli/puppet-jira/pull/258) ([rigareau](https://github.com/rigareau))

**Closed issues:**

- This logic does not allow Jira Service Desk to operate [\#259](https://github.com/voxpupuli/puppet-jira/issues/259)
- RedHat 6 Service Manifest problem [\#243](https://github.com/voxpupuli/puppet-jira/issues/243)

## [v3.5.0](https://github.com/voxpupuli/puppet-jira/tree/v3.5.0) (2018-07-09)

[Full Changelog](https://github.com/voxpupuli/puppet-jira/compare/v3.4.1...v3.5.0)

**Implemented enhancements:**

- Add Support for H2 Database and Fix \#73  [\#256](https://github.com/voxpupuli/puppet-jira/pull/256) ([TJM](https://github.com/TJM))

**Fixed bugs:**

- certain `dbconfig.xml` settings require `enable_connection_pooling => true` [\#242](https://github.com/voxpupuli/puppet-jira/issues/242)

**Closed issues:**

- Add H2 database support [\#254](https://github.com/voxpupuli/puppet-jira/issues/254)
- Not compatible with JIRA 7.5+ and MS SQL Server [\#244](https://github.com/voxpupuli/puppet-jira/issues/244)
- consolidate db, dbtype, and dbdriver [\#73](https://github.com/voxpupuli/puppet-jira/issues/73)

**Merged pull requests:**

- Update README.md for clarity [\#253](https://github.com/voxpupuli/puppet-jira/pull/253) ([ronech](https://github.com/ronech))
- Update server.xml.erb to account for weird Service Desk versioning [\#252](https://github.com/voxpupuli/puppet-jira/pull/252) ([ronech](https://github.com/ronech))
- switch to using ensure\_packages to avoid conflicts [\#250](https://github.com/voxpupuli/puppet-jira/pull/250) ([bmagistro](https://github.com/bmagistro))
- drop EOL OSs; fix puppet version range [\#249](https://github.com/voxpupuli/puppet-jira/pull/249) ([bastelfreak](https://github.com/bastelfreak))
- Rely on beaker-hostgenerator for docker nodesets [\#246](https://github.com/voxpupuli/puppet-jira/pull/246) ([ekohl](https://github.com/ekohl))

## [v3.4.1](https://github.com/voxpupuli/puppet-jira/tree/v3.4.1) (2018-03-30)

[Full Changelog](https://github.com/voxpupuli/puppet-jira/compare/v3.4.0...v3.4.1)

**Fixed bugs:**

- MySQL storage\_engine problem [\#239](https://github.com/voxpupuli/puppet-jira/issues/239)
- Correct jdbc storage engine parameter. [\#216](https://github.com/voxpupuli/puppet-jira/pull/216) ([chrisperelstein](https://github.com/chrisperelstein))

## [v3.4.0](https://github.com/voxpupuli/puppet-jira/tree/v3.4.0) (2018-03-28)

[Full Changelog](https://github.com/voxpupuli/puppet-jira/compare/v3.3.0...v3.4.0)

**Implemented enhancements:**

- Flags to disable management of jira user and group [\#215](https://github.com/voxpupuli/puppet-jira/issues/215)

**Merged pull requests:**

- bump puppet to latest supported version 4.10.0 [\#237](https://github.com/voxpupuli/puppet-jira/pull/237) ([bastelfreak](https://github.com/bastelfreak))
- Add proxy support for 'archive' [\#233](https://github.com/voxpupuli/puppet-jira/pull/233) ([abrust-ucsd](https://github.com/abrust-ucsd))
- bump mysql dependency version to allow 5.x [\#230](https://github.com/voxpupuli/puppet-jira/pull/230) ([bastelfreak](https://github.com/bastelfreak))

## [v3.3.0](https://github.com/voxpupuli/puppet-jira/tree/v3.3.0) (2017-12-09)

[Full Changelog](https://github.com/voxpupuli/puppet-jira/compare/v3.2.1...v3.3.0)

**Implemented enhancements:**

- Add official Ubuntu 16.04 support [\#229](https://github.com/voxpupuli/puppet-jira/pull/229) ([KoenDierckx](https://github.com/KoenDierckx))

**Fixed bugs:**

- Update download URL logic [\#218](https://github.com/voxpupuli/puppet-jira/issues/218)

**Merged pull requests:**

- bump archive dep to allow latest version [\#221](https://github.com/voxpupuli/puppet-jira/pull/221) ([bastelfreak](https://github.com/bastelfreak))

## [v3.2.1](https://github.com/voxpupuli/puppet-jira/tree/v3.2.1) (2017-10-13)

[Full Changelog](https://github.com/voxpupuli/puppet-jira/compare/v3.2.0...v3.2.1)

**Fixed bugs:**

- Set tomcat\_protocol\_ssl based on jira version if undef [\#225](https://github.com/voxpupuli/puppet-jira/pull/225) ([markleary](https://github.com/markleary))

## [v3.2.0](https://github.com/voxpupuli/puppet-jira/tree/v3.2.0) (2017-10-10)

[Full Changelog](https://github.com/voxpupuli/puppet-jira/compare/v3.1.0...v3.2.0)

**Implemented enhancements:**

- Issue \#215 - Disable user, need to update spec tests [\#223](https://github.com/voxpupuli/puppet-jira/pull/223) ([cyberious](https://github.com/cyberious))
- add acceptance tests on ubuntu 14.04 [\#222](https://github.com/voxpupuli/puppet-jira/pull/222) ([bastelfreak](https://github.com/bastelfreak))
- Add $tomcat\_protocol\_ssl paramater for compatibility with Jira \>= 7.3. [\#219](https://github.com/voxpupuli/puppet-jira/pull/219) ([markleary](https://github.com/markleary))
- replace validate\_\* with datatypes [\#212](https://github.com/voxpupuli/puppet-jira/pull/212) ([bastelfreak](https://github.com/bastelfreak))

**Closed issues:**

- Error: /Stage\[main\]/Jira::Install/Archive\[/tmp/atlassian-jira-software-7.2.3.tar.gz\]/ensure: change from absent to present failed: Download file checksum mismatch [\#173](https://github.com/voxpupuli/puppet-jira/issues/173)

**Merged pull requests:**

- Fix \#206 rubocop failures [\#207](https://github.com/voxpupuli/puppet-jira/pull/207) ([sacres](https://github.com/sacres))

## v3.1.0 (2017-01-13)

This is the last release with Puppet 3 support!
- modulesync with latest Vox Pupuli defaults
- Exposes checksum_verify in init.pp w/ conditional
- Allow JIRA to run in OpenJDK
- Make 'check-java.sh' Management Optional
- Bump puppet minimum version_requirement to 3.8.7
- Move 'check-java.sh' to Templates
- Fix rubocop issue in config_spec test.
- Bump minimum version dependencies (for Puppet 4)
- Remove OpenJDK Comments, use vanilla check-java.sh
- Remove extraneous comma in config.pp.
- Add Docker acceptance tests for travis

## v3.0.1 (2016-11-23)
### Summary
- Atlassian doesn't provide checksums, add checksum_verify false.
- Update README

### Fixes
- Fix checksum verification as Atlassian doesn't provide checksums
- Fix Atlassian End of Support for versions < 6.1 , amend jira_install_spec.rb to reflect that

### Improvements
- Amend README to clarify default deploy module
- modulesync with latest Vox Pupuli defaults

## v3.0.0 (2016-10-04)
### Summary
- Change pool_test_on_borrow default to false in init class :: As this alters init class, requires MAJOR release
- Add access log format variable to init :: as this also hits init class, MAJOR release
- Update README

### Fixes
- Fix Download - version 7.1.9 and up
- Incompatible listeners server.xml > version 7
- Fix missing pool_test_on_borrow in dbconfig.mysql.xml.erb

### Improvements
- modulesync with latest Vox Pupuli defaults

## v2.1.0 (2016-09-08)
### Summary
- modulesync with latest Vox Pupuli defaults

## Improvements
- Add hiera support for catalina_opts

### Fixes
- Service status is not working when using init scripts
- Fix JIRA 7.1.x download URL

## v2.0.0 (2016-05-26)
### Summary
- We dropped ruby1.8 support!
- mkrakowitzer-deploy got replaced by puppet-archive.
- The jira::facts class is included by default. You may get a Error: Duplicate declaration: Class[jira::facts] is already declared
- We added JIRA 7 Support

### Improvements
- Use defined function to test for the existence of the fact jira_ver
- Added hieradata examples for Oracle DB backend
- Added containment for mysql_connector class
- Support STRICT_VARIABLES=yes
- Paramaterizing more tomcat settings
- Added schema parameter for dbconfig
- Added configuration option to enable or disable websudo.
- Added tests and updated README.md
- Support configuration of all properties in jira-config.properties
- Added crowd single sign-on functions as described by atlassian wiki
- Added ability to change tomcatShutdownPort

### Fixes
- Fix to address Amazon Ami configuration
- Avoid duplicate scheme declaration when using proxy with SSL
- Fix jira::mysql_connector_url


## v1.3.0 (2015-08-05)
### Summary
- Add SSL Support #76
- Resolve issue where rake lint tasks always exited with 0 status
- added new parameter disable_notifications in relation to setenv.sh
- Add examples


## v1.2.1 (2015-04-25)
### Summary
- Update metadata, README, CHANGELOG to point to new namespace.
- Update .travis.yml to auto deploy tagged versions


## v1.2.0 (2015-04-16)
- Issue #51 Make the jira users shell configurable
- Add a notify and subscribe options to the jira service
- Added oracle to db input validator
- Turn on the AJP connector based on a hiera or puppet-variable lookup
- Added Microsoft SQL Server support
- Include jira::facts class by default.
- Adding new feature generating a content.xml configuration
- Add a notify and subscribe options to the jira service
- Provide ability to set the bind address of Tomcat via the jira::tomcatAddress parameter
- Bump jira version to 6.4.1

Thanks to Scott Searcy, Oliver Bertuch, Paul Geringer, Eric Shamow, William Lieurance, Doug Neal for their contributions.


## v1.1.5 (2014-01-21)
- Add beaker tests for MySQL
- Added support for Oracle and Scientific Linux
- Bump jira version to 6.3.13
- Add support for parameter 'contextpath'
- Add class to install MySQL Java connector from mysql.com
- Add support for oracle database

Thanks to  Oliver Bertuch  for his contributions.


## v1.1.4 (2014-01-17)
- Parameterize the lockfile variable in the init script
- Autoinstall MySql Connector/J Driver
- Add parameter stop_jira
- Fix bug on RHEL7 where updating the systemd script does not take effect without refreshing systemd

Thanks to MasonM for his contributions


## v1.1.3 (2014-11-17)
- Refactor beaker tests to that they are portable and other people can run them
- Remove unnecessary comments from init.pp
- Dont cleanup jira tar.gz file when using staging module.
- Add/Remove beaker nodesets
  - Add CentOS 7 nodeset
  - Remove ubuntu 1004 and Debian 6 nodeset
- Add support for systemd style init script on RedHat/CentOS 7


## v1.1.2 (2014-10-19)
- Add new parameter: jvm_permgen, defaults to 256m.
- Updates to readme


## v1.1.1 (2014-10-11)
- Fix typo of in module nanliu-staging, preving module from being installed


## v1.1.0 (2014-10-09)
- Add beaker tests for Ubuntu/Centos/Debian
- Issue #3 Handle updating of Jira

### Summary
Resolve Issue #29
- Add external fact for running version of JIRA.
- Replace mkrakowitzer-deploy with nanliu-staging as the default module to deploy jira files


## v1.0.1 (2014-10-01)

### Summary
Update the README file to comply with puppetlabs standards
- https://docs.puppetlabs.com/puppet/latest/reference/modules_documentation.html
- https://docs.puppetlabs.com/puppet/latest/reference/READMEtemplate.markdown

#### Bugfixes
- None


\* *This Changelog was automatically generated by [github_changelog_generator](https://github.com/github-changelog-generator/github-changelog-generator)*
