`ifndef rh_axi4_drvBase__svh
`define rh_axi4_drvBase__svh
class rh_axi4_drvBase#(type REQ=rh_axi4_trans,RSP=REQ) extends uvm_driver#(REQ,RSP);
	
	`uvm_component_utils_begin(rh_axi4_drvBase)
	`uvm_field_object(mobj,UVM_NOCOMPARE)
	`uvm_field_int(i,UVM_ALL_ON)
	`uvm_component_utils_end
	function new(string name="rh_axi4_drvBase");
		super.new(name);
	endfunction
	function void build_phase(uvm_phase phase); // {
		super.build_phase(phase);
		
	endfunction // }
endclass
`endif
