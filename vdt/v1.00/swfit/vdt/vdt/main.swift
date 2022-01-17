//
//  main.swift
//  vdt
//
//  Created by huangqi on 2022/1/14.
//

import Foundation
import AppKit


func main() -> Int32 {
	var localSig : Int32 = 0;
	var argv : [String] = CommandLine.arguments;
	argv.remove(at:0);
	
	let config = ProgramConfig(argv);
	config.userOptionParse();
	let analyzer = VdtsAnalyzer(config);
	
	return localSig;
}


let SIG : Int32 = main();
print ("program finish");
exit(SIG);
