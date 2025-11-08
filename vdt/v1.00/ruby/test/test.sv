always @(posedge iClk or negedge iReset) begin // {
	if (iWe==1'b1) begin // {
		wPtr<=wPtr+1'b1
	end // }
end // }
