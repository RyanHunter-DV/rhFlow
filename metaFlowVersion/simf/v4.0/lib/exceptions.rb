## This file stores different exception classes.

class ExceptionBase < Exception ##{{{
    attr_accessor :exitSig;
    attr_accessor :exitMsg;
    attr_accessor :eFlag;
	attr_accessor :noexit;

    ## supports error level
    ## :WARNING, :ERROR, :FATAL
    attr_accessor :elevel;
	attr :extMsg;

    def initialize ##{
        @exitSig = 0;
        @exitMsg = '';
		@extMsg  = '';
        @eFlag   = 'BERR';
        @elevel  = :WARNING;
		@noexit  = false;
    end #}
    def __shallexit__ ##{{{
		return false if @noexit;
        return true if @elevel==:ERROR or @elevel==:FATAL;
        return false;
    end ##}}}
    def process msg=nil ##{
        @exitMsg = msg.to_s if msg!=nil;
        stack = caller(1);
        puts "\n[#{@elevel},#{@eFlag}] #{@exitMsg}#{@extMsg} ";
        puts "----- Tracing Stack -----:\n",stack;
        exit @exitSig if __shallexit__;
    end ##}
    def self.message msg; @exitMsg=msg; end
end ##}}}

class NoContextException < ExceptionBase ##{{{
    def initialize ##{
        super();
        @exitSig = 1;
        @exitMsg = 'no context specified by project user';
        @eFlag   = 'NCTX';
        @elevel  = :FATAL;
    end ##}
end ##}}}
class UnSpException < ExceptionBase ##{{{
    def initialize ##{
        super();
        @exitSig = 2;
        @eFlag   = 'NONSP';
        @elevel  = :ERROR;
    end ##}
    
end ##}}}
class EvalException < ExceptionBase

	def initialize msg='' ##{{{
		super();
		@exitSig=3;
		@eFlag  ='EVALE';
		@elevel =:ERROR;
		@extMsg = msg if msg!='';
	end ##}}}
end
class BuildException < ExceptionBase
	def initialize msg='' ##{{{
		super();
		@exitSig=4;
		@eFlag  ='BERR';
		@elevel =:ERROR;
		@extMsg = msg if msg!='';
	end ##}}}
end
class ConfigEvalException < ExceptionBase
	def initialize msg='' ##{{{
		super();
		@exitSig=5;
		@eFlag  ='CFGE';
		@elevel =:ERROR;
		@extMsg = msg if msg!='';
	end ##}}}
end
class ComponentEvalException < ExceptionBase
	def initialize msg='' ##{{{
		super();
		@exitSig=6;
		@eFlag  ='COMPE';
		@elevel =:ERROR;
		@extMsg = msg if msg!='';
	end ##}}}
end
class EnvException < ExceptionBase
	def initialize msg='' ##{{{
		super();
		@exitSig=7;
		@eFlag  ='ENVE';
		@elevel =:FATAL;
		@extMsg = msg if msg!='';
	end ##}}}
end
class OtherCmdException < ExceptionBase
	def initialize msg='',sig=-1 ##{{{
		super();
		@exitSig=sig;
		@eFlag  ='CMDF';
		@elevel =:FATAL;
		@extMsg = msg if msg!='';
	end ##}}}
end
class TestEvalException < ExceptionBase
	def initialize msg='' ##{{{
		super();
		@exitSig=8;
		@eFlag  ='TESTE';
		@elevel =:ERROR;
		@extMsg = msg if msg!='';
	end ##}}}
end
class CompileException < ExceptionBase
	def initialize msg='' ##{{{
		super();
		@exitSig=9;
		@eFlag  ='COMPE';
		@elevel =:ERROR;
		@extMsg = msg if msg!='';
	end ##}}}
end
class SimException < ExceptionBase
	def initialize msg='' ##{{{
		super();
		@exitSig=10;
		@eFlag  ='SIME';
		@elevel =:ERROR;
		@extMsg = msg if msg!='';
	end ##}}}
end
