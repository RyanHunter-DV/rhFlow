"""	
Object connections
"""	
require 'ipxact/DesignView'

class Design < MetaData
	"""
	Description, for the ipxact design concept, created while user calls a global design method
	public APIs
	- elaborate, called by metadata, which is a database to eval the user blocks, such as declare a new design view
	- view, command called while evaling the user block, to build a new DesignView, register in Design and elaborate it
	immeidiately.
	- TODO.
	"""
	
	attr :views;
	# format: @comps['componentname']=object
	attr :comps;

	attr_accessor :name;

	def initialize(n) ##{{{
		# format: @views['viewname'] = viewobject.
		@views={};
		@name = n;
	end ##}}}
public

	## view, build a DesignView within the certain design, a specific view will have
	## certain component instances.
	def view(name,opts={},&block) ##{{{
		parent = nil;
		parent = findView(name,opts[:clones]) if opts.has_key?(:clones);
		v = DesignView.new(name,parent);
		v.addBlock(&block);
		v.elaborate;
		@views[v.name] = v;
	end ##}}}


	## API: elaborate, to eval the blocks in different view, will eval blocks where it
	## stored.
	def elaborate ##{{{
		#TODO, not used, elaborateComponentsIncluded;
		@views.each_pair do |n,o|
			o.elaborate;
		end
		#TODO
	end ##}}}

private

	# according to the given name, to find and return the view object in current @views.
	# sview -> used for report error, where view block this findView is called
	# name -> the target view name want to found.
	def findView(sview,name) ##{{{
		name = name.to_sym;
		return @views[name] if @views.has_key?(name);
		raise NodeException.new("the parent view(#{name}) not exists of view(#{sview})");
		return nil;
	end ##}}}

	#TODO, to be deleted, ## API: elaborateComponentsIncluded, to elaborate the components within this design, duplicated
	#TODO, to be deleted, ## components in different views, will only elaborated once.
	#TODO, to be deleted, def elaborateComponentsIncluded ##{{{
	#TODO, to be deleted, 	comps.each_pair do |n,o|
	#TODO, to be deleted, 		o.elaborate;
	#TODO, to be deleted, 	end
	#TODO, to be deleted, end ##}}}

end

def design(name,&block) ##{{{
	d=Rsim.find(:design,name);
	if d==nil
		d=Design.new(name);
		Rsim.register(:design,d);
	end
	d.addBlock(block);
end ##}}}
