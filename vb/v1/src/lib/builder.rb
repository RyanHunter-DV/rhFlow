require 'driver.rb'

module Builder

	attr_accessor :path;
	attr_accessor :drivers;

	attr :debug;
	attr :project;

	def self.setup(p,d) ##{{{
		@path = p;
		@debug= d;
		@drivers=[];
	end ##}}}

	def self.project(p) ##{{{
		@project = p;
	end ##}}}

	def self.loadSource(e) ##{{{
		rhload e;
	end ##}}}
	def self.finalize ##{{{
		#TODO
	end ##}}}

	def self.publish ##{{{
		@drivers.each do |drv|
			drv.publish(@path);
		end
	end ##}}}

	def self.createDriver(ext,&block) ##{{{
		drv = Driver.new(@project,ext,@debug);
		drv.instance_eval &block;
		@drivers << drv;
	end ##}}}
end

def project(n)
	n = n.to_s;
	Builder.project n;
end

def driver(ext='',&block) ##{{{
	ext = ext.to_s;
	Builder.createDriver(ext,&block);
end ##}}}
