## a feature that can select specific output according to many inputs and conditions
## define a feature
## assemble a feature



feature :arbitorFeature do ##{

	## define a new action for this arbitor feature
	## featureAction :condition do ##{
	## 	## according to different input conditions, select different output
	## end ##}

	## initialize steps
	description = ""
	## detailed signal names will be added while instantiating this feature
	## this will be declared in def feature signals = SignalClass.new(), seqblock = SequentialBlock.new(signals)

	class << signals
		def self.setCondition condition, bundle, name='<null>' ##{
			## if no name specified, then use condition string as its name
		end ##}

		def self.getConditionPairs ## {
		end ## }
	end

	featureLanguage :verilog

	sequentialBlock :blockName0 do ## {
		blockType :always ## default is :always
		resetType :async ## :none/:sync
		action :arbitor do ## {
			condition :if, signals.getConditionPairs
		end ## }
	end ## }

	## class << seqblock ##{
	## 	def self.publish ##{
	## 		self.enableReset :async
	## 		self.genRTL :always
	## 		self.genRTL :if, signals.getAllConditions
	## 		self.genRTL :blockend
	## 	end ##}
	## end ##}

	## seqblock.publish

end ##}


