require 'codeGenerator.rb'

class Driver < SVClass

	attr :path; # extra path for this driver

	def initialize(proj,ext,d) ##{{{
		@path  = './';
		cn = "#{proj}#{ext.capitalize}Driver";
		super(cn,d);
		@basename = 'uvm_driver#(REQ,RSP)';
	end ##}}}

	# set extra path for this driver
	def path(p) ##{{{
		@path = p;
	end ##}}}




end
