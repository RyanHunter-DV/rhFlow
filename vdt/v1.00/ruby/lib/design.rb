## this file defines global methods for declaring/using design features
## and so as the class DesignModule

require 'lib/database'

class DesignModule ##{
	@blocks;
	attr :name;
    def initialize name,block ##{{{
		@blocks = Array.new();
		@blocks.push(block);
		@name = name;
	end ##}}}

	def expand block ##{{{
		@blocks.push(block);
	end ##}}}
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