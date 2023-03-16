require 'svDriver.rb'
require 'svMonitor.rb'
require 'svSeqr.rb'
require 'svTrans.rb'
require 'svAgent.rb'
require 'svEnv.rb'

module Builder

	attr_accessor :path;
	attr_accessor :drivers;
	attr_accessor :monitors;
	attr_accessor :seqrs;
	attr_accessor :trans;
	attr_accessor :agents;
	attr_accessor :envs;
	attr_accessor :project;

	attr :debug;

	def self.setup(p,d) ##{{{
		@path = p;@debug= d;
		@drivers=[];@monitors=[];@seqrs=[];@trans=[];
		@agents=[];@envs=[];
	end ##}}}
	def self.project(p) ##{{{
		@project = p;
	end ##}}}
	def self.loadSource(e) ##{{{
		rhload e;
	end ##}}}
	def self.finalize ##{{{
		@drivers.each do |drv|
			drv.finalize;
		end
		@monitors.each do |mon|
			mon.finalize;
		end
		@seqrs.each do |seqr|
			seqr.finalize;
		end
		@trans.each do |tr|
			tr.finalize;
		end
		@agents.each do |o|
			o.finalize;
		end
		@envs.each do |o|
			o.finalize;
		end
	end ##}}}
	def self.publish ##{{{
		@drivers.each do |drv|
			drv.publish(@path);
		end
		@monitors.each do |mon|
			mon.publish(@path);
		end
		@seqrs.each do |seqr|
			seqr.publish(@path);
		end
		@trans.each do |tr|
			tr.publish(@path);
		end
		@agents.each do |o|
			o.publish(@path);
		end
		@envs.each do |o|
			o.publish(@path);
		end
	end ##}}}
	def self.createDriver(ext,&block) ##{{{
		drv = Driver.new(@project,ext,@debug);
		drv.instance_eval &block;
		@drivers << drv;
	end ##}}}
	def self.createMonitor(ext,&block) ##{{{
		mon = SVMonitor.new(@project,ext,@debug);
		mon.instance_eval &block;
		@monitors << mon;
	end ##}}}
	def self.createSeqr(ext,&block) ##{{{
		seqr = SVSeqr.new(@project,ext,@debug);
		seqr.instance_eval &block;
		@seqrs << seqr;
	end ##}}}
	def self.createTrans(ext,&block) ##{{{
		trans = SVTrans.new(@project,ext,@debug);
		trans.instance_eval &block;
		@trans << trans;
	end ##}}}
	def self.createAgent(ext,&block) ##{{{
		agt = SVAgent.new(@project,ext,@debug);
		agt.instance_eval &block;
		@agents << agt;
	end ##}}}
	def self.createEnv(ext,&block) ##{{{
		o = SVEnv.new(@project,ext,@debug);
		o.instance_eval &block;
		@envs << o;
	end ##}}}
end

def project(n) ##{{{
	n = n.to_s;
	Builder.project n;
end ##}}}
def driver(ext='',&block) ##{{{
	ext = ext.to_s;
	Builder.createDriver(ext,&block);
end ##}}}
def monitor(ext='',&block) ##{{{
	ext = ext.to_s;
	Builder.createMonitor(ext,&block);
end ##}}}
def seqr(ext='',&block) ##{{{
	ext = ext.to_s;
	Builder.createSeqr(ext,&block);
end ##}}}
def trans(ext='',&block) ##{{{
	ext = ext.to_s;
	Builder.createTrans(ext,&block);
end ##}}}
def agent(ext='',&block) ##{{{
	ext = ext.to_s;
	Builder.createAgent(ext,&block);
end ##}}}
def env(ext='',&block) ##{{{
	ext=ext.to_s;
	Builder.createEnv(ext,&block);
end ##}}}
