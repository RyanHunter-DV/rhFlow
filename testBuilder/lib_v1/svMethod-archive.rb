class SVMethod

	attr :procedures; # expressions within a method
	attr :type; #:func or :task
	attr :rtn; # return type

	attr_accessor :args; # string represent argument
	attr_accessor :name;
	# virtual,local,static etc. specified by user
	attr_accessor :qualifier;
	attr_accessor :container; # the class name who owns this method
	#t->type,n->name,a->args,r->return
	def initialize(t,n,a,r='void')
		@type = t.to_sym;
		@name = n.to_s;
		@args = a.to_s;
		@rtn  = r.to_s if @type==:func;
		@procedures=[];
	end

	def procedure(l)
		@procedures << l;
	end
	# add code segment to procedures
	# def segmentlines
	# 	# each of segment input is a long string which has manually defined codes,
	# 	# no need for extra operations
	# 	@procedures << lines;
	# end

	#:prototype,:body
	def code(u=:prototype)
		return self.send(u.to_sym);
	end

	def body
		cnts = [];
		if @type==:func
			line+="function #{@rtn}";
		else
			line+='task';
		end
		line+=" #{@container}::" if @container;
		line+="#{@name}(#{@args});"
		cnts << line;
		cnts.append(*@procedures) unless @procedures.empty?;
		return cnts;
	end

	def prototype
		line = "extern #{@qualifier}";
		if @type==:func
			line+= " function #{@rtn}"
		else
			line+= " task";
		end
		line+="#{@name}(#{@args});";
		return line;
	end

end