require 'codeGenerator.rb'
require 'svClass.rb'

class SVSeq < SVClass

	attr :path; # extra path for this driver

	attr :pseqr;
	def initialize(proj,ext,d) ##{{{
		@path  = './';
		cn = "#{proj}#{ext.capitalize}Seq";
		super(cn,:object,d);
		@basename = 'uvm_sequence';
	end ##}}}

	# set extra path for this driver
	def path(p) ##{{{
		@path = p;
	end ##}}}
	def publish(r) ##{{{
		codes = publishCode;
		p = File.absolute_path(File.join(r,@path));
		@debug.print("publishing file: #{p}/#{@filename}");
		buildfile(p,codes);
	end ##}}}
	def childExtraCode ##{{{
		l = %Q|`uvm_declare_p_sequencer(#{@pseqr})|;
		return [l] if @pseqr;
		return [];
	end ##}}}

	def finalize ##{{{
		finalizeSVClass;
	end ##}}}

	def pseqr(seqr) ##{{{
		pseqr = seqr;
	end ##}}}

	# add body code
	def body(&block) ##{{{
		task 'body','','virtual';
		code = block.call;
		codes = code.split("\n");
		codes.map!{|l| "\t"+l;};
		@methods['body'].procedure(codes.join("\n"));
	end ##}}}

end
