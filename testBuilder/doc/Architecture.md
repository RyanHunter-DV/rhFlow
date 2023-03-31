


# Architecture


## testBuild
This is the main tool shell to be called by user, in which it'll:
1. create MainEntry object;
2. call MainEntry object's run;

## MainEntry
A ruby class being called by tool shell
*initialize*
1. parse options;
2. setup debug;

*run*
1. call setup of Builder module, set to the root path;
2. load user source entry according to user options;
3. call finalize of Builder;
4. call publish of Builder;

## Builder
A module called by MainEntry and all global user commands, by which can store key information such as created Test object, Seq object etc.
*setup*
1. to set basic Builder options, such as rootPath;
2. initialize the Builder's attributes such as testPool, seqPool etc;
*finalize*
after user source entered, to finalize the user inputs with some of builtin information.
1. call each registered test, seq, and template's finalize;
*publish*
1. call each registered test, seq, and template's publish;


## Seq
A ruby class to create sequence, object of this class will be created when user command 'seq' is called.
*rand*
specify a random field of this seq.
*body*
return a here-doc that can be added to the sequence's body method directly.
*finalize*

*publish*
call to publish sequence codes, requires information:
- the sequence name;
- base, the base sequence name where this derived from;
- fields of this sequence, which are random qualified;
- body executions;

## Test
A ruby class create while user defined a new test, through the test command, so this class should support all commands within the test commands.
### user configurations
*SeqTypeNamedAPIs(n,&block)*
These methods are declared while in declaring 'Seq', by `Test.define_method :SeqTypeName ...` in 'Builder' module.
Example of this: [[Features And Examples#prepare sequences]].
*env*
Users can setup config by calling like `env.config('xxxx','xxx')`.
the env API provided by every 'Test' class, which returns an object of 'Env' class, in which has database such as config.
details extended: [[#Env]]. Example: [[Features And Examples#env configurations]].
*start(flow,*seqs)*
To start sequence, if given arg has multiple sequences, then those sequences will be started parallelly with 'fork-join'.
Each time call the start will start the sequence with serial ordering.
Examples: [[Features And Examples#start sequences]].
- flow -> a flow will be specified that where current sequence will be prepared and started.


### for publishing
*finalize*
1. arrange build_phase codes, according to the env's configurations
*publish*
call to publish test, requires information:
- the test name and its base name;
- virtual tasks defined by flow;

#TODO 

## Env

## TestTemplate
setup a test template by calling the global 'template' command, which will call Builder.createTestTemplate.
And in test template object, this tool should realize the features for user configuration and publish the test base file.
### user configurations
*run(&block)*
This API allows users to setup the test flow for it, examples are: [[Features And Examples#define the running flow]].
*vtask(n,a='')*
defining a virtual task with empty body for the base test, those virtual tasks will be overridden by tests extended from it.
- n->name, name of the task
- a->args, args of the task
Examples: [[Features And Examples#virtual tasks defined for running flow]].
*env(tn)*
specify a env type name by which a env instantiation code will be placed at template's build_phase, and the instance name is fixed as 'tbEnv'.
Examples: [[Features And Examples#specify env type]].

### publishing
*publish(path)*
to organize the templates codes and building to a file through `@fop.buildfile`.
- path->the root path of this project, some tools may have extra local path in current class.

#TODO 

## Globals
### seq
command to declare a sequence, declared at [[lib_v1/builder.rb]].
### test
command to declare a test, declared at [[lib_v1/builder.rb]].
### template
command to declare a base test, declared at [[lib_v1/builder.rb]]

# Implementation
*ToolShell* [[testBuild]]