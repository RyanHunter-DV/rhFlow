require 'ipxact/DesignView'

class Design < MetaData
	
	attr :views;
	# format: @comps['componentname']=object
	attr :comps;
	def initialize ##{{{
		#TODO
		# format: @views['viewname'] = viewobject.
		@views={};
	end ##}}}
public

	## view, build a DesignView within the certain design, a specific view will have
	## certain component instances.
	def view(name,&block) ##{{{
		## TODO
	end ##}}}


	## API: elaborate, to eval the blocks in different view, will eval blocks where it
	## stored.
	def elaborate ##{{{
		elaborateComponentsIncluded;
		@views.each_pair do |n,o|
			o.elaborate;
		end
		#TODO
	end ##}}}

private

	## API: elaborateComponentsIncluded, to elaborate the components within this design, duplicated
	## components in different views, will only elaborated once.
	def elaborateComponentsIncluded ##{{{
		comps.each_pair do |n,o|
			o.elaborate;
		end
	end ##}}}

end
