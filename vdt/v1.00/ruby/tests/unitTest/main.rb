#! /usr/bin/env ruby
#

require '../../lib/config'
require '../../lib/analyzer'

def main; ## {
	config = ProgramConfig.new();
	config.srcFile= 'test.vdts'
	analyzer = VdtsAnalyzer.new(config);
	analyzer.analyzeSrc;
end ## }

main;
