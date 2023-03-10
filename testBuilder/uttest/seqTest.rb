#! /usr/bin/env ruby

$thisPath = File.dirname(File.absolute_path(__FILE__));
$libPath  = File.join(File.dirname($thisPath),"lib_v1");
$LOAD_PATH << $libPath;

require 'seq.rb'

def loadSource()
	seq :SimpleTestSeq0,:BaseSeq do
		rand :int,'equalVar'
		rand :logic,'insideVar'
		body do
			<<-CODE.gsub(/\s*-/,'')
			-	TestTrans trans=new("t");
			-	trans.randomize() with {
			-		transVar0 == equalVar;
			-		transVar1 == insideVar;
			-	};
			CODE
		end
	end
end


def main()
	loadSource();
end

main();
exit 0;