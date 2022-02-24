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
	## RTL contents of logic operations
	## also has instances
	attr :logicCnts;
	## RTL contents of signal declarations
	attr :signalCnts;


    def initialize name,ft,block ##{{{
		super(name,ft,block);
		## init
		@subDesigns = Hash.new();
		@subComps   = Hash.new();
		@logicCnts  = Array.new();
		@signalCnts = Array.new();
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
			## design instance
			@subDesigns[inst.to_s] = c;
		end
	end

	def getInstanceConnections inst ##{{{
		connects = Hash.new();
		@signals.each_pair do
			|n,s|
			connects[n] = s.connections[inst+'.'+s.name].name;
		end
		return connects;
	end ##}}}

	def publishLocalLogics; ##{{{
		@logics.each do
			|l|
			@logicCnts.push l.publish
		end
	end ##}}}

	def publishComponents; ##{{{
		@subComps.each_pair do
			|i,c|
			@logicCnts.push (c.publish i);
		end
	end ##}}}

	def publishDesignInstances; ##{{{
		## TODO
		@subDesigns.each_pair do ##{
			|i,d|
			connects = d.getInstanceConnections i
			@logicCnts.push RTL.designInstance d.name,i,connects;
		end ##}
	end ##}}}


	def publishSignals; ##{{{
		## TODO
	end ##}}}

	def publishRefinement; ##{{{
		## TODO
	end ##}}}


	## generating RTL codes/files of this design, step of publish is:
	## 1.publish local logics
	## 2.publish subComps which may contain logics
	## 3.publish design instance, to generate instance code
	## 4.publish signals
	## 5.inferring, according to the published RTL code.
	## 6.publish design accordingly, to publish the dependant design
	def publish ##{{{
		publishLocalLogics if not @logics.empty?;
		publishComponents if not @subComps.empty?;
		publishDesignInstances if not @subDesigns.empty?;
		publishSignals if not @signals.empty?;
		publishRefinement;
		## this might be controled by user options, publishDependencies;
		puts "[DEBUG]"
		@logicCnts.each do
			|line|
			puts line;
		end
	end ##}}}


end ##}

## by calling this method, will create a new DesignModule class instance, and stores block
## into that class, also, if the named design has already been declared, then added block to that
## registered DesignModule instance.
def design name,ft=nil, &block ##{{{
	if not self.is_a?(Object);
		puts "Error, a design must be declared in global"
		return;
	end
	#1. check named design in database, or create a new one
	designObj = DB.getDesign(name);
	if designObj==nil
		designObj = DesignModule.new(name,ft,block);
		DB.addNewDesign(designObj);
		createNewDesignMethod(designObj);
	else
		DB.expandDesign(designObj,ft,block);
	end
end ##}}}
