// this is an example for fifo feature
configure {
	DEPTH = 16 // if not specified by configure file, then use default 16
	WIDTH = 32
}


// use $configure$ to replace the value of configure among a concatenate string
name fifo$DEPTH$x$WIDTH$

// port is only used when a module is specified, so if keyword port appears in a feature file, the
// module will be automatically generated.
// port <name>, <width>, <direction>
// port <name>, <msb:lsb>, <direction>
port iClk,1,in
port iRstn,1,in



// following feature block is verilog source, can be an original verilog content(file), or a source
// verilog file(*.vsrc), both will converted to standard verilog file in buildflow.

// by the way, we can also use keyword file to include a standard verilog file into where the file
// is declared.

reg [WIDTH-1:0] mem[DEPTH-1:0];

always @(posedge iClk or negedge iRstn) begin // {
	if (~iRstn) begin // {
	// }
	end else begin // {
	end // }
end // }
