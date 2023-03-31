# a class for storing env instance information and getting env configuration
# codes
class EnvInst

	attr :debug;
	attr :configs;
	attr :instname;
	def initialize(n,d)
		@debug = d;
		@configs=[];
		@instname=n;
	end

	# called by user, to record config information
	def config(*args)
		args.each do |expr|
			@configs << "#{@instname}."+expr;
		end
	end

	def configCode ##{{{
		@configs.map!{|l| "\t"+l+";";};
		return @configs;
	end ##}}}
end