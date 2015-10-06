# CHANGELOG for et_cassandra

## [v4.6.0] (2015-10-06)

### Changes

* Enable Server Side Encryption for S3 backups
* Use s3cmd instead of boto-s3put to upload backup files (so that we can enable SSE)
* New kitchen-ec2 yaml format

### Fixes

* Move cassandra backups recipe to the end of the run list (in kitchen cloud)
* In mocking/test mode, populate seed list with just our own machine (so the cluster will start)

## [v4.5.15] (2015-09-02)

### Fixes

* Backup lifecycle resource needs node FQDN in its name

## [v4.5.14] (2015-09-02)

### Fixes

* Mocking boolean was keeping lifecycles from being set. Reverse that logic.

## [v4.5.13] (2015-09-02)

### Fixes

* Set the repair job by WEEKDAY not by DAY

## [v4.5.12] (2015-08-19)

### Fixes

* Make directories for LOG, STARTUP_LOG, PIDFILE, and MONITOR_PIDFILE in datastax-agent init script

## [v4.5.11] (2015-08-19)

### Fixes

* Install both cassandra and dsc21 packages at the same time
* Remove dsc21 pin serverspec test
* Run the repair job weekly and on an AZ-dependent day-of-week
* Stop using apt_preference pinning (it does not do what we want)
* Use -pr flag instead of -par for keyspace repair

## [v4.5.10] (2015-08-17)

### Fixes

* Delete old cassandra jobs with dashes in the names

## [v4.5.9] (2015-08-17)

### Fixes

* Use packge "dsc21" rather than "cassandra"
* Repair jobs now runs at 4:20 UTC, not 1:20 (fix the tests)
* Fix some overloaded filenames in the cassandra fake data cookbook
* Add cassandra_seed to the roles list (so that cassandra is willing to start up without real cluster-mates to talk to)
* Run the backups recipe last during testing
* Don't bother running the fake data recipe
* Pin the cassandra package version using apt-preferences

## [v4.5.8] (2015-08-13)

### Fixes

* Add -p and -t flags to cron job logger commands

## [v4.5.7] (2015-08-12)

### Fixes

* Put skip_keyspaces in the snapshots config file and add the OpsCenter keyspace to the list

## [v4.5.6] (2015-08-12)

### Fixes

* Exempt some keyspaces from snapshots and backups

## [v4.5.5] (2015-08-12)

### Fixes

* Pipe cron job output to logger (to cut down on the spam)

## [v4.5.4] (2015-08-10)

### Fixes

* Un-disable cassandra_daily_repair job

## [v4.5.3] (2015-08-10)

### Fixes

* Repair script should say that it is waiting 2 hrs
* Run the backups recipe during testing add a mocking mode to prevent it from hitting S3
* Add a cookbook to create fake data
* Rework how the repair script decides to move on to the next keyspace

## [v4.5.2] (2015-07-29)

### Fixes

* Disable repair job until we can figure out why it doesn't space correctly

## [v4.5.1] (2015-07-29)

### Fixes

* Move repair cron job from 1am to 4am utc
* Add missing sleep delay to repair cron job

## [v4.5.0] (2015-07-29)

### Changes

* Add cassandra repair job
* Don't bother test converging the backups recipe (too much internal data is needed to make it work)

## [v4.4.0] (2015-07-24)

### Changes

* Add options to Cassandra package install to always keep our configs, avoiding the need for manual intervention

## [v4.3.0] (2015-07-24)

* Merge in changes from the v3.x branch

## [v4.2.0] (2015-07-17)

### Changes

* OpsCenter and DataStax Agents are now set to a specific version
* The OpsCenter & DataStax Agent services are now restarted upon a new version being installed

## [v4.1.13] (2015-07-16)

### Fixes

* Properly delete old backup/snapshot files

## [v4.1.12] (2015-07-16)

### Fixes

* Use underscores instead of dashes in the cron jobs

## [v4.1.11] (2015-07-15)

### Fixes

* Bounce datastax-agent if the /etc/default file is updated
* Only put our own IP in the seed_ips list if we are actually a seed node
* Fix all of the things that are broken about the datastax-agent init script (by shipping our own)

## [v4.1.10] (2015-07-15)

### Fixes

* Take the spaces out of the cron job names

## [v4.1.9] (2015-07-15)

### Fixes

* Include node fqdn in backup storage location prefix

## [v4.1.8] (2015-07-14)

### Fixes

* Switch to cron_d resource (because cron sux)

## [v4.1.7] (2015-07-14)

### Changes

* Add cron jobs for the backups
* Change the upload path of the snapshot tool to differentiate from incremental backups
* Add incremental backup uploading script

## [v4.1.6] (2015-07-14)

### Fixes

* More snapshot script tweaks

## [v4.1.5] (2015-07-14)

### Fixes

* in snapshot tool: cd to data dir before building tarball
* Fix root_dir path in snapshot tool

## [v4.1.4] (2015-07-14)

### Fixes

* Minor fixes to the snapshot script

## [v4.1.3] (2015-07-14)

### Fixes

* Major fixes to the snapshot script and a change to the output directory structure

## [v4.1.2] (2015-07-13)

### Fixes

* Bad reference to snapshot creds data bag

## [v4.1.1] (2015-07-13)

### Changes

* attribute-ize snapshot credentials data bag source

## [v4.1.0] (2015-07-13)

### Changes

* Add a backup/snapshot script

### Fixes

* Properly handle non-existent ephemeral storage
* Make sure our own IP address is in the seed_ips list
* Use `node['ipaddress']` as the listen_address instead of localhost
* Trivial linting-related changes
* Add some sane rubocop exceptions

## [v4.0.0] (2015-07-13)

### Changes

* Bump Cassandra to version 2.1.8

## [v3.2.0] (2015-07-24)

### Changes

* Create a backup lifecycle management resource
* Allow backup/snapshot scripts to set the S3 region

### Fixes

* Explicitly install boto

## [v3.1.1] (2015-07-21)

* Fix bad flag order in incremental upload script

## [v3.1.0] (2015-07-16)

* Hotfix branch to ship a bunch of stuff without bumping cassandra to 2.1.8

## [v3.0.1] (2015-07-09)

### Changes

* enable incremental_backups

## [v3.0.0] (2015-05-06)

### Changes

* Upgrading cassandra to 2.1.5

## [v2.1.4] (2015-04-27)

### Changes

* Place logging on ec2 ephemeral storage if available
* Give cloud tests their own suite name

## [v2.1.3] (2015-03-23)

### Fixes

* Increase `ulimit` for the `cassandra` user

## [v2.1.2] (2015-03-17)

### Fixes

* Fix determination of C* seed on first convergence of the first node of a new C* ring
    - Assumes this first node is the seed, to avoid Chef Searches returning no results & ending up with a lack of seeds (which C* does not like)

## [v2.1.1] (2015-03-16)

### Fixes

* Make Chef search results Chef 12.1.1 compatible
* Make test data more realistic

## [v2.1.0] (2015-03-03)

### Changes

* Keep Opscenter and DataStax Agent up-to-date
* Add warning if trying to use cookbook with Chef < 12

## [v2.0.1] (2015-02-27)

### Fixes

* Fix typo in `cassandra-env.sh` template

## [v2.0.0] (2015-02-27)

### Fixes

* Correct ownership for DataStax Agent config
    - On nodes without OpsCenter installed, previous ownership would not work

### Changes

* Upgrade to Cassandra 2.1.3
* Refactor topology search discovery to directly correlate to AWS regions & AZs

## [v1.5.1] (2015-03-13)

### Fixes

* Backport fixes from v2.x:
    * Ensure stronger ciphers are available to Java
    * Add warning that this cookbook requires Chef 12
    * Ensure Opscenter & DataStax Agent are up-to-date
    * Add missing double quote to end of cassandra-env.sh template
    * Fix ownership for DataStax Agent config
* Backport fixes from `eherot/chef_12_compatibility` branch:
    * Make Chef search results Chef 12.1 compatible
    * Make the test data more realistic

## [v1.5.0] (2015-02-06)

### Fixes

* Ensure JEMalloc is hooked up properly in C* env config

### Changes

* Add ability to specify any `JVM_OPTS` via an attribute

## [v1.4.0] (2015-01-29)

### Changes

* Use a symlink to consolidate `datastax-agent` configs
* Ensure OpsCenter’s logs are all world-readable

## [v1.3.1] (2015-01-29)

### Fixes

* Update `cassandra-env.sh` for Cassandra 2.1.2

## [v1.3.0] (2015-01-29)

### Fixes

* Remove duplicate config attribute causing topology config to fail

### Changes

* Upgrade to Cassandra 2.1.2

## [v1.2.11] (2015-01-29)

### Fixes

* Add additional code to deal with race conditions related to the first convergence of the first node of a new cluster.

## [v1.2.10] (2015-01-29)

### Fixes

* Set `endpoint_snitch` to `GossipingPropertyFileSnitch` to ensure we use custom topology settings
    - Without this, Cassandra does its own DC naming & creation

## [v1.2.9] (2015-01-29)

### Fixes

* Fix assignment of multiple IPs to single AZ in topology
* Fix addition of current node’s IP to topology to avoid duplicate entries

## [v1.2.8] (2015-01-29)

### Fixes:

* Fix Chef search syntax for roles

## [v1.2.7] (2015-01-26)

### Changes:

* Ensure Berksfile is uploaded to Chef Server

## [v1.2.6] (2015-01-15)

### Fixes:

* Fix notification of `service[datastax-agent]` upon changes to its config

## [v1.2.5] (2015-01-15)

### Fixes:

* Fix topology configs to include the current node as well as all other nodes

## [v1.2.4] (2015-01-15)

### Fixes:

* Add missing topology config file to fully, properly, configure Cassandra

## [v1.2.3] (2015-01-14)

### Fixes:

* DataStax Agent was not being configured before, now we manage the configuration
    - This will require beefing up, but for now, it does the bare minimum
* Fix some test assertions & make them more consistent
* Use booleans for some Ruby → YAML output
* Use same roles as might be used in prod for testing

## [v1.2.2] (2015-01-12)

### Fixes:

* Ensure OpsCenter cluster config directory exists
* Ensure `service[opscenterd]` exists in the resource collection, regardless of whether its actually acted upon, using `only_if` guards.

## [v1.2.1] (2015-01-09)

### Fixes:

* OpsCenter cluster configuration is only set up on the OpsCenter master
* OpsCenter master config is also now only installed/set up on the OpsCenter master

## [v1.2.0] (2015-01-08)

### Changes:

* Install `jemalloc` package, as per @glennlprimmer, for better `malloc` handling
* Provide simple method for dependent packages to be easily installed before Cassandra via an attribute
* Add comments as headers of Chef-managed config files
    - Avoids people hacking files manually, then being confused when their changes disappear
* Add installation of OpsCenter with default values
    - Configurable via attributes

## [v1.1.0] (2015-01-07)

### Fixes:

* Fix heap settings to have proper defaults
* Ensure Cassandra user has a home folder, for logs etc. during service startup

### Changes:

* Clean up how seeds’ IPs are determined (h/t to @eherot)
* Provide attributes for overriding automatic heap settings
* Ensure Cassandra restarts once, during the first convergence, to pick up all updated configs & settings
    - This allows us to switch that attribute later, and control a Cassandra restart via a Chef convergence
* Use the Oracle JDK instead of OpenJDK (h/t to @glenlprimmer)
* Clarify Serverspec assertions’ wording

## [v1.0.0] (2015-01-05)

### Changes:

* Initial release:
    - Installs & provides for the configuration of a basic Cassandra node
    - A great many config options are still hard-wired to the defaults provided by Cassandra
    - Many, however, can be configured via attributes

[v2.1.1]: https://github.com/evertrue/et_cassandra/compare/v2.1.0...v2.1.1
[v2.1.0]: https://github.com/evertrue/et_cassandra/compare/v2.0.1...v2.1.0
[v2.0.1]: https://github.com/evertrue/et_cassandra/compare/v2.0.0...v2.0.1
[v2.0.0]: https://github.com/evertrue/et_cassandra/compare/v1.5.0...v2.0.0
[v1.5.1]: https://github.com/evertrue/et_cassandra/compare/v1.5.0...v1.5.1
[v1.5.0]: https://github.com/evertrue/et_cassandra/compare/v1.4.0...v1.5.0
[v1.4.0]: https://github.com/evertrue/et_cassandra/compare/v1.3.2...v1.4.0
[v1.3.2]: https://github.com/evertrue/et_cassandra/compare/v1.3.1...v1.3.2
[v1.3.1]: https://github.com/evertrue/et_cassandra/compare/v1.3.0...v1.3.1
[v1.3.0]: https://github.com/evertrue/et_cassandra/compare/v1.2.11...v1.3.0
[v1.2.11]: https://github.com/evertrue/et_cassandra/compare/v1.2.10...v1.2.11
[v1.2.10]: https://github.com/evertrue/et_cassandra/compare/v1.2.9...v1.2.10
[v1.2.9]: https://github.com/evertrue/et_cassandra/compare/v1.2.8...v1.2.9
[v1.2.8]: https://github.com/evertrue/et_cassandra/compare/v1.2.7...v1.2.8
[v1.2.7]: https://github.com/evertrue/et_cassandra/compare/v1.2.6...v1.2.7
[v1.2.6]: https://github.com/evertrue/et_cassandra/compare/v1.2.5...v1.2.6
[v1.2.5]: https://github.com/evertrue/et_cassandra/compare/v1.2.4...v1.2.5
[v1.2.4]: https://github.com/evertrue/et_cassandra/compare/v1.2.3...v1.2.4
[v1.2.3]: https://github.com/evertrue/et_cassandra/compare/v1.2.2...v1.2.3
[v1.2.2]: https://github.com/evertrue/et_cassandra/compare/v1.2.1...v1.2.2
[v1.2.1]: https://github.com/evertrue/et_cassandra/compare/v1.2.0...v1.2.1
[v1.2.0]: https://github.com/evertrue/et_cassandra/compare/v1.1.0...v1.2.0
[v1.1.0]: https://github.com/evertrue/et_cassandra/compare/v1.0.0...v1.1.0
[v1.0.0]: https://github.com/evertrue/et_cassandra/compare/07f3ba8...v1.0.0
