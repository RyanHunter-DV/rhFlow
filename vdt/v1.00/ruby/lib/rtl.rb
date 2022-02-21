class VerilogSyntax; ##{
	attr :cnts;
	attr :isSeq;
	attr :indent;
	## return cnts according to input info
	def verilog type,&block ##{{{
		@cnts = Array.new();
		@indent = 0;
		if type==:sequential
			@isSeq = true;
		else
			@isSeq = false;
		end
		self.instance_exec &block;

		cntPush 'end // }',:dec if @isSeq;

		return @cnts;
	end ##}}}

	def sensitive str; ##{{{
		return if not @isSeq;
		line = 'always @('+str+') begin // {';
		cntPush line,:inc;
	end ##}}}

	## cindent: current indent flag
	## :inc -> incr 1 indent
	## :dec -> dec 1 indent
	## else -> nothing
	def cntPush str, ci=nil ##{{{
		line = '';
		## for dec, we need dec first, then print
		@indent-=1 if ci==:dec;
		(0..@indent).each do
			|i|
			line += "\t" if i>0;
		end
		line += str;
		@cnts.push(line);
		@indent+=1 if ci==:inc;
		return;
	end ##}}}

	## for combinational, :if is the typical assign lv = (cond)? rv format
	def condition type,cStr,oStr ##{{{
		case type
			when :if then
				_genSeqCondition :if,cStr,oStr if @isSeq;
			else
				puts "[ERROR] not supported type:#{type.to_s}"
		end
	end ##}}}

	private
	def _genSeqCondition type,cStr,oStr
		case type
			when :if then
				line = 'if ('+cStr+') begin // {'
				cntPush(line,:inc);
				line = oStr; cntPush(line);
				line = 'end // }'; cntPush(line,:dec);
			else
				puts "[ERROR] not supported type:#{type.to_s}"
		end
	end

end ##}

module RTL; ##{
	@@syntax = :verilog;

	def self.vs
		return VerilogSyntax.new();
	end

	def self.sequentialSelLogic clk,reset,opts ##{{{

		if @@syntax == :verilog
			cnts = vs.verilog :sequential do #{
				sensitive "posedge #{clk.name} or #{reset['edge']} #{reset['name'].name}";
				opts.each_pair do ##{
					|o,c|
					condition :if, c.to_s,o.to_s
				end ##}
			end #}
		else
			puts "not support other syntax except verilog"
		end

		return cnts;

	end ##}}}


end ##}



