## this file defines global methods for declaring/using design features
## and so as the class DesignModule

require 'lib/database'
require 'lib/feature'
require 'lib/signal'
require 'lib/logical'

require 'lib/baseContainer'
require 'lib/component'

class DesignModule < BaseContainer; ##{
	attr :subDesigns; ## type is DesignModule
	attr :subComps; ## type is component


    def initialize name,ft,block ##{{{
		super(name,ft,block);
		## init
		@subDesigns = Hash.new();
		@subComps = Hash.new();
	end ##}}}


	def elaborate ##{{{
		@blocks.each do ##{
			|b|
			## execute within design scope
			self.instance_exec &b;
		end ##}
	end ##}}}

	def instantiate inst,c
		## TODO
		c.setParent self;
		if c.is_a?(DesignComponent)
			@subComps[inst.to_s] = c;
		else
		end
	end



end ##}

## by calling this method, will create a new DesignModule class instance, and stores block
## into that class, also, if the named design has already been declared, then added block to that
## registered DesignModule instance.
def design name,ft, &block ##{{{
	#1. check named design in database, or create a new one
	designObj = DB.getDesign(name);
	if designObj==nil
		designObj = DesignModule.new(name,ft,block);
		DB.addNewDesign(designObj);
	else
		DB.expandDesign(designObj,ft,block);
	end
end ##}}}
