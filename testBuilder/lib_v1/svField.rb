class SVField
	attr_accessor :type;

	attr :debug;
	attr :codeline;
	def initialize(t,d,*args) ##{{{
		@type=t;@debug=d;
		message = "#{t}Setup".to_sym;
		self.send(message,*args);
	end ##}}}

	def rawSetup(line) ##{{{
		@debug.print("setup raw, line: #{line}");
		@codeline = line;
	end ##}}}


	def code(u) ##{{{
		message = "#{u}Codes".to_sym;
		return self.send(message);
	end ##}}}
	def instanceCodes ##{{{
		return [@codeline] if @type==:raw;
	end ##}}}

end