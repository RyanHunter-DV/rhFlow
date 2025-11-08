# Overview
## Feature list
#TODO 
- [[#Easy install and setup]];
- a standalone tool to generate tests/sequences and base test;
	- based on user source inputs, to generate tests, sequences and template;
- [[#generate sequences]];
	- a sequence can be generated through the global command 'seq';
	- to generate a sequence, many of sub commands for that sequence are required;
- [[#generate tests]]
- [[#generate template]]




# Detailed Feature Description

## generate template
The tool is able to generate a test template (base test) according that users provide a template information, through the 'template' command. Which supports features:
- customize the run flow when run_phase started;
- specify the env typename, so that the tool will create an env by that type;
### template declaration
```ruby
template :TemplateName do
	...
end
```

### specify env type
```ruby
template ... do
	env 'ProjectTbEnv'
end
```
### define the running flow

```ruby
run do
	<<-CODE.gsub(/\s*-/,'')
	-\ttest_init();
	-\ttest_sim();
	-\ttest_done();
	CODE
end
```

### virtual tasks defined for running flow
```ruby
template ... do

	vtask :test_init
	vtask :test_sim,'arg0,args1'
	vtask :test_done

end
```

#TODO 

## generate sequences
By declaring a sequence, and to generate a sequence, following commands will support:
- seq, a command in global, to generate seqeuence, [[#Globals#seq]];
- rand, to define a random field for sequence;
- body, to define the procedures of sequence's body;


## generate tests
This tool also able to generate tests according to users specification through a 'test' command, this command supports:
- [[#env configurations]],  which can be generated at build phase;
- [[#prepare sequences]]
- [[#start sequences]]
- [[#setup execution of flows]]

### test declaration
To declare a test, use the 'test' command, exceeding with a block between 'do...end' will be used to specify user configurations for that test.
### env configurations
To setup an env or customize env configurations sepcialized for this test is supportive. So env configuration feature is established, by calling directly with 'env' reference, users can specify the existing configurations of an env, like:
```ruby
test ... do
	env.config('is_active = 1','option("debug")')
end
```
### prepare sequences
Sequences are key for a test, a pre-declared sequence is available in the test, by calling directly with the sequence name as a method, an argument as the sequence instance name, and a 'do...end' block as constraints of that sequence, like:
```ruby
test ... do
	SeqTypeName :inst do
		random ...
		constraint ...
	end
end
```


### start sequences
Once sequences are instantiated in that test, then it can be started by calling the 'start' command of a test with instantiated sequence names, one call of 'start' is a serial procedure of starting a sequence, like:
```ruby
start :test_sim, :seqa
start :test_init, :seqb
```
Besides, a parallel starting of sequences are supported by calling multiple sequences by one start call, like:
```ruby
start :test_sim, :seqa,:seqb,...
```

