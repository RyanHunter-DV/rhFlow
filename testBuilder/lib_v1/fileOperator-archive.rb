# key functionality:
# - buildfile(path,filename,contents), to build target file, the path should exists
#
class FileOperator

	def initialize
	end

	def buildfile(path,filename,contents)
		fh = File.open("#{path}/#{filename}",'w');
		contents.each do |c|
			fh.write("#{c}\n");
		end
	end
end