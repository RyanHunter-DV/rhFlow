#! /usr/bin/env ruby

require '../src/MessagePrinter.rb';

def testd(msg) ##{{{
	puts "[TESTD] #{msg}";
end ##}}}

def main() ##{{{
	testd "starting test ...";
	mp = MessagePrinter.new('test',:debug);
	bk=0;
	mp.debug(%Q|test for debug, bk: #{bk}|,true);
	bk+=1;
	mp.info(%Q|test for info with debug, bk: #{bk}|,true);
	mp.mode=:normal;
	bk+=1;
	mp.info(%Q|test for info, bk: #{bk}|,true);
end ##}}}

main;
