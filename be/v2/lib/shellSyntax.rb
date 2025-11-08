class ShellSyntax

	attr :shell;
	def initialize _s
		@shell = _s.to_sym;
	end

	def alias a,s,indent=''
		code = '';
		if @shell==:bash
			code = "alias #{a}='#{s}'";
		elsif @shell==:csh
			code = "alias #{a} '#{s}'";
		end
		return indent+code;
	end
	def setvar var,val,indent=''
		code = '';
		if @shell==:bash
			code = var+'='+val;
		elsif @shell==:csh
			code = 'set '+var+' = '+val;
		end
		return indent+code;
	end
	def setenv var,val,indent=''
		code = '';
		if @shell==:bash
			code = 'export '+var+'='+val;
		elsif @shell==:csh
			code = 'setenv '+var+' '+val;
		end
		return indent+code;
	end

	def condition c,indent=''
		code = '';
		if @shell==:bash
			code = %Q|if [ #{c} ]; then|;
		elsif @shell==:csh
			code = %Q|if ( #{c} ) then|;
		end
		return indent+code;
	end
	def conditione indent=''
		code = '';
		if @shell==:bash
			code = %Q|fi|;
		elsif @shell==:csh
			code = %Q|endif|;
		end
		return indent+code;
	end


end
