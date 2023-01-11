module top;
	initial begin
		#500ns;
		$display($time,"test top run success");
		#500ns;
		$finish;
	end
endmodule
