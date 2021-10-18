## regSignals class is a built-in class for all features, but user can manually define
## it's attributes based on ruby language.

## 
## if elseBranch: ## {
## 	verilog "else begin // {";
## ## }
## else: ## {
## 	verilog "begin // {";
## ## }
## 
## ## enhancement: verilogIf regSignals.writeEnable+'==1';
## verilog "if ("+regSignals.writeEnable+"==1) begin // {"
## sequentialAssign regSignals.mem[regSignals.writePointer],regSignals.writeData
## ## sequentialIncr signal,[step]
## ## step is optional, default value is 1
## sequentialIncr regSignals.writePointer
## verilog "end // }"
## 
## verilog "if ("+regSignals.readEnable+"==1) begin // {";
## sequentialAssign regSignals.readData, regSignals.mem[regSignals.readPointer];
## sequentialIncr regSignals.readPointer;
## verilog "end // }";

<<<<<<< HEAD:demos/features/fifo/fifo.feature
=======
if elseBranch ## {
	verilog "else begin // {";
## }
else ## {
	verilog "begin // {";
end ## }
>>>>>>> d31ac641e47a2de37423fce38dba308ec182c9ce:metaFlowVersion/demos/features/fifo/fifo.feature


<<<<<<< HEAD:demos/features/fifo/fifo.feature
=======
verilog "if ("+regSignals.readEnable+"==1) begin // {";
sequentialAssign regSignals.readData, regSignals.mem[regSignals.readPointer];
sequentialIncr regSignals.readPointer;
verilog "end // }";


>>>>>>> d31ac641e47a2de37423fce38dba308ec182c9ce:metaFlowVersion/demos/features/fifo/fifo.feature
