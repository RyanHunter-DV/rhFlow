require 'optparse';

class UserInterface

	attr_accessor :steps;
	attr_accessor :stepOpts;
	def initialize() ##{{{
		@steps=[];@stepOpts={};
		Rsim.mp.debug("setup node step");
		setupNodeStep;
		OptionParser.new do |opts|
			opts.on('-b','--build=CONFIG','to build a specified config') do |v|
				setupStep(:build,:config=>v);
			end
			opts.on('-c','--compile=CONFIG','to compile a design that has been built') do |v|
				setupStep(:compile,:config=>v);
			end
			opts.on('-r','--run=TEST','to run a test directly') do |v|
				setupStep(:run,:test=>v);
			end
			opts.on('-bc','--build_compile=CONFIG','to build then compile the specified config') do |v|
				setupStep(:build,:config=>v);
				setupStep(:compile,:config=>v);
			end
			opts.on('-bcr','--build_compile_run=TEST','to build, compile then run the specified test') do |v|
				setupStep(:build,:test=>v);
				setupStep(:compile,:test=>v);
				setupStep(:run,:test=>v);
			end
			opts.on('-rg','--regression=TAG','to start a regression') do |v|
				setupStep(:regr,:tag=>v);
			end
		end.parse!
	end ##}}}

public
# TODO, step APIs for other components.

private

	def setupNodeStep ##{{{
		initNodes = ENV['RSIM_INIT'];
		if initNodes
			initNodes = initNodes.split(';');
			setupStep(:rhload,:node=>initNodes);
		else
			setupStep(:rhload);
		end
	end ##}}}

	def mergeOpts(ovrd,orig) ##{{{
		merged=ovrd.dup;
		orig.each_pair do |o,v|
			if merged.has_key?(o)
				merged[o] = [merged[o]] unless merged[o].is_a?(Array);
				merged[o] << v;
			else
				merged[o] = v;
			end
		end
		return merged;
	end ##}}}
	def setupStep(sname,opts={}) ##{{{
		sname=sname.to_sym;
		@steps << sname;
		if @stepOpts.has_key?(sname)
			@stepOpts[sname] = mergeOpts(opts,@stepOpts[sname]);
		else
			@stepOpts[sname] = opts;
		end
	end ##}}}
	
end
