## this file is a database for vdt, all information will be stored here
module DB ##{

    @designs = Hash.new();

	## register a new design into @designs hash with the key=name
	def self.addNewDesign obj ##{{{
		@designs[obj.name] = obj;
	end ##}}}

	## expand block
	def self.expandDesign obj,ft,block ##{{{
		if not @designs.has_key?(obj.name)
			puts "FATAL, design not registered !!!"
			return;
		end
		@designs[obj.name].expand(block);
		if ft.is_a?(Hash) and (not ft.empty?)
			@designs[obj.name].__addFeaturesFromHash ft
		end
	end ##}}}

	def self.getDesign name ##{{{
		return @designs[name] if @designs.has_key?(name);
		return nil;
	end ##}}}


	## call this method by vdt main to elaborate all designs existing in @designs
	def self.elaborate ##{{{
		@designs.each_value do #{
			|v|
			v.elaborate
		end #}
	end ##}}}

end ##}

## to define a method with the name of the design, by calling thie defined method
## it can call to instantiate a design instance into the caller
def createNewDesignMethod de ##{{{
	define_method de.name.to_sym do
		|inst,&b|
		if not self.is_a?(DesignModule)
			puts "Error, a deisng must be instantiated within a design"
			return;
		end
		self.instantiate inst,de
		if b!=nil
			de.instanceExecution inst, b
		end
	end
end ##}}}
