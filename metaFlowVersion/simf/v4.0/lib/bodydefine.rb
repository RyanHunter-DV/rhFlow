class BodyDefine
	"""
	body for component/config/test etc definition
	"""
	attr_accessor :body;
	attr_accessor :location;
	def initialize b
		@location = b.source_location.join(',');
		@body = b;
	end
end
