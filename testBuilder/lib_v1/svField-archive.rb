# **description** #
# a ruby class that presents all sv fields, including scalar, and array types
#
class SVField
	attr :datatype; # :scalar,:queue,:class,:darray,:sarray,:aarray
	attr :fieldtype; # type of the field
	attr :indextype; # specific for :aarray (associative array
	attr :name;
	attr :size; # for sarray
	attr :default;


	attr_accessor :qualifier;
	def initialize(dt,*args)
		@datatype = dt.to_sym;
		message = "init#{@datatype.to_s}".to_sym;
		self.send(message,*args);
		@qualifier = '';
	end

	def initqueue(*args)
		ft=args[0];vn=args[1];
		@fieldtype = ft.to_s;
		@name = vn.to_s;
	end
	def initclass(*args)
		tn=args[0];vn=args[1];d=args[2];
		@fieldtype = tn.to_s;
		@name   = vn.to_s;
		@default= d.to_s if d!=nil;
		@default= nil if d==nil;
	end

	def initaarray(*args)
		fn=args[0],ft=args[1],it=args[2];
		@fieldtype = ft.to_s;
		@indextype = it.to_s;
		@name = fn.to_s;
	end

	# scalar field definition:
	# SVField.new(:scalar,'fieldtype','fieldname','[default]')
	def initscalar(*args)
		tn=args[0];vn=args[1];d=args[2];
		@fieldtype = tn.to_s;
		@name   = vn.to_s;
		@default= d.to_s if d!=nil;
		@default= nil if d==nil;
	end

	def code(u)
		return self.send(u.to_sym);
	end
	def instance
		line = '';
		line += "#{@qualifier} " if @qualifier;
		line += "#{@fieldtype} #{@name}";
		if @datatype==:queue
			line+='[$]';
		elsif @datatype==:darray
			line+='[]';
		elsif @datatype==:sarray
			line+="[#{@size}]";
		elsif @datatype==:aarray
			line+="[#{@indextype}]";
		end
		return line+';';
	end

	def utils
		#TODO, return code for `uvm_field_*
	end
end
