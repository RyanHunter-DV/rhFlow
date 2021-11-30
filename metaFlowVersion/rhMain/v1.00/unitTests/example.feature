## a feature that can select specific output according to many inputs and conditions
## define a feature
## assemble a feature



feature :arbitorFeature, :seqblock=>true do ##{

	## define a new action for this arbitor feature
	## featureAction :condition do ##{
	## 	## according to different input conditions, select different output
	## end ##}

	## initialize steps
	description = "example feature"
	## detailed signal names will be added while instantiating this feature
	## this will be declared in def feature signals = SignalClass.new(), seqblock = SequentialBlock.new(signals)

	## TODO, class << signals
	## TODO, 	def self.setCondition condition, bundle, name='<null>' ##{
	## TODO, 		## if no name specified, then use condition string as its name
	## TODO, 	end ##}
	## TODO, end


	## TODO, class << seqblock ##{
	## TODO, 	def self.publish ##{
	## TODO, 		self.selectRTLLanguage :verilog
	## TODO, 		self.enableReset :async
	## TODO, 		self.genRTL :always
	## TODO, 		self.genRTL :if, signals.getAllConditions
	## TODO, 		self.genRTL :blockend
	## TODO, 	end ##}
	## TODO, end ##}

	## TODO, seqblock.publish
	puts "#{__FILE__}, calling block of arbitorFeature definition"

end ##}


arbitorFeature do ## {
	puts "call block of invoking arbitorFeature"
end ## }

