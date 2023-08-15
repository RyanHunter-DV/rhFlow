class SimulatorOption

	attr :options;

	## API: initialize, 
	def initialize ##{{{
		@options={};
		#TODO
	end ##}}}

public

	## API: option(name,val=nil), if val!=nil, then set option to specified name,
	# else if val==nil, then return the option of the name
	def option(name,val=nil) ##{{{
		return @options[name] if val==nil;
		@options[name]=val;
		return;
	end ##}}}

private

end

class SimulatorFilelistOption < SimulatorOption

	## API: initialize, 
	def initialize ##{{{
		super();
	end ##}}}

end

class SimulatorCompileOption < SimulatorOption
	
end

class Simulator

	attr :filelist;
	attr :compile;
	attr :elab;
	attr :run;

	## API: initialize, 
	def initialize ##{{{
		#TODO
	end ##}}}

	## API: filelist(o=nil), if input o is nil, then return current filelist object
	# else update the filelist object.
	def filelist(o=nil) ##{{{
		return @filelist if o==nil;
		@filelist = o;
	end ##}}}
end

