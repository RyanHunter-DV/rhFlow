require 'singleton'
class DesignComponent < BaseContainer; ##{
	attr :instNames; ## instance name, it's an array
	attr :elaborated;

	def initialize name,ft,b ##{{{
		super(name,ft,b);
		@instNames = Array.new();

	end ##}}}



	def elaborate ##{{{
		return if @elaborated;
		@blocks.each do
			|b|
			self.instance_exec &b
		end
		@elaborated = true;
	end ##}}}

	## ## fs -> features, with hash format
	## def pre_elaborate inst,b ##{{{
	## 	self.instance_exec &b
	## end ##}}}


end ##}


def __defineComponentMethodLocally name ##{{{
	self.instance_exec do
		puts "#{__FILE__}, name: #{name.to_s}"
		define_singleton_method name do ##{
			|inst,&b|
			c = ComponentRegistry.getComponent name
			self.instantiate inst,c;
			if b!=nil
				c.pre_elaborate inst,b;
			end
			c.elaborate if not c.elaborated;
			c.exec
		end ##}
	end
end ##}}}

class ComponentRegistry; ##{
	include Singleton;

	@@components = Hash.new();

	def self.registered? name
		return true if @@components.has_key?(name.to_s);
		return false;
	end

	## to register a new component
	def self.register name,ft,block
		c = DesignComponent.new(name,ft,block);
		@@components[name.to_s] = c;
	end

	def self.getComponent name
		return @@components[name.to_s] if @@components.has_key?(name.to_s);
		return nil;
	end

	def self.expand name,fs,block ##{{{
		c = self.getComponent(name);
		c.expand(block);
		if fs.is_a?(Hash)
			c.__addFeaturesFromHash(fs);
		end
	end ##}}}


end ##}


## global method to declare a new component, all blocks called by component
## will be stored in DesignComponent class, multiple calling component with the
## same name are allowed
## a new method of <name> will be created in a ComponentRegistry class
def component name,ft=nil, &block ##{{{
	if ComponentRegistry.registered?(name)
		## component registered
		ComponentRegistry.expand(name,ft,block);
		return;
	end

	## component not registered
	ComponentRegistry.register(name,ft,block);
	if self.is_a?(DesignModule)
		__defineComponentMethodLocally name.to_sym;
	end

end ##}}}

## import a component to current self(mostly this import will be called within
## a design
def import name ##{{{
	if not ComponentRegistry.registered?(name)
		puts "Error, component: #{name} not declared"
		exit 3;
	end
	if self.respond_to?(name.to_sym)
		puts "Error, component:#{name} already imported"
		return;
	end
	__defineComponentMethodLocally name.to_sym;

end ##}}}
