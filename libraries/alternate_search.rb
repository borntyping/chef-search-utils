#
# Cookbook Name:: alternate_search
# Library:: alternate_search
#
# Copyright 2014, Sam Clements
#
module SearchUtils
	# Returns the FQDN of a matching node, raising an error if multiple or no
	# nodes match
	def search_fqdn(search)
		fqdn = search_fqdn_optional(search)
		raise "search_fqdn(#{search.inspect}) returned no results" if fqdn.nil?
		fqdn
	end

	# Returns a single FQDN of a matching node, raising an error if multiple
	# nodes match or returning nil if no nodes match
	def search_fqdn_optional(search)
		fqdns = search_fqdns(search)

		if fqdns.length > 1
			raise "search_fqdns(#{search.inspect}) returned multiple results"
		end

		fqdns.first
	end

	# Returns a sorted list of node FQDNs matching a Hash search
	def search_fqdns(search)
		nodes = search_nodes(search, keys: { 'fqdn' => ['fqdn'] })
		nodes.map { |n| n['fqdn'] }.sort!
	end

	# Searches for nodes using partial_search
	#
	# The search will be restricted to the current environment by default
	#
	# @param search [Hash] Passed to search_to_string
	# @param options [Hash] Options to pass to partial_search
	def search_nodes(search, options = {}, &block)
		unless search.key? :chef_environment
			search[:chef_environment] = node.chef_environment
		end
		partial_search(:node, search_to_string(search), options, &block)
	end

	# Coerces a 'attribute => value' Hash into a search string
	#
	# @param search [Hash] An {attribute => value} hash to coerce
	def search_to_string(search)
		search.map { |k, v| "#{k}:#{v}" }.join(' AND ')
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
