//
//  config.swift
//  vdt
//
//  Created by huangqi on 2022/1/14.
//

import Foundation

class Options {

	enum optionName : String,CaseIterable {
		case srcFile = "-s";
		case genFile = "-o";
		case unknown = "<unknown>";
	}


	static func match(_ argv: String) -> optionName {
		for stdOption in optionName.allCases {
			if argv == stdOption.rawValue {
				return stdOption;
			}
		}
		return .unknown;
	}
}

class ProgramConfig {

	var srcFileName : String = "";
	var genFileName : String = "default.v";
	
	init (_ argvs: [String]) {
		var i: Int32 = 0;
		for argv in argvs {
			switch (Options.match(argv)) {
				case .srcFile:
					srcFileName = argvs.remove(at:i);
				case .genFile:
				default:
					print ("unknown option detected");
			}
			i+=1;
		}
	}
	
	func userOptionParse() {
	
	}
	
	func getSrcName() -> String {
		return srcFileName;
	}
	
	func getGenName() -> String {
		return genFileName;
	}
}
