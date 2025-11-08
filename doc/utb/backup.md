# Overview
utb, short of Unit level Testbench Builder.

## Feature list
### top building
- build the `top.sv` file which is the top testbench module declaring interfaces and connecting with DUT.
- declaring an interface that can be published and instantiated by others.
#### build top.sv module
The given root path is like `*/src/verif/`, the top builder will build files in `*/src/verif/tb/`.
#TODO 
#### interface instantiation and pass to ENV
*SV code example*
```systemverilog
RhAhb5If mstIf(xxx);
initial
	uvm_config_db#(xxx)::set(null,"uvm_test_top.env.mst","RhAhb5If",mstIf);
```
*user source example*
```
top ... do
	interface 'RhAhb5If','mstIf','mst' # the lst mst is the instance name of the vip, env path is fixed within utb.
end
```
In user source, a  `interface` command within `Top` is provided for instantiation, somehow, the interface instantiated in top should be declared before. The declaration
of the interface will be done through a global `interface` command, which is in [[#global interface command]]
the interface command within Top is in [[#Top::interface]]
#TODO 
#### DUT instantiation and connection
*SV code example*
```systemverilog
DUT DutInstance(
	.dutPort(mstIf.signal),
	...
);
```
*user source example*
```
top ... do
	dut 'DUTModule','udut' do
		connect(
			'iClk'=>top.tbClk
			'sigA'=>top.mIf.signalCode('sigA',:full,3,0)
		)
	end
end
```
#TODO 
#### builtin contents
- run test call
*SV code example*
```systemverilog
initial begin
	run_test();
end
```
#### waveform dumping
#TBD 
#### import and include information
- builtin uvm information
- interface used by this top should be included
- test package
- clock reset interfaces
```systemverilog
`include "uvm_macros.svh"
import uvm_pkg::*;
// other includes and imports based on user source.
```
#TODO 
### env building
- build unit level env, has interface uvcs, refmodule, scoreboard, and default configurations;
- build tb level env, has clock/reset uvcs, and testbase;
### tests building
- variaty of tests
## Use Case
### commands supported to setup an env
#### config
*example*
```
vip ... do
	config do
		field 'int','va','0'
		field 'queue','int','vb'
	end
end
```
#### vip
*example*
```
env ... do

	vip 'RhAhb5Vip',:as=>'mst'
	mst.config 'field0',config.field2
	mst.api 'api0',"#{config.fiel3},4"
end
```
#### vseqr, command for vseq/vseqr setup
*example*
```
env ... do
	vseqr 'seqrflag' => 'mst.seqr'
end
```

### commands supported to setup tbtop
#### declaring an interface
users can use the 'interface' command to declare a new interface which can be published, but in utb, it's only used to declare interface in tbtop.
*example*:
```
interface 'RhAhb5If' do
	param 'AW'=>'32'
	input 'HCLK'
	input 'IB','2'
	output 'A','3'
	signal 'sigA','32'
end
```
detailed declaration fo this command are here: [[#global interface method]]

#### top in global scope
*example*
```
top 'projectname' do
	commands within top ...
end
```
details in [[#Top]] , #TODO
#### declare an interface in top scope
*example*
```
top ... do
	interface 'RhAhb5If','mIf(clk,rstn)'
end
```
details in [[#Top]], #TODO 
#### dut in top scope
*example*
```
top ... do
	dut 'DUTModule','udut' do
		connect(
			'iClk'=>tbClk
			'sigA'=>mIf.signalCode('sigA',:full,3,0)
		)
	end
end
```

## Test Scenarios
For testing the tool. #TBD 


# Architecture
Brief description of the design architecture. And links of below chapters for details.
## contents of classes
- [[#MainEntry]]
- [[#EnvBuilder]]
- 
## major procedures
1. get options from command line, using options.rb as template, by `MainEntry`
2. reading source file, the entry is `top.rh`, which will load all other files
3. basic commands such as 'env','tbtop' etc, are located globally in main scope
4. setup and arrange all user sources through a call of `finalize`
5. building files and directories for each part through a `publish` call.
## env builder
- define a global method `env`, by which can build the env codes
- included all env related codes
### setup vips
- vip instantiating, and configuration
users can create and setup a vip instance of that env like:
```
env ... do
	vip 'vipname',:as=>'instname'
	instname.config('field0',config.field0)
end
```
A vip call is available in `SVEnv`, details in [[#setup a vip]]

### env configurations
users can setup an env configuration through the `config` api, and with a block being called within the `SVConfig` class. This inputs should support the tool to generate:
- config instantiated in env, the declaration and create in env
- config table being published with all provided config fields and methods.
#### declare config fields
different field types maybe need different apis to setup those fields, types are:
- :int, for bit, logic, int ... those integer types, use uvm_field_int
- :real, for those time, real ... for those real types, use uvm_field_real
- :queue, for those queue types, use uvm_field_queue_*
- :sarray, :darray, :aarray, :enum
using the `field` api to declare a config filed, and specifying with 'field type'. For example:
```
config ... do
	field 'int','va','default'
	field 'queue','int','vb','default'
	field 'enum','typeOfEnum','vc','default'
	func xxx do
		<<-CODE.gsub(/\s*-/,'')
			-xxxx
		CODE
	end
end
```
#### declare config methods
declare a method that can operate configurations through different methods, mostly functions.
#TBD 

### building checkers
[[#SVRefmodule]] and [[#SVScoreboard]] used to generate the checker part of env. The refmodule is a complicate
module for every dv env, it will only build a shell for now, like:
```systemverilog
class *refmodule* extends uvm_component;
	builtin information...
```
details in: [[#SVRefmodule]]
The scoreboard are simply combined with several common scoreboard client and a scoreboard top.
*user inputs example*:
```ruby
env ... do
	scoreboard 'instname','transtype','expsrcport','actsrcport'
	scoreboard 'regCtrl','ahb5ReqTrans','refm.regexp','regCtrl.rspPort'
end
```
By calling the scoreboard which is within `EnvBuilder` scope:
- firstly it will create a `SVScoreboard` if it didn't created before.
- And then will add a client by calling `SVScoreboard`'s addclient API.
- call `SVEnv`'s API to add the connection code into unit env's connect phase.

## top builder
Use a module `TopBuilder`, which will be directly called by `MainEntry`.
A `TopBuilder` is for building, finalizing the information in `Top` class. such as `self.top` which will create a new `Top` object.
### block evaluation from user source
- interface, dut, ...
### TopBuilder finalize

### TopBuilder publish

#TBD 

---

==Source Code Separator==

---
# utb shell
**file** `utb`
**rbcode** `toolshell`

# MainEntry
**file** `lib_v1/mainentry.rb`
**require**
```
pool.rb
topBuilder.rb
envBuilder.rb
```
**rbcode** `mainentry`
**apio** `run`
```ruby
# code of run here
# 1.load user source file, call loadSource(xxx)
loadSource(@options[:source]);
#TODO, TopBuilder need to be created
TopBuilder.setup(@options);
TopBuilder.finalize();
TopBuilder.publish();
# publish env
EnvBuilder.setup(@options);
EnvBuilder.finalize();
EnvBuilder.publish();
# tb/test builders here

```

## project method for global
**def** `project(name,root)`
use this project command to setup the name of the project and root path for utb building (mostly `*/verif/`)
```ruby
#TODO 
name=name.to_s;
TopBuilder.setup(name,File.join(root,'tb'));
EnvBuilder.setup(name,File.join(root,'env'));
```

# EnvBuilder
**file** `lib_v1/envBuilder.rb`
**require**
```
debugger.rb
svEnv.rb
```
**module** `EnvBuilder`
**field**
```
envs
debug
root
project
```

## EnvBuilder::setup
To setup project information for EnvBuilder.
**api** `self.setup(p,r)`
```ruby
@project = p;
@root    = r;
```
## envs
- given the attr of envs hash, which stores different env objects
- format of envs: `envs[<extra partition name>] = <SVEnv object>`
**api** `self.envs`
```
@envs={} if @envs==nil;
return @envs;
```
## debug features
**api** `self.debug`
```
@debug = Debugger.new(@options[:debug]) if @debug==nil;
return @debug;
```
## finalizing
**api** `finalize`
```ruby
@envs.each_value do |e|
	e.finalize();
end
```
## publish whole envs
**api** `self.publish`
```ruby
@envs.each_value do |e|
	e.publish();
end
```

## global env method
this is being called directly from user source, to declare an env.
- args:
	- n->name, extra name partition;
	- t->type, one of :unit or :tb, which will internally setup different builtins
	- block, being executed within `SVEnv`
- build a new `SVEnv` object in `EnvBuilder`;
- instance evaluation of the given block;
**def** `env(n,t,&block)`
```ruby
sve = SVEnv.new(n,t,EnvBuilder.debug);
sve.instance_eval &block;
EnvBuilder.envs[n] = sve;
```
- [[#SVEnv]]

# SVEnv
**file** `lib_v1/svEnv.rb`
**require**
```
svVseqr.rb
svVseq.rb
svClass.rb
svConfig.rb
svVipInstance.rb
```
**class** `SVEnv < SVClass`
**field**
```
vips
config
vseqr
vseq
```
## constructor
**api** `initialize(r,n,t,d)`
```ruby
cn = "#{$project.capitalize}#{n.capitalize}#{t.to_s.capitalize}Env"
@type = t.to_sym;
super(r,cn,d,:component);
@vips = {};
```
## setup a vip
- args:
	- n->typename, the vip type name, used to find from top.
	- :as=>'instname', specify the instance name for this env.
- find the `SVVip` instance named as 'n'
- create a new `SVVipInstance` object, with instance name, and the `SVVip` object.
- define a method named as the 'instname', which will return that `SVVipInstance` object.
**api** `vip(n,**opts)`
```ruby
return unless opts.has_key?(:as);
vbase = @top.find(n);
raise RunException.new("no vip definition found in pool",3) if vbase==nil;
vinst = SVVipInstance.new(opts[:as],vbase,@debug);
setm = opts[:as].to_sym;
@vips[setm.to_s] = vinst;
self.define_singleton_method setm do
	return vinst;
end
```
details: [[#SVVipInstance]]
## setup env conifgurations
for this api in env, only a block is required to setup fields and methods in `SVConfig`, the class name are determined already with format of env classname with 'Config' suffix.
**api** `config(&block)`
```ruby
cn = "#{@classname}Config";
@config = SVConfig.new(@rootpath,cn,@debug);
@config.instance_eval &block;
```
details: [[#SVConfig]]
## setup vseqr/vseq
**api** `vseqr(**pairs)`
```ruby
@vseqr = SVVseqr.new(@rootpath,@classname+"VSeqr",@debug) if @vseqr==nil;
@vseq  = SVVseq.new(@rootpath,@classname+"Vseq",@debug) if @vseq==nil;
@vseqr.connect(**pairs);
```

## finalize
While in finalize, following actions should be done:
- setup methods for vips configuration.
- setup methods to setup vseqr pairs connections.
**api** `finalize`
```ruby
# setup vip configurations
vips.each_pair do |n,o|
	m = SVMethod.new(:func,"setup#{n.capitalize}",@classname,'void','','local');
	cnts = o.code(:config); cnts.map!{|line| "\t"+line;};
	m.body(cnts.join("\n"));
	# register to this class's methods
	@methods["setup#{n.capitalize}"] = m;
	# call in build phase
	@methods['build_phase'].body("\tsetup#{n.capitalize}();");
end

# setup vseqr connections in connect phase
cnts = @vseqr.code(:connection)
m=SVMethod.new(:func,"connectionSeqrs",@classname,'void','','local');
cnts.map!{|line| "\t"+line;};
m.body(cnts.join("\n"));
@methods["connectionSeqrs"] = m;
@methods['connect_phase'].body("\tconnectionSeqrs();");
return;
```
## publish
Called by `EnvBuilder`, to publish all components within this env.
**api** `publish`
```ruby
publishSubs;
@debug.print("publishing #{@classname} ...");
cnts = [];
cnts.append(*filemacro);
cnts.append(code(:head));
cnts.append(code(:body));
cnts.append(*filemacroend);
buildfile(cnts);
```
**api** `publishSubs`
```ruby
@config.publish;
@vseq.publish;
@vseqr.publish;
```
## head code generated for publish
**api** `headCode`
```ruby
cnts=[];
# class declareation
cnts << "class #{@classname} extends uvm_env;";
# vip, config and other fields in env
cnts.append(*fieldsDeclareCode);
# builtins like uvm_utils
cnts.append(*utilsCode);
@methods.each_value do |m|
	cnts << "\t"+m.code(:prototype);
end
cnts << "endclass"
return cnts;
```
**api** `utilsCode`
```ruby
cnts=[];
cnts << %Q|`uvm_component_utils_begin(#{@classname})|;
@fields.each_value do |f|
	cnts << "\t"+f.code(:utils);
end
@vips.each_key do |k|
	cnts << "\t`uvm_field_object(#{k},UVM_ALL_ON)";
end
cnts << "\t`uvm_field_object(vseqr,UVM_ALL_ON)";
cnts << %Q|`uvm_component_utils_end|;
cnts.map!{|line| "\t"+line;};
return cnts;
```
**api** `fieldsDeclareCode`
```ruby
cnts = [];
@vips.each_value do |v|
	cnts << v.code(:instance);
end
@fields.each_value do |f|
	cnts << f.code(:instance);
end
cnts << @config.code(:instance);
cnts << @vseqr.code(:instance);
cnts.map!{|line| "\t"+line;};
return cnts;
```
## body code generated
**api** `bodyCode`
```ruby
cnts = [];
@methods.each_value do |m|
	cnts.append(*@methods.code(:body));
end
return cnts;
```


# SVVseqr
call by `EnvBuilder` to generate codes, example targets are: [[example-vseqr]]
**file** `lib_v1/svVseqr.rb`
**require**
```
svClass.rb
```
**class** `SVVseqr < SVClass`
**field**
```
pairs
```
**api** `initialize(r,cn,d)`
```ruby
super(r,cn,d,:component);
@pairs = {};
setupfields;
setupselect;
```

## setupfields
for vseqr, the field recording the sequencer is necessary
**api** `setupfields`
```ruby
f = SVField.new(:aarray,'uvm_sequencer_base','seqr','string')
@fields['seqr'] = f;
```
## setup a select api
**api** `setupselect`
```ruby
m = SVMethod.new(:func,'select',@classname,'uvm_sequencer_base','string flag');
lines = <<-CODE.gsub(/^\s*-/,"\t")
	-return seqr[flag];
CODE
m.body(lines);
@methods['select'] = m;
```
## connect vseqr pairs
**api** `connect(**pairs)`
```ruby
# to setup connection of vseqr and real seqr
pairs.each_pair do |flag,target|
	@pairs[flag] = target;
end
```
## publish the vseqr component
**api** `publish`
```
cnts = [];
cnts.append(*filemacro);
cnts.append(code(:head));
cnts.append(code(:body));
cnts.append(*filemacroend);
buildfile(cnts);
```
- filemacro/filemacroend api comes from [[#SVClass]]

**api** `headCode`
```ruby
cnts = [];
cnts << "class #{@classname} extends uvm_sequencer;";
## builtins
cnts << %Q|\t`uvm_component_utils_begin(#{@classname})|;
cnts << %Q|\t`uvm_component_utils_end|;

@fields.each_value do |f|
	cnts << "\t#{f.code(:instance)}";
end
@methods.each_value do |m|
	cnts << "\t#{m.code(:prototype)}";
end
cnts << 'endclass';
return cnts;
```
**api** `bodyCode`
```ruby
cnts=[];
@methods.each_value do |m|
	cnts.append(*m.code(:body));
end
return cnts;
```
## connection code in env
**api** `connectionCode`
```ruby
cnts = [];
@pairs.each_pair do |s,t|
	cnts << %Q|vseqr.seqr["#{s}"] = #{t};|;
end
return cnts;
```

# SVVSeq
**file** `lib_v1/svVseq.rb`
**require**
```
svClass.rb
```
**class** `SVVseq < SVClass`
**field**
```
fields
```
## constructor
**api** `initialize(r,cn,d)`
```
super(r,cn,d,:object);
@fields={};
setupfields;
setupmethods;
```
## setup fields for vseq
**api** `setupfields`
```ruby
f = SVField.new(:aarray,'string','seqs','uvm_sequence');
@fields['seqs'] = f;
```
**api** `setupmethods`
```ruby
setupset;
setupbody;
```
## setup set api in SV
**api** `setupset`
```ruby
m=SVMethod.new(:func,'set',@classname,'void','uvm_sequence item,string flag','virtual');
lines = <<-CODE.gsub(/^\s*\./,'')
	.seqs[item] = flag;
	.return;
CODE
m.body(lines);
@methods['set'] = m;
```
## setup body api in SV
**api** `setupbody`
```ruby
m = SVMethod.new(:task,'body',@classname,'','','virtual');

lines = <<-CODE.gsub(/^\s*-/,'')
	-foreach(seqs[s]) begin
	-	s.start(p_sequencer.select(seqs[s]));
	-end
CODE
m.body(lines);
@methods['body'] = m;
```

## publish the vseq component
**api** `publish`
```ruby
cnts = [];
cnts.append(*filemacro);
cnts.append(code(:head));
cnts.append(code(:body));
cnts.append(*filemacroend);
buildfile(cnts);
```

**api** `headCode`
```ruby
cnts = [];
cnts << "class #{@classname} extends uvm_sequence;";
## builtins
cnts << %Q|\t`uvm_declare_p_sequencer(#{@pseqr})|;
cnts << %Q|\t`uvm_object_utils_begin(#{@classname})|;
cnts << %Q|\t`uvm_object_utils_end|;

@fields.each_value do |f|
	cnts << "\t#{f.code(:instance)}";
end
@methods.each_value do |m|
	cnts << "\t#{m.code(:prototype)}";
end
cnts << 'endclass';
return cnts;
```

**api** `bodyCode`
```ruby
cnts=[];
@methods.each_value do |m|
	cnts.append(*m.code(:body));
end
return cnts;
```
**api** `instanceCode`
```ruby
return "#{@classname} vseq;";
```

# SVScoreboard

## attributes
## apis
*addclient*
```
# n->name
# e->exp source: refm.port
# a->act source: uvc.port
def addclient(n)
end
```
add a new client to scoreboard, and add connect code, between the scoreboard top and scoreboard client.


# SVVipInstance
A vip instance class, stores instance information and the `SVVip` object according to the typename of the vip. It supports:
- config override mechansim, configures used by env to setup this vip
- return code for :config
- return code for :instance
*user input example*
```
env ... do
	vip 'vipname',:as=>'instname'
	instname.config('field0',config.field0)
end
```
The vip command within the env is in `EnvBuilder`, it will:
- find the `SVVip` object in which the specific vip is defined before;
- create an object of `SVVipInstance`, record, the vip object and instance name;
- register to @vips hash in `EnvBuilder`
- define singleton method in `EnvBuilder`, so that hte prceeding call like `instname.config` will be available
	- the method will return current vip instance object

**file** `lib_v1/svVipInstance.rb`
**class** `SVVipInstance`
## attributes
**field**
```
instname
base
debug
configs
apis
```
## constructor
**api** `initialize(in,b,d)`
```ruby
@instname = in.to_s;
@base = b;
@debug= d;
@configs={};
@apis={};
```
## env configs for vip
calling this method will record an override in current instance object, and this object cannot published,
it only provides some of apis to return codes to `SVEnv` such as below
*code(:instance)*
return code line for declaring this vip, like: `RhAhb5Vip#(xx) mst;`
*code(:config)*
return code to setup/config this vip, like: `mstConfig.field0=xxxx;\n\tmstConfig.field1=config.field1`

- fn->field name defined in a vip
- ovrd-> override to ...
**api** `config(fn,ovrd)`
```ruby
@configs[fn.to_s] = ovrd.to_s;

```

*the api configurations*:
this api will setup a call of vip's api
**api** `api(n,args)`
```ruby
@apis[n.to_s] = args.to_s;
```

## returning sv codes
**api** `code(u)`
```ruby
# usage can be, :instance, :config
message = "#{u}Code".to_sym;
return self.send(message);
```
**api** `instanceCode`
```ruby
# This API to return instance code for vip
# currently not specially support the parameter mapping
l = "#{@base.classname} #{@inst};"
return l;
```
**api** `configCode`
```ruby
cnts = [];
@configs.each_pair do |local,ovrd|
	line = "#{@instname}.#{local} = ovrd;"
	cnts << line;
end
@apis.each_pair do |local,ovrd|
	line = "#{@instname}.#{local}(#{ovrd});"
	cnts << line;
end
return cnts;
```

# SVVip
To define a vip database
*user input example*:
```
# call global method vip
vip 'vipname' do
	# block being executed within SVVip object
	config do
		...
	end
	interface ...
end
```
**file** `lib_v1/svVip.rb`
**require** 
```
pool.rb
svInterface.rb
```
## global interface command
The interface declaration method are defined in SVVip.rb file, which will declare an interface that can be published if necessary. by calling of the interface method, which can 
by calling this method, a new object of `SVInterface` will be created, and sub block from user source will be evaluated within this SVInterface object. Finally, this newly created object will be stored into a global module: [[#Pool]].
**def** `interface(n,&block)`
```ruby
svi = SVInterface.new(n);
svi.instance_eval &block;
Pool.register(svi,:interface); #TODO, need register in pool.
```
[[#SVInterface]], #TODO 
# SVConfig
A class being create whoever need it, such as in an env, this object will be built and setup. By using of SVConfig, an SV configure table can be published easily.
**file** `lib_v1/svConfig.rb`
**class** `SVConfig < SVClass`
**field**
```
```
## constructor
**api** `initialize(r,cn,d)`
```
super(r,cn,d,:object)
builtinConfigs
```
**api** `builtinConfigs`
```
# setup builtin configs, both for vip/env
field :enum,'uvm_active_passive_enum','isActive',"UVM_ACTIVE","UVM_ALL_ON"
```

PS: field, func and task methods are available in [[#SVClass]]
## publish config files
**api** `publish`
```ruby
cnts = [];
cnts.append(*filemacro);
cnts.append(*code(:head));
cnts.append(*code(:body));
cnts.append(*filemacroend);
buildfile(cnts);
```
**api** `headCode`
```ruby
cnts = [];
cnts << "class #{@classname} extends uvm_object;";

## builtins
cnts << %Q|\t`uvm_object_utils_begin(#{@classname})|;
cnts << %Q|\t`uvm_object_utils_end|;

@fields.each_value do |f|
	cnts << "\t#{f.code(:instance)}";
end
@methods.each_value do |m|
	cnts << "\t#{m.code(:prototype)}";
end
cnts << 'endclass';
return cnts
```
**api** `bodyCode`
```ruby
cnts=[];
@methods.each_value do |m|
	cnts.append(*m.code(:body));
end
return cnts;
```
**api** `instanceCode`
```ruby
return "#{@classname} config;";
```



# SVClass
**file** `lib_v1/svClass.rb`
**require**
```
svFile.rb
```
**class** `SVClass < SVFile`
**field**
```
fields
methods
classname
uvmctype
```
## constructor
**api** `initialize(r,cn,d,t=:component)`
```ruby
fn = cn;fn[0..0].downcase!;
super(r,fn,d);
@classname = cn;
@fields = {};
@methods= {};
@uvmctype=t;
constructMethods;
phaseMethods if @uvmctype==:component;
```
## setup builtin methods for uvm
**api** `constructMethods`
```ruby
# setup sv constructors
args = '';
if @uvmctype==:component
	args=%Q|string name="#{@classname}",uvm_component parent=null|;
elsif @uvmctype==:object
	args=%Q|string name="#{@classname}"|;
else
	args='';
end
m = SVMethod.new(:func,'new',@classname,'',args);
if @uvmctype==:component
	m.body("\tsuper.new(name,parent);");
elsif @uvmctype==:object
	m.body("\tsuper.new(name);")
end
@methods['new'] = m;
```
**api** `phaseMethods`
```ruby
args='uvm_phase phase';
m = SVMethod.new(:func,'build_phase',@classname,'void',args,'virtual');
m.body("\tsuper.build_phase(phase);");
@methods['build_phase'] = m;

m = SVMethod.new(:func,'connect_phase',@classname,'void',args,'virtual');
m.body("\tsuper.connect_phase(phase);");
@methods['connect_phase'] = m;

m = SVMethod.new(:task,'run_phase',@classname,args,'virtual');
m.body("\tsuper.run_phase(phase);");
@methods['run_phase'] = m;
return;
```
## declare a  field
- args:
	- args are different according to different type, but `args[0]` must be: ft->field type, the sv type, will be declared as sv code
- according to ft, filter t, which can be bit, logic, int ... used to setting uvm_field_*
**api** `field(*args)`
```ruby
t = filterType(args[0]); # bit[3:0] -> int
f = SVField.new(t,@debug,*args);
@fields[vn] = f;
```
## filter out the field type
- args:
	- ft, the filed type
**api** `filterType(ft)`
```ruby
t = nil;
ptrn = Regexp.new(/ *\[.*\]/);
ft.sub!(ptrn,'');
if ft=='bit' or ft=='int' or ft=='logic'
	t=:int;
else
	t=ft.to_sym;
end
return t;
```
details in : [[#SVField]]

## declare a method
the method information is being declared in [[#SVMethod]]
### declare a function
- args:
	- n->name
	- c->class name, usually is self, if not a class method, use nil
	- r->return type
	- a->function args
	- q->extra qualifiers, 'virtual local' ...
**api** `func(n,c,r,a,q='',&block)`
```ruby
m = SVMethod.new(:func,n,c,r,a,q,@debug);
m.body(block.call);
@methods[n.to_s] = m;
```
**api** `task(n,c,a,q='',&block)`
```ruby
m = SVMethod.new(:task,n,c,nil,a,q,@debug);
m.body(block.call);
@methods[n.to_s] = m;
```

# SVFile
used to operate file based behaviors
**file** `lib_v1/svFile.rb`
**class** `SVFile`
**field**
```
debug
rootpath
filename
```
## constructor
**api** `initialize(r,fn,d,ext='.svh')`
```ruby
@rootpath = r;
@filename = "#{fn}#{ext}";
@debug = d;
```
## returning code
**api** `code(u)`
```ruby
message = "#{u}Code".to_sym;
return self.send(message);
```
## building a file
**api** `buildfile(cnts)`
```ruby
@debug.print("buildfile: #{File.join(@rootpath,@filename)}");
fh = File.open(File.join(@rootpath,@filename),'w');
cnts.each do |line|
	fh.write("#{line}\n");
end
```
## file macros
**api** `filemacro`
```ruby
m = @filename.sub(/\./,'__');
cnts = [];
cnts << '`ifndef '+m;
cnts << '`define '+m;
return cnts;
```
**api** `filemacroend`
```ruby
return ["\n`endif"];
```
# SVMethod
a ruby class used to store sv methods information and placed with sv syntax code.  Major apis are:
- new, used to setup the user information for the prototype
- body, used to add lines of the method body
- code, with different input args, to return the method's prototype or body
	- body is sv code with function or task definition.

**file** `lib_v1/svmethod.rb`
**class** `SVMethod`
**field**
```
type
name
classname
rtn
args
qualifiers
procedures
debug
```

**api** `initialize(t,n,c,r,a,q='',d)`
```ruby
# t->type, :func, :task
# n->name of method
# c->classname
# r->return type for function only
# a->args
# q->qualifiers
@type = t.to_sym;
@name = n.to_s;
@classname=c.to_s;
@rtn  = r.to_s;
@args = a.to_s;
@qualifiers=q;
@procedures=[];
@debug = d;
```

**api** `body(line)`
```ruby
# line here can be multiple sv code lines with one string.
# or a single sv code line with one string.
@procedures << line;
```

**api** `code(u)`
```ruby
# u->usage, of :prototype, :body
message = "#{u}Code";
return self.send(message);
```
**api** `prototypeCode`
```ruby
h = 'extern';
h += " #{@qualifiers}" if @qualifiers;
if @type==:func
	h+=" function #{@rtn}";
else
	h+=" task";
end
h+=" #{name}(#{@args});";
return h;
```

**api** `bodyCode`
```ruby
cnts = [];
h = "";
if @type==:func
	h+="function #{@rtn}";
else
	h+="task";
end
h+="#{@classname}::#{@name}(#{@args});";
cnts << h;
@procedures.each do |b|
	bs = b.split("\n");
	bs.map!{|l| "\t"+l;};
	cnts.append(*bs);
end
if @type==:func
	cnts << "endfunction"
else
	cnts << "endtask"
end
return cnts;
```

# SVField
**file** `lib_v1/svField.rb`
**class** `SVField`
**field**
```
debug
type
flag
```
## constructor
- args:
	- t->type of the field, symbol type, for uvm_field_*;
	- args, an array, that differentiated in different field type;
**api** `initialize(t,d,*args)`
```ruby
@type = t.to_sym;
@debug= d;
@flag = args.pop;
message = "register#{@type}".to_sym;
self.send(message,*args);
```
## register different type fields
**api** `registerint(ft,va,default='')`
```ruby
# ft->fieldtype, used to declare the sv field.
# va->varname,
# default->the default value, default is ''
@fieldtype = ft.to_s;
@name = va.to_s;
@default= default;
```
**api** `registerenum(ft,va,default='')`
```ruby
@fieldtype = ft;
@name = va.to_s;
@default= default;
```
**api** `registerreal(ft,va,default='')`
```ruby
@fieldtype=ft;
@name=va.to_s;
@default=default;
```
**api** `registerqueue(ft,va)`
```ruby
@fieldtype=ft;
@name="#{va}[$]";
@default='';
```
**api** `registersarray(ft,va,s)`
```ruby
# s->size, the size of array
@fieldtype=ft;
@name="#{va}[#{s}]"
@default='';
```
**api** `registerdarray(ft,va)`
```ruby
@fieldtype=ft;
@name="#{va}[]"
@default='';
```
**api** `registeraarray(ft,va,it)`
```ruby
# it->index type
@fieldtype=ft;
@name="#{va}[#{it}]"
@default=''
```
## getting svcode from field
- args:
	- u->usage, for field, there're
		- :instance, 
		- :ref, for reference, return the vaname
		- :utils, for uvm field utils
		- more are #TBD 
**api** `code(u)`
```ruby
message = "#{u}Code".to_sym;
return self.send(message);
```
**api** `instanceCode`
```ruby
l = "#{@fieldtype} #{@name};";
return l;
```
**api** `utilsCode`
```ruby
l = "`uvm_field_#{@type}(";
if @type==:enum
	l+="#{@fieldtype},";
end
l+="#{@name},#{@flag})";
return l;
```
**api** `refCode`
```ruby
return @name;
```




# TopBuilder
**file** `lib_v1/topBuilder.rb`
**module** `TopBuilder`
**field**
```
top
```
## TopBuilder::setup
**api** `self.setup(options)`
```ruby
@debug = Debugger.new(options[:debug]);
```
## TopBuilder::finalize
**api** `self.finalize()`
- arrange builtin database for codes
- prepare includes and imports codes
- #MARK 
```ruby
```
#TODO 
## TopBuilder::publish
to publish `top.sv` file in given root: `*/verfi/tb/`.
#TODO 
## TopBuilder::top
**api** `self.top(p,&block)`
- if already exists one top, report error and return
- create a new top, set the p(project)
- evaluate the block
```ruby
return if @top!=nil;
@top = Top.new(project,@debug);
@top.instance_eval &block;
```
## global top method at the end of file
**def** `top(project,&block)`
```ruby
TopBuilder.top(project,&block);
```


# Top
**file** `lib_v1/top.rb`
**class** `Top`
## Top::initialize
**api** `initialize(p,d)`
- set project name
- setup debug
```ruby
@debug  = d;
@project= p;
```
## Top::interface
**api** `interface(it,name,setn)`
- find a declared interface with the interface type from `Pool`;
- define a hash for interface instance, which has:
	- :instname => 'mIf'
	- :params=> 'a,b,c'
	- :ports=> 'a,b'
	- :handle=> SVInterface object
	- :setpath=> '...'
- store this into a ifs hash: 'top.#{instname}' => interface instance
- create a singleton method named as 'name' within this `Top` 
```ruby
intf = Pool.find(it,:interface);
raise RunException.new("no interface(#{it}) declared",3) if intf==nil;
setpath = "uvm_test_top.tbEnv.uEnv.#{setn}";
info = {};
info[:instname] = name;
# not support, info[:params] = '';
# not support, info[:ports]  = '';
info[:handle] = intf;
info[:setpath]= setpath;
@ifs["top.#{name}"] = info;
self.define_singleton_method name.to_sym do
	return intf;
end 
```

## Top::dut
**api** `dut(tn,as,&block)`
- create a new `SVDUT` object with tn
- give self to the SVDUT object
- evaluate the block within the created SVDUT
	- support connect, will store connection information
- register instname => object to Top's duts hash;
```ruby
tn=tn.to_s;as=as.to_s;
d = SVDUT.new(tn,self);
d.instance_eval &block;
self.duts[as.to_s] = d;
```



# Pool
It's a global module, for search/storing declared items.
**file** `lib_v1/pool.rb`
**module** `Pool`
**field**
```
pool;
```
**api** `self.register(o,t)`
to register a declared object with specified type
```ruby
@pool={} unless @pool.is_a?(Hash);
@pool[t.to_sym]=[] unless @pool.has_key?(t.to_sym);
@pool[t.to_sym] << o;
```
**api** `self.find(n,t)`
find by name according to given type.
```ruby
t = t.to_sym;
return nil unless @pool.has_key?(t);
@pool[t].each do |o|
	return o if (o.name == n.to_s);
end
return nil;
```
#TODO 

# Debugger
this is a common from codelib
**file** `lib_v1/debugger.rb`
**rbcode** `debugger`
