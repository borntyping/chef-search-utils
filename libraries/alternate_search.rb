#
# Cookbook Name:: alternate_search
# Library:: alternate_search
#
# Copyright 2014, Sam Clements
#

module SearchUtils
	# Returns a single node FQDN matching a Hash search,
	# raising an error if zero or multiple nodes are found
	def search_fqdn(search)
		nodes = search_fqdns(search)

		if nodes.empty? or nodes.nil?
			raise "search_fqdns(#{search.inspect}) returned no results"
		elsif nodes.length > 1
			raise "search_fqdns(#{search.inspect}) returned multiple results"
		end

		nodes.first["fqdn"]
	end

	# Returns a list of node FQDNs matching a Hash search
	def search_fqdns(search)
		search_nodes(search, {:keys => {"fqdn" => ['fqdn']}})
	end

	# Searches for nodes using partial_search
	#
	# The search will be restricted to the current environment by default
	#
	# @param search [Hash] Passed to search_to_string
	# @param options [Hash] Options to pass to partial_search
	def search_nodes(search, options={}, &block)
		unless search.has_key? :chef_environment
			search[:chef_environment] = node.chef_environment
		end
		partial_search(:node, search_to_string(search), options, &block)
	end

	# Coerces a 'attribute => value' Hash into a search string
	#
	# @param search [Hash] An {attribute => value} hash to coerce
	def search_to_string(search)
		search.map {|k,v| "#{k}:#{v}"}.join(' AND ')
	end
end

# Use search functions in recipes
class Chef::Recipe
	include SearchUtils
end

# Use search functions in template resources
class Chef::Resource::Template
	include SearchUtils
end
