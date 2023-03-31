"""
by using this can declare a sequence object which stores and has ability to build
a sequence file
# key features of this object
## setup user configurations
*rand*
specify a random field of this seq.
*body*
return a here-doc that can be added to the sequence's body method directly.
*finalize*
## publish a sequence
*publish*
call to publish sequence codes, requires information:
- the sequence name;
- base, the base sequence name where this derived from;
- fields of this sequence, which are random qualified;
- body executions;
"""

require 'svClass.rb'
class Seq < SVClass
	attr_accessor :pseqr;
	def initialize(cn,bn,d)
		super(cn,:object,d);
		@pseqr = '';@basename = bn;
		setupbody;
	end

	# user called method to define a random field of this seq
	def randscalar(ft,v)
		ft=ft.to_s; v=v.to_s;
		field(:scalar,ft,v);
		@fields[v].qualifier= 'rand';
	end
	# executed by seq declaration, 
	# get execution code for body customized by users.
	def body &block
		code = block.call;
		@methods['body'].procedure(code);
		return;
	end

	def setupbody
		task('body','','virtual');
	end

	def publish(path)
		cnts = publishCode;
		buildfile(path,cnts);

	end

	def finalize
		finalizeSVClass;
	end
end