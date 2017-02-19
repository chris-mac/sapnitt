Jenkins Plugin Fetcher
=====================

This fetcher allows you to download and install a Jenkins plugin and its dependencies.
The script accepts two args:
1. plugin name in lower case
2. version number (latest is not supported)

##Notes:

- There is an assumption that it is always safer to go higher in dependency version i.e. >= rather than ==.
- We do not install optional dependencies
- We are using an old way of scraping the MANIFEST file for dependencies instead of direct to the json feed available, it involves lots of sed, grep, trim etc.
- There is no clean error handling- if we fail half way through we may end up in an indeterminate state- it is only really suitable for spawning new instances rather than a way to manage an existing production Jenkins.
- We may need to fix up cyclic dependencies by bumping to lastest versions, we could even always go to lastest as a default.
 
