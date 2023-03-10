require "exceptions.rb"
require "builder.rb"

#TODO
class MainEntry

	def initialize
	end

	def run
		sig = 0;
		begin
			Builder.setup(xxx)
			Builder.loadSource(file)
			Builder.finalize(xxx)
			Builder.publish(xxx)
		rescue RunException => e
			e.process;
		end
		return sig;
	end
end