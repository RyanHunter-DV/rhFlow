## each feature file will encapsulated as an API function and will called by component which invoked
## to generate a standard HDL file.
## using ruby based language
## fully support of ruby language

## regSignals[]


if useSensitive:
	verilog "always @(posedge iClk or negedge iRstn) begin";

## verilog is a self-defined method, in base feature flow
verilog "if (~Rstn) begin // {";
## sequentialAssign is a self-defined method, for non-blocking assignment.
for signal in regSignals: ##{
	## standardSequentialAssign signal;
	sequentialAssign signal.name,signal.getResetValue;
##}
verilog "end // }";


