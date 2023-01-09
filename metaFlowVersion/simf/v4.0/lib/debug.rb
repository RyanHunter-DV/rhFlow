class Debug ##{{{

    attr_accessor :enabled;

    def initialize _e ##{{{
        @enabled = _e;
    end ##}}}

    def print msg ##{{{
        puts '[DEBUG] '+msg if enabled;
    end ##}}}
    
end ##}}}
