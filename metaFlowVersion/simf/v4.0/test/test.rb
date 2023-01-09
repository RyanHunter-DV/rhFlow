#! /usr/bin/env ruby

class Context
end

$c = nil;
def plugin n,&block
    $c = Context.new()
	puts "source location: #{block.source_location.join(',')}"
    $c.instance_eval &block;
end


plugin 'xcelium' do
    xlm = 'Xcelium.object'
    self.instance_variable_set('@xcelium',xlm);
    self.define_singleton_method :xcelium do
        return @xcelium;
    end
end

## class NoEx < Exception
## 
## 	def process m
## 		puts "#{m}";
## 		exit 3;
## 	end
## end
## 
## def component n
## 	raise NoEx;
## end
## 
## begin
## 	component("hello");
## rescue NoEx=>e
## 	e.process("noex message");
## end


##pool = {};
##pool['a'] = 1
##pool['b'] = 2
##pool=[];
##puts pool.methods

##def compopt t,*opts
##	puts "#{opts}"
##end
###compopt :all,'aaaa','-b ccc'
##compopt :all,'aaaa'
## out = ENV['OUT_ANCHOR'] || './out';
## puts out;


def compopt eda=:all,*opts,**args
	puts "eda: #{eda}";
	puts "args: #{args}";
	puts "opts: #{opts}";
end

compopt :vcs,'-XFLAG mmm','-ACCESS rwc',:pre=>true
compopt :all,'-XFLAG mmm','-ACCESS rwc',:pre=>true
compopt :xlm,'-XFLAG mmm'

