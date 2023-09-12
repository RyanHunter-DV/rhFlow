require 'base/ToolOption'
class GeneratorBase

	attr_accessor :option
	attr_accessor :name;

	def initialize(n,old=nil) ##{{{
		@name =n;
		@option = ToolOption.new();
		copy(old) if old;
	end ##}}}
public
	## place public methods here
private
	## place private methods here


	## copy(src), to copy options from src to current ToolOption
	def copy(src); ##{{{
		src.option.get.each do |opt|
			@option.add opt;
		end
		src.option.get(:format).each_pair do |k,v|
			@option.format(k,v);
		end
	end ##}}}
end