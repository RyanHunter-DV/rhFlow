require 'env.rb'
require 'top.rb'
require 'vip.rb'


class Builder

	attr_accessor :rootpath;
	attr_accessor :top;

	attr_accessor :tbEnv;
	attr_accessor :unitEnv;
	attr_accessor :vips;

	def self.setup(p,d) ##{{{
		@rootpath = p;
		@vips ={};
		@debug= d;
	end ##}}}

	def self.createTop(&block) ##{{{
		@top = Top.new(@debug);
		@top.instance_eval &block;
	end ##}}}
	def self.createVip(tn,&block) ##{{{
		v = Vip.new(tn,@debug);
		v.instance_eval &block;
		Top.define_method tn.to_sym do |instname,ifname,ifport|
			self.createVipInstance(v,instname,ifname,ifport);
		end
		@vips[tn.to_s] = v;
	end ##}}}

	def self.publish ##{{{
		@top.publish(@rootpath);
	end ##}}}
end

def top(&block) ##{{{
	Builder.createTop(block);	
end ##}}}