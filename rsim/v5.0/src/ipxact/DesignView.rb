class DesignView < MetaData

	attr :comps;
	attr :nodes;
	def initialize ##{{{
		# format: @comps['instname']=componentObject
		@comps={};

		# format: @nodes['location']=Proc
		@nodes={};
		#TODO
	end ##}}}

public

	## instance, the instance command will instantiate certain components into the DesignView object.
	## So the Design object will not contain any component directly, the view will include those
	## components instead.
	def instance(opts={}) ##{{{
		#TODO
	end ##}}}
	

	## API: elaborate, to elaborate component instances in this view.
	def elaborate ##{{{
		@nodes.each_pair do |loc,b|
			#TODO, can enhance following codes.
			begin
				self.instance_eval &b;
			rescue => e
				msg = "Error detected in elaborate\n";
				msg+= "node location: #{loc}\n";
				msg+= "message: ";
				Rsim.mp.error("#{msg}#{e.message}");
				return Rsim::FAILED;
			end
		end
	end ##}}}

private

end
