<<<<<<< HEAD:demos/features/resets/reset.feature
## feature based on ruby language
## reset.feature
## this file should be included by a component which is going to use this feature.
##
=======
## each feature file will encapsulated as an API function and will called by component which invoked
## to generate a standard HDL file.
## using ruby based language
## fully support of ruby language
>>>>>>> d31ac641e47a2de37423fce38dba308ec182c9ce:metaFlowVersion/demos/features/resets/reset.feature

class ResetFeature < Feature; ## {
	
	def feature name, &block; ## {
		super(name);
	end ## }

	def setResetType type; ## {
		@resetType = type;
	end ## }


	def resetSignals **signalPairs ## {
	end ## }

	## publish reset feature to RTL
	def publish &block ## {
		instance_exec self,&block;
		RTLString = '';
		if not @sensitive.empty
			RTLString = 'always @ ('+@sensitive+') begin'
			verilog RTLString;
		end

		publish

	end ## }

end ## }

## 
def resetFeature &block; ## {
	reset = ResetFeature.new 'reset';
	reset.publish &block;
end ## }


