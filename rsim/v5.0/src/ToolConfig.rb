"""
# Description
ToolConfig, this object stores specifically configurations for this tool,
it is different with the ui, which process user inputs, while this object
will define and infer some implicit tool options according to ui
"""
class ToolConfig

	# hash that stores the common dirs used by the tool
	# [:out] => the out path
	# [:logs] => log home path
	# [:configs] => home path for different configs
	# [:components] => home path for different components
	attr_accessor :commonDirs;

	attr_accessor :stem;
	def initialize(ui) ##{{{
		initStem;
		initDirs(ui);
	end ##}}}
public
	## place public methods here
private
	## place private methods here

	"""
	initStem, initialize the stem variable, currently not support from ui, just from ENV['STEM']
	"""
	def initStem ##{{{
		raise UserException.new("no Env variable: STEM specified") unless ENV.has_key?('STEM');
		@stem = ENV['STEM'];
		Rsim.mp.debug("getting STEM(#{@stem})");
	end ##}}}

	## initDirs(ui), initialize the dir paths according to ui, if no user specified,
	# then use a default value, else use user specified.
	def initDirs(ui); ##{{{
		@commonDirs={};
		@commonDirs[:out]        = File.join(@stem,'out');
		@commonDirs[:logs]       = File.join(@stem,'out/logs');
		@commonDirs[:configs]    = File.join(@stem,'out/configs');
		@commonDirs[:components] = File.join(@stem,'out/components');
		#TODO, user overrides.
		# puts "#{__FILE__}:(initDirs(ui)) is not ready yet."
	end ##}}}
end