
require 'svParams.rb'
require 'svField.rb'
require 'svMethod.rb'
require 'fileOperator.rb'
require 'codeGenerator.rb'


class SVClass
	attr_accessor :classname;
	attr_accessor :basename;
	attr_accessor :filename;
	attr_accessor :fields;
	attr_accessor :methods;
	attr_accessor :params;
	attr_accessor :tparams;
	attr_accessor :uvmtype;
	attr_accessor :utils;

	attr :debug;
	attr :fop;

	def initialize(cn,uvmt=:object,d) ##{{{
		@debug=d;@uvmtype=uvmt;@classname=cn;
		@filename = @classname+'.svh';
		@filename[0..0]=@filename[0..0].downcase;
		@debug.print("filename: #{@filename}");
		@fields={};@methods={};@utils={};
		builtins;
	end ##}}}

	def builtins ##{{{
		newBuiltin;
		if @uvmtype==:component
			phaseBuiltin('build');
			phaseBuiltin('connect');
			phaseBuiltin('run');
		end
	end ##}}}
	# FIXME, need update for more detailed features
	def getUtilsFieldType(t,ft,it='') ##{{{
		r='';
		if t==:scalar
			r='int' if /^int/=~ft or /^bit/=~ft or /^logic/=~ft;
		elsif t==:class
			r='object';
		elsif t==:darray
			r = 'array_';
			r+='int' if /^int/=~ft or /^bit/=~ft or /^logic/=~ft;
		elsif t==:sarray
			r='sarray_';
			r+='int' if /^int/=~ft or /^bit/=~ft or /^logic/=~ft;
		elsif t==:queue
			r='queue_';
			r+='int' if /^int/=~ft or /^bit/=~ft or /^logic/=~ft;
		elsif t==:aarray
			r='aa_';
			r+='int_' if /^int/=~ft or /^bit/=~ft or /^logic/=~ft;
			r+='int' if /^int/=~it or /^bit/=~it or /^logic/=~it;
			r+='string' if /^string/=~it;
		else
			return 'unknown'
		end
		return r;
	end ##}}}
	def setupUtilsFields ##{{{
		@utils['utils_field']=[];
		@fields.each_pair do |n,f|
			t = getUtilsFieldType(f.type,f.fieldtype,f.indextype);
			nf = SVField.new(:raw,@debug,%Q|`uvm_field_#{t}(#{f.name},UVM_ALL_ON)|);
			@utils['utils_field'] << nf;
		end
		return;
	end ##}}}
	def setupUtils ##{{{
		line = %Q|`uvm_#{@uvmtype}_utils_begin(#{@classname}|;
		params = '';
		params += "#{@tparams.params.join(',')}" if @tparams;
		params += "#{@params.params.join(',')}" if @params;
		line+= %Q|#(#{params})| if params!='';
		line+= ')';
		f = SVField.new(:raw,@debug,line);
		@utils['utils_begin'] = f;

		setupUtilsFields;

		line = %Q|`uvm_#{@uvmtype}_utils_end|;
		f = SVField.new(:raw,@debug,line);
		@utils['utils_end'] = f;
	end ##}}}
	# setup constructor
	def newBuiltin ##{{{
		a = %Q|string name="#{@classname}"|;
		a+= %Q|,uvm_component parent=null| if @uvmtype==:component;
		m = SVMethod.new(:func,@debug,@classname,'new',a,'');
		c = %Q|\tsuper.new(name|;
		c+= %Q|,parent| if @uvmtype==:component;
		c+= %Q|);|;
		m.procedure(c);
		@methods['new'] = m;
	end ##}}}
	def phaseBuiltin(pn) ##{{{
		t = :func;
		t = :task if pn=='run';
		mn = "#{pn}_phase";
		m = SVMethod.new(t,@debug,@classname,"#{pn}_phase",'uvm_phase phase');
		m.qualifier= 'virtual';
		m.procedure(%Q|\tsuper.#{mn}(phase);|);
		@methods[mn] = m;
	end ##}}}

	def base(bn) ##{{{
		@basename = bn;
	end ##}}}
	def param(*args) ##{{{
		@params = SVParams.new(:param,@debug) unless @params;
		args.each do |pair|
			@params.add(pair);
		end
	end ##}}}
	def tparam(*args) ##{{{
		@tparams = SVParams.new(:tparam,@debug) unless @tparams;
		args.each do |pair|
			@tparams.add(pair);
		end
	end ##}}}

	# fields commands {
	# format:
	# field :scalar, 'int', 'ia'
	def field(t,*args) ##{{{
		@debug.print("*args: #{args}");
		f = SVField.new(t,@debug,*args);
		@fields[f.name] = f;
	end ##}}}

	def svclass(ft,vn) ##{{{
		vn=vn.to_s;ft=ft.to_s;
		field(:class,ft,vn);
	end ##}}}
	def scalar(ft,vn) ##{{{
		vn=vn.to_s;ft=ft.to_s;
		field(:scalar,ft,vn);
	end ##}}}
	def sarray(ft,vn,s) ##{{{
		field(:sarray,ft,vn,s);
	end ##}}}
	def darray(ft,vn) ##{{{
		field(:darray,ft,vn);
	end ##}}}
	def aarray(ft,vn,it) ##{{{
		field(:aarray,ft,vn,it);
	end ##}}}
	def queue(ft,vn) ##{{{
		field(:queue,ft,vn);
	end ##}}}

	# format:
	# task 'name','args'
	def task(n,a,q='',&block) ##{{{
		@debug.print("task called: #{n}");
		m = SVMethod.new(:task,@debug,@classname,n,a);
		m.qualifier= q if q!='';
		if block_given?
			@debug.print("to call block: #{block.source_location}");
			#code = self.instance_eval &block;
			code = block.call;
			@debug.print("get code: #{code}");
			codes = code.split("\n");
			codes.map!{|l| "\t"+l;};
			m.procedure(codes.join("\n"));
		end

		@debug.print("getting method: #{n}");
		@methods[n.to_s] = m;
	end ##}}}

	# format:
	# func 'name','args','rtn',[q], &block
	def func(n,a,r,q='',&block) ##{{{
		m = SVMethod.new(:func,@debug,@classname,n,a,r);
		m.qualifier= q if q!='';
		code = block.call;
		@debug.print("get code: #{code}");
		codes = code.split("\n");
		codes.map!{|l| "\t"+l;};
		m.procedure(codes.join("\n"));
		@debug.print("getting method: #{n}");
		@methods[n.to_s] = m;
	end ##}}}

	# }

	def publishCode ##{{{
		codes = [];
		cg = CodeGenerator.new(@debug);

		codes.append(*cg.filemacro(@filename));
		tps = '';ps='';
		tps = @tparams.pairs.join(',') if @tparams;
		ps  = @params.pairs.join(',') if @params;
		codes.append(*cg.declareClass(@classname,tps,ps,@basename));

		@fields.each_value do |f|
			codes.append(*(f.code(:instance).map!{|l| "\t"+l;}));
		end
		codes.append(*@utils['utils_begin'].code(:instance).map!{|l|"\t"+l;});
		@utils['utils_field'].each do |f|
			codes.append(*(f.code(:instance).map!{|l| "\t\t"+l;}));
		end
		codes.append(*@utils['utils_end'].code(:instance).map!{|l|"\t"+l;});

		@methods.each_value do |m|
			codes.append(*(m.code(:prototype).map!{|l| "\t"+l;}));
		end

		codes.append(*cg.declareClassEnd);
		codes << "\n\n";

		@methods.each_value do |m|
			codes.append(*m.code(:body));
		end

		codes.append(*cg.filemacroEnd);

		return codes;
	end ##}}}
	def buildfile(path,cnts) ##{{{
		@fop = FileOperator.new(path,@filename,@debug,:create=>true);
		@fop.writeContents(cnts);
	end ##}}}
	def finalizeSVClass ##{{{
		setupUtils;
	end ##}}}
end
