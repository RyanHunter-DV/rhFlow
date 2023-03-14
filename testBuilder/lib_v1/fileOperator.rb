# Class Description
# - FileOperator.new(filename,@debug,:create=>false)
# create a file operator specifically for 'filename'
# by default, :create is false, which will not create if a file not exists
# - captureContent(start,end)
# capture contents according to given start and end lie
# -
require 'debugger.rb'
class FileOperator
	attr_accessor :filename;
	attr_accessor :path;
	attr :debug;

	def initialize(p,fn,d=nil,**opts) ##{{{
		@debug = d;
		@debug = Debugger.new(false) if d==nil;
		@filename = fn;
		@path = p;
		buildfile(opts[:create]) if opts.has_key?(:create);
	end ##}}}
	# c->create
	def buildfile(c) ##{{{
		return if c==false;
		ps = [];
		p = @path;
		while (not Dir.exist?(p)) do
			ps << p;
			p = File.dirname(p);
		end
		ps.reverse!;
		@debug.print("ps: #{ps}");
		ps.each do |p|
			Dir.mkdir(p);
		end
		fh = File.open(File.join(@path,@filename),'w');
		fh.close;
		return;
	end ##}}}

	def captureContent(s=1,e=-1) ##{{{
		fh = File.open(@filename,'r');
		all = fh.readlines(); fh.close;
		e = all.length if e==-1;
		@debug.print("capture range: #{s} -> #{e}");
		captured=[];
		for i in s..e do
			captured << all[i-1].chomp! if i>=s and i<=e;
		end
		return captured;
	end ##}}}

	def writeContents(cnts) ##{{{
		fn = File.join(@path,@filename);
		fh = File.open(fn,'w');
		cnts.each do |c|
			fh.write("#{c}\n");
		end
		fh.close;
		return;
	end ##}}}
	def insertContent(s=1,cnts) ##{{{
		@debug.print("insert to: #{@filename},#{s}");
		puts "insert cnts: #{cnts}";
		fh = File.open(@filename,'r');
		origin = fh.readlines();fh.close;
		new = [];
		current = 1;
		origin.each do |l|
			@debug.print("looping origin,s:#{s},current:#{current} line:#{l}");
			if s==current
				@debug.print("append cnts:#{cnts} to line:#{current}");
				new.append(*cnts);
			end
			new << l;
			current += 1;
		end
		new.append(*cnts) if origin.empty?;
		fh = File.open(@filename,'w');
		new.each do |l|
			fh.write(l);
		end
		fh.close;
	end ##}}}
end
