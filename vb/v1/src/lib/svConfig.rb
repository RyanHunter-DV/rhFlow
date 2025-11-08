require 'codeGenerator.rb'
require 'svClass.rb'

class SVConfig < SVClass

	attr :path; # extra path for this driver

	def initialize(proj,ext,d) ##{{{
		@path  = './';
		cn = "#{proj}#{ext.capitalize}Config";
		super(cn,:object,d);
		@basename = 'uvm_object';
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

	def finalize ##{{{
		finalizeSVClass;
	end ##}}}

end
