#! /usr/bin/env ruby
require 'rhload';
$LOAD_PATH << File.dirname(File.dirname(File.absolute_path(__FILE__)));

rhload 'lib/MainEntry'

##rhload 'src/design/node'
component :dcache do
	fileset 'src/design/dir/*.v','test.list'
	fileset 'src/design/dir1/*.v','test.list'
	## compopt :xlm,'-f test.list'
	compopt :xlm,'-sv','-64bits'
	simopt  :xlm,'+VERBOSITY=2020'
end

##component :dcacheVerif do
##	fileset 'test_pkg.sv','test.list'
##end

config :dcacheRTL do
	component :dcache
	compopt :xlm,'-sv'
	simopt  :xlm,'+UVM_TESTNAME=basic_test'
end

c = ConfigPool.find :dcacheRTL;
puts "#{c.compopts :xlm}"
puts "#{c.simopts :xlm}"

p = Publisher.new($root);
s = Xcelium.new(p);
s.build(:dcacheRTL)

test :ATest do
	config :dcacheRTL
end

s.sim(:ATest);
