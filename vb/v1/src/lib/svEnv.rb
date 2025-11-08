require 'codeGenerator.rb'
require 'svClass.rb'

class SVEnv < SVClass

	attr :path; # extra path for this driver

	def initialize(proj,ext,d) ##{{{
		@path  = './';
		cn = "#{proj}#{ext.capitalize}Env";
		super(cn,:component,d);
		@basename = 'uvm_env';
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

	# extra codes for run_phase
	def run(&block) ##{{{
		code = block.call;
		splitted = code.split("\n");
		splitted.map!{|l| "\t"+l;};
		@methods['run_phase'].procedure(splitted.join("\n"));
	end ##}}}
	def build(&block) ##{{{
		code = block.call;
		splitted = code.split("\n");
		splitted.map!{|l| "\t"+l;};
		@methods['build_phase'].procedure(splitted.join("\n"));
	end ##}}}
	def connect(&block) ##{{{
		code = block.call;
		splitted = code.split("\n");
		splitted.map!{|l| "\t"+l;};
		@methods['connect_phase'].procedure(splitted.join("\n"));
	end ##}}}
end
