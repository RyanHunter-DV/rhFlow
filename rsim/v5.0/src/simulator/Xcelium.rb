require 'simulator/Simulator'

class Xcelium < Simulator

	## API: initialize, 
	def initialize ##{{{
		targets = ['filelist','compiler','elaborator','runner'];
		targets.each do |t|
			self.send("setup#{t.capitalize}".to_sym);
		end
	end ##}}}

public

private

	## API: setupFilelist, to setup the filelist object for this simulator
	def setupFilelist ##{{{
		f = Filelist.new();

		f.option('incdir','-incdir ')
		# for vcs: f.option('incdir','+indcir+')
		#TODO

		filelist(f);
	end ##}}}

end