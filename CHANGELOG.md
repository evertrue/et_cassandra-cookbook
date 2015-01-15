# CHANGELOG for et_cassandra

## v1.2.6 (2015-01-15)

Bugs:

* Fix notification of `service[datastax-agent]` upon changes to its config

## v1.2.5 (2015-01-15)

Bugs:

* Fix topology configs to include the current node as well as all other nodes

## v1.2.4 (2015-01-15)

Bugs:

* Add missing toplogoy config file to fully, properly, configure Cassandra

## v1.2.3 (2015-01-14)

Bugs:

* DataStax Agent was not being configured before, now we manage the configuration
    - This will require beefing up, but for now, it does the bare minimum
* Fix some test assertions & make them more consistent
* Use booleans for some Ruby → YAML output
* Use same roles as might be used in prod for testing

## v1.2.2 (2015-01-12)

Bugs:

* Ensure OpsCenter cluster config directory exists
* Ensure `service[opscenterd]` exists in the resource collection, regardless of whether its actually acted upon, using `only_if` guards.

## v1.2.1 (2015-01-09)

Bugs:

* OpsCenter cluster configuration is only set up on the OpsCenter master
* OpsCenter master config is also now only installed/set up on the OpsCenter master

## v1.2.0 (2015-01-08)

Improvements:

* Install `jemalloc` package, as per @glennlprimmer, for better `malloc` handling
* Provide simple method for dependent packages to be easily installed before Cassandra via an attribute
* Add comments as headers of Chef-managed config files
    - Avoids people hacking files manually, then being confused when their changes disappear
* Add installation of OpsCenter with default values
    - Configurable via attributes

## v1.1.0 (2015-01-07)

Bugs:

* Fix heap settings to have proper defaults
* Ensure Cassandra user has a home folder, for logs etc. during service startup

Improvements:

* Clean up how seeds’ IPs are determined (h/t to @eherot)
* Provide attributes for overriding automatic heap settings
* Ensure Cassandra restarts once, during the first convergence, to pick up all updated configs & settings
    - This allows us to switch that attribute later, and control a Cassandra restart via a Chef convergence
* Use the Oracle JDK instead of OpenJDK (h/t to @glenlprimmer)
* Clarify Serverspec assertions’ wording

## v1.0.0 (2015-01-05)

* Initial release:
    - Installs & provides for the configuration of a basic Cassandra node
    - A great many config options are still hard-wired to the defaults provided by Cassandra
    - Many, however, can be configured via attributes
