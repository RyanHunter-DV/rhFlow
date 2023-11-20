require 'generators/GeneratorBase'

"""
default generator, use the original files to generate the filelist.
"""
class DefaultGenerator < GeneratorBase

	def initialize(old=nil) ##{{{
		super('DefaultGenerator',old);
	end ##}}}
public
	## place public methods here

	"""
	build, api to build up the generator by different options set by config
	home -> the home path arg
	"""
	def build(home) ##{{{
		# @option.get;
		#puts "#{__FILE__}:(build) not ready yet."
	end ##}}}

	## run(home), execute the command that build by generator.
	def run(home) ##{{{
		
		puts "#{__FILE__}:run(home) not ready yet."
	end ##}}}
private
	## place private methods here
end
