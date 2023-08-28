## MessagePrinter class, used for information logging and debug.
class MessagePrinter
	attr_accessor :mode;
	attr_accessor :logh;
	def initialize(tool,mode=:debug) ##{{{
		@mode = mode; tool=tool.to_s;
		@logh = File.open(tool+'.log','w');
	end ##}}}

public
	## debug information, only used for developing mode.
	def debug(msg,display=true) ##{{{
		return if @mode != :debug;
		info(msg,display);
	end ##}}}

	## info will be logged into a log file.
	def info(msg,display=false) ##{{{
		#puts caller(1)[0];
		opts={:verbo=>:info,:pos=>caller(1)[1]};
		logMessage(msg,opts);
		printMessage(msg,opts) if display;
	end ##}}}

	## display when error appears
	# TODO
	def error(msg,opts={}) ##{{{
		display=true;
		opts[:verbo]=:error;
		printMessage(msg,opts);
	end ##}}}

private
	def logMessage(msg,opts={}) ##{{{
		@logh.write(processMessage(msg,opts)+"\n");
	end ##}}}
	def printMessage(msg,opts) ##{{{
		puts processMessage(msg,opts);
	end ##}}}
	def processMessage(msg,opts) ##{{{
		formatted = '';
		verbo = opts[:verbo].to_s.upcase;
		pos = false;
		pos = opts[:pos] if opts.has_key?(:pos);
		if pos==false
			formatted += %Q|[#{verbo}] #{msg}|;
		else
			formatted += %Q|[#{verbo}@#{opts[:pos]}] #{msg}|;
		end
		return formatted;
	end ##}}}

end
