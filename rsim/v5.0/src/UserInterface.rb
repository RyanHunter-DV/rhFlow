require 'optparse';

class UserInterface

	attr_accessor :steps;
	attr_accessor :stepOpts;
	attr_accessor :options;
	def initialize() ##{{{
		@steps=[];@stepOpts={};@options={};
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
			opts.on('-s','--stem=STEM','manually set the stem path') do |v|
				setpupOption(:stem,v,[:build]);
			end
		end.parse!
		setupMandatoryOptions;
	end ##}}}

public
# TODO, step APIs for other components.

private

	## API: setupMandatoryOptions, user not specified, need add a mandatory value
	def setupMandatoryOptions ##{{{
		setupOption(:stem,ENV['STEM'],[:build]) unless @options.has_key?(:stem);
		#TODO
	end ##}}}

	## API: setupOption(name,val), to setup an option available in local.
	def setupOption(name,val,steps=[]) ##{{{
		@options[name] = val;
		steps.each do |s|
			addStepOpts(s,name=>val)
		end
	end ##}}}

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
	## API: addStepOpts(sname,opts={}), add options to a certain step.
	def addStepOpts(sname,opts={}) ##{{{
		if @stepOpts.has_key?(sname)
			@stepOpts[sname] = mergeOpts(opts,@stepOpts[sname]);
		else
			@stepOpts[sname] = opts;
		end
	end ##}}}
	def setupStep(sname,opts={}) ##{{{
		sname=sname.to_sym;
		@steps << sname;
		addStepOpts(sname,opts);
	end ##}}}
	
end
