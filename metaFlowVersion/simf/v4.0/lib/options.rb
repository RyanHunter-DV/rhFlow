require 'optparse';

class Options; ##{{{

	attr :options;

    def __initOptions__ ##{{{
		@options = {};
		@options[:help] = false;
        @options[:sync] = false;
        @options[:debug]= false;
        @options[:eval] = '';
        ## @options[:seed] = '';
    end ##}}}

	def initialize ##{{{
        __initOptions__;
		OptionParser.new do |opts|
			opts.on('-h') do |v|
				@options[:help]=true;
			end
            opts.on('-s','--sync','sync up reqquired components') do |v| #{
                @options[:sync] = true;
            end #}
            ## opts.on('-S','--seed=SEED','specify seed for simulation') do |v| #{
            ##     @options[:seed] = v;
            ## end #}
			opts.on('-e','--eval=execmd','evaluation') do |v| #{
				@options[:eval] = v;
			end #}
            opts.on('-d','--debug','enable debug print') do |v| #{
                @options[:debug] = true;
            end #}
		end.parse!
	end ##}}}

    def syncup ##{{{
        return @options[:sync];
    end ##}}}
    def debug ##{{{
        return @options[:debug];
    end ##}}}

	def helpMessage ##{{{
		puts "help information, TBD";
		exit 0;
	end ##}}}

	def gethelp ##{{{
		helpMessage if @options[:help]==true;
	end ##}}}

	def evaluation ##{{{
		puts "#{@options[:eval]}"
		return @options[:eval];
	end ##}}}

end ##}}}
