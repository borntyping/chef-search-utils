chef-search-utils
=================

`chef-search-utils` is a chef cookbook that provides several utility functions that make using Chef search easier. By default, searches are restricted to the current environment, and make use of `partial_search` so that searches use a minimum of resources.

Requirements
------------

Uses the [partial_search](http://community.opscode.com/cookbooks/partial_search) cookbook.

Usage
-----

Depend on this cookbook in your cookbooks `metadata.rb`:

```ruby
depends 'search-utils'
```

The `search_*` functions will now be availible in recipes:

```ruby
# A single FQDN, raising an error if no nodes or multiple nodes are found
chef_server_host = search_fqdn(:recipe => 'chef-server')

# A list of FQDNs matching nodes with the 'postgres' recipe
database_hosts = search_fqdns(:recipe => 'postgres')

# A list of nodes with the 'webserver' role
webservers = search_nodes(:role => 'webserver')
```

The functions can also be used from template resources and templates:

```ruby
template "/tmp/test" do
	variables({
		:database_servers => search_fqdns(:role => 'my_database_role')
	})
end
```

```erb
<%= search_fqdn(:recipe => 'find-dev') %>
```

All of the node search functions restrict searches to the current `chef_environment`. If you need to search across all environments, use `:chef_environment => *`.

Functions
---------

#### search_to_string

	search_to_string(:recipe => 'chef-client', :chef_environment => 'staging')
	=> "recipe:chef-client AND chef_environment:staging"

#### search_nodes

Equivalent to `partial_search`, with `:chef_environment` set to `node.chef_environment` by default.

	search_nodes({:recipe => 'chef-server'}, {:keys => {"fqdn" => ['fqdn']}})

#### search_fqdns

Does a partial search, only fetching the FQDNs of matching nodes.

	search_fqdns(:recipe => 'webserver')
	=> ['one.example.com', 'two.example.com']

#### search_fqdn

Returns the FQDN of the single matching node, raising an error if zero or multiple nodes match:

	search_fqdn(:role => 'graphite')
	=> 'graphite.example.com'

Authors
-------

* [Sam Clements](https://github.com/borntyping)
