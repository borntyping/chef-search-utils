chef-search-utils
=================

`chef-search-utils` is a chef cookbook that provides several utility functions that make using Chef search easier. By default, searches are restricted to the current environment, and make use of `partial_search` so that searches use a minimum of resources.

Requirements
------------

Uses the [partial_search](http://community.opscode.com/cookbooks/partial_search) cookbook.

Usage
-----

Depend on this cookbook in your cookbooks `metadata.rb`:

	depends 'search-utils'

The `search_*` functions will now be availible in recipes:

	# A single FQDN, raising an error if no nodes or multiple nodes are found
	chef_server_host = search_fqdn(:recipe => 'chef-server')

	# A list of FQDNs matching nodes with the 'postgres' recipe
	database_hosts = search_fqdns(:recipe => 'postgres')

	# A list of nodes with the 'webserver' role
	webservers = search_nodes(:role => 'webserver')

The functions can also be used from template resources:

	template "/tmp/test" do
		variables({
			:database_servers => search_fqdns(:role => 'my_database_role')
		})
	end

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

Licence
-------

Copyright (c) 2014 Sam Clements

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

Authors
-------

* [Sam Clements](https://github.com/borntyping)
