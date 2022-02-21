## a baseContainer, derived by other containers such as design, component
class BaseContainer; ##{
	attr :name;
	attr :features;
	attr :signals;
	attr :featureRegistry;
	attr :blocks;
	attr :logics;
	attr :parent;
	## TODO, attr :connections;
	attr :exes;
	attr :currentInst;

	def initialize name,ft,block ##{{{
		@blocks = Array.new();
		@logics = Hash.new();
		@features = Hash.new();
		@signals  = Hash.new();
		@featureRegistry = FeatureRegistry.new();
		@name = name;
		@blocks.push(block);
		@parent = nil;
		## TODO, @connections = Hash.new();
		@exes = Array.new();
		@currentInst = '';

		if ft.is_a?(Hash)
			__addFeaturesFromHash ft
		end
	end ##}}}

	def addLogics l,inst='design' ##{{{
		if self.is_a?(DesignComponent)
			@logics[inst.to_s] = l;
		else
			@logics[l.name] = l;
		end
	end ##}}}

	def block name, &b ##{{{
		if name.to_s=='exe'
			@exes.push(b);
		end
	end ##}}}

	def __addFeaturesFromHash ft ##{{{
		ft.each_pair do
			|k,v|
			## add feature by calling global feature method
			feature k.to_s,v.to_s
		end
	end ##}}}

	def setParent c ##{{{
		@parent=c;
	end ##}}}

	def addFeature ft ##{{{
		## simply overwrite now
		if @features.has_key?(ft.name)
			puts "overwritting feature #{ft.name} from(#{@features[ft.name].value})to(#{ft.value})"
		else
			puts "adding feature of #{ft.name}:#{ft.value}"
		end
		@features[ft.name] = ft;
		getFeatureRegistry.instance_exec do
			define_singleton_method ft.name.to_sym do
				return ft.value;
			end
		end
	end ##}}}

	def getFeatureRegistry
		return @featureRegistry;
	end

	def expand block ##{{{
		@blocks.push(block);
	end ##}}}

	def addSignal sig ##{{{
		if @signals.has_key?(sig.name)
			puts "ERROR: signal already registered, ignored"
			return;
		end
		sig.setContainer self;
		@signals[sig.name] = sig;

		## add singleton method for signals
		self.instance_exec do
			define_singleton_method sig.name.to_sym do
				return sig;
			end
		end
	end ##}}}

	def instantiate inst,b ##{{{
		@currentInst = inst.to_s;
		self.instance_exec &b;
	end ##}}}

	def exec ##{{{
		@exes.each do
			|b|
			self.instance_exec &b
		end
	end ##}}}

	def connect opts ##{{{
		opts.each_pair do
			|s,t| ## s:source, t:target
			## fullS = @currentInst+'.'+s.to_s;
			## @connections[fullS] = t.to_s;
			self.send(s.to_sym).connect @currentInst,@parent.send(t.to_sym);
		end
	end ##}}}


end ##}
