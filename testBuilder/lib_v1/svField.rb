class SVField
	attr_accessor :type;

	attr_accessor :fieldtype;
	attr_accessor :name;
	attr_accessor :size; #array size for sarray
	attr_accessor :indextype;
	attr_accessor :default;
	attr_accessor :qualifier;

	attr :debug;
	attr :codeline;
	def initialize(t,d,*args) ##{{{
		@type=t;@debug=d;
		message = "#{t}Setup".to_sym;
		@debug.print("*args: #{args}");
		@qualifier='';@indextype='';
		self.send(message,*args);
	end ##}}}

	def rawSetup(line) ##{{{
		@debug.print("setup raw, line: #{line}");
		@codeline = line;
	end ##}}}
	def scalarSetup(tn,vn,d=nil) ##{{{
		#tn=args[0];vn=args[1];d=args[2];
		@fieldtype = tn.to_s;
		@name   = vn.to_s;
		@default= d.to_s if d!=nil;
		@default= nil if d==nil;
	end ##}}}
	def queueSetup(ft,vn)
		@fieldtype = ft.to_s;
		@name = vn.to_s;
	end
	def classSetup(tn,vn,d=nil)
		#tn=args[0];vn=args[1];d=args[2];
		@fieldtype = tn.to_s;
		@name   = vn.to_s;
		@default= d.to_s if d!=nil;
		@default= nil if d==nil;
	end

	def aarraySetup(ft,fn,it)
		@fieldtype = ft.to_s;
		@indextype = it.to_s;
		@name = fn.to_s;
	end
	def sarraySetup(ft,fn,s)
		@fieldtype = ft.to_s;
		@size = s;
		@name = fn.to_s;
	end
	def darraySetup(ft,fn)
		@fieldtype = ft.to_s;
		@name = fn.to_s;
	end

	def code(u) ##{{{
		message = "#{u}Codes".to_sym;
		return self.send(message);
	end ##}}}
	def instanceCodes ##{{{
		line='';
		q="#{@qualifier} " if @qualifier!='';
		line = @codeline if @type==:raw;
		line = %Q|#{q}#{@fieldtype} #{@name}[#{@size}];| if @type==:sarray;
		line = %Q|#{q}#{@fieldtype} #{@name}[];| if @type==:darray;
		line = %Q|#{q}#{@fieldtype} #{@name}[$];| if @type==:queue;
		line = %Q|#{q}#{@fieldtype} #{@name}[#{@indextype}];| if @type==:aarray;
		expr = %Q|#{@name}|;expr+= " = #{@default}" if @default;
		line = %Q|#{q}#{@fieldtype} #{expr};| if @type==:scalar or @type==:class;
		return [line];
	end ##}}}

end