if node[:deploy].attribute?(:matchmaker)

	Chef::Log.info("Should deploy matchmaker")
	
	def print_pair(parent, myHash)
		myHash.each {|key, value|
			value.is_a?(Hash) ? print_pair(key, value) :
				Chef::Log.info("parent=#{parent.nil? ? 'none':parent}, (#{key}, #{value})")
		}
	end
	
	print_pair(nil,node)
end