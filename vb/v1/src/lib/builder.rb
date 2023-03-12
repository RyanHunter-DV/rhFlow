require 'driver.rb'

module Builder

	attr_accessor :path;
	attr_accessor :project;
	attr_accessor :drivers;

	attr :debug;
	def self.setup(p,d) ##{{{
		@path = p;
		@debug= d;
		@drivers=[];
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
		drv = SVDriver.new(@project,ext,@debug);
		drv.instance_eval &block;
		@drivers << drv;
	end ##}}}
end

def project(n)
	Builder.project= n;
end

def driver(ext='',&block) ##{{{
	Builder.createDriver(ext,&block);
end ##}}}