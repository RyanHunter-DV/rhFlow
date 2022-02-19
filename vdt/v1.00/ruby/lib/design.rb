## this file defines global methods for declaring/using design features
## and so as the class DesignModule

require 'lib/database'
require 'lib/feature'
require 'lib/signal'

class DesignModule ##{
	@blocks;
	attr :name;
	attr :features;
	attr :signals;
	attr :instances; ## type is DesignModule
	attr :featureRegistry;

    def initialize name,block ##{{{
		@blocks = Array.new();
		@blocks.push(block);
		@name = name;

		## init
		@features = Hash.new();
		@signals  = Hash.new();
		@instances= Hash.new();
		@featureRegistry = FeatureRegistry.new();
	end ##}}}

	def expand block ##{{{
		@blocks.push(block);
	end ##}}}

	def elaborate ##{{{
		@blocks.each do ##{
			|b|
			## execute within design scope
			self.instance_exec &b;
		end ##}
	end ##}}}

	def addFeature ft ##{{{
		## simply overwrite now
		@features[ft.name] = ft;
		puts "adding feature of #{ft.name}"
		getFeatureRegistry.instance_exec do
			define_singleton_method ft.name.to_sym do
				return ft.value;
			end
		end
	end ##}}}

	def addSignal sig ##{{{
		if @signals.has_key?(sig.name)
			puts "ERROR: signal already registered, ignored"
			return;
		end
		@signals[sig.name] = sig;
	end ##}}}

	def getFeatureRegistry
		return @featureRegistry;
	end

end ##}

## by calling this method, will create a new DesignModule class instance, and stores block
## into that class, also, if the named design has already been declared, then added block to that
## registered DesignModule instance.
def design name, &block ##{{{
	#1. check named design in database, or create a new one
	designObj = DB.getDesign(name);
	if designObj==nil
		designObj = DesignModule.new(name,block);
		DB.addNewDesign(designObj);
	else
		DB.expandDesign(designObj,block);
	end
end ##}}}
