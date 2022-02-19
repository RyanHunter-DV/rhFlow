## this file is a database for vdt, all information will be stored here
module DB ##{

    @designs = Hash.new();

	## register a new design into @designs hash with the key=name
	def self.addNewDesign obj ##{{{
		@designs[obj.name] = obj;
	end ##}}}

	## expand block
	def self.expandDesign obj,block ##{{{
		if not @designs.has_key?(obj.name)
			puts "FATAL, design not registered !!!"
			return;
		end
		@designs[obj.name].expand(block);
	end ##}}}

	def self.getDesign name ##{{{
		return @designs[name] if @designs.has_key?(name);
		return nil;
	end ##}}}

end ##}