"""
The base ipxact object type, the MetaData, all ipxact data model inherits from this
class.
"""
class MetaData
	attr_accessor :vlnv;

public
	def initialize(name) ##{{{
		@vlnv = name;
	end ##}}}

private

end
