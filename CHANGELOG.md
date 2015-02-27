# CHANGELOG for et_cassandra

## [v2.0.0] (2015-02-27)

### Fixes

* Correct ownership for DataStax Agent config
    - On nodes without OpsCenter installed, previous ownership would not work

### Changes

* Upgrade to Cassandra 2.1.3
* Refactor topology search discovery to directly correlate to AWS regions & AZs

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

[v2.0.0]: https://github.com/evertrue/et_cassandra/compare/v1.3.1...v2.0.0
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
