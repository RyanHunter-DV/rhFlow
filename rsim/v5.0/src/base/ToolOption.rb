"""
# Object description
This object used to store options to call the simulator by user nodes, or setup and translate
a unified option name into different option format according to different simulator.
add: api to add options for the certain tool.
Available for both generator tools and simulator tools
"""
class ToolOption

	attr :options;
	attr :formats;

	## API: initialize, 
	def initialize ##{{{
		@formats={};
		@options=[];
	end ##}}}

public

	## get(u=:option), get the option list or format hash according to the given arg.
	# u-> usage, default is getting options, but can getting formats by calling like:
	# option.get(:format)
	def get(u=:option); ##{{{
		return @options if u==:option;
		return @formats;
	end ##}}}

	## add(*args), add multiple strings as options that will be stored in @options
	# call examples:
	# option.add '-f filelist','-a',...
	# option.add '-b',
	def add(*args); ##{{{
		args.each do |arg|
			@options << arg;
		end
		#puts "#{__FILE__}:(add(*args)) is not ready yet."
	end ##}}}

	# if no val give, then this api is called to return the pre-stored option format for this tool, else
	# it will store a new format for given name
	# example:
	# option.format('incdir','+incdir+') -> store
	# option.format('incdir') -> '+incdir+'
	def format(name,val=nil) ##{{{
		name = name.to_sym;val=val.to_s;
		return @formats[name] if val==nil;
		@formats[name]=val;
		return;
	end ##}}}

private

end

#class SimulatorFilelistOption < SimulatorOption
#
#	## API: initialize, 
#	def initialize ##{{{
#		super();
#	end ##}}}
#
#end