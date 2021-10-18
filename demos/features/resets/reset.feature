## feature based on ruby language
## reset.feature
## this file should be included by a component which is going to use this feature.
##

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


