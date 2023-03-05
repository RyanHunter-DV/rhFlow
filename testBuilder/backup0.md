#testBuilder
# Overview
## Use Cases
#TODO 
## Feature list
#TODO 
- [[#Easy install and setup]];
- can be a standalone tool, or plugged into an other tool;
- generate tests/sequences based on a testplan or DR_VR table;
	- [[#Required DR_VR format]]
- 


# Detailed features
## Required DR_VR format
#Focused 

## Easy install and setup



---
**Code Divider**

# Features
## support plug into a program
It can be a plugin being plugged into a tool such as fsim.
call like:
```ruby
TestBuilder.setup(xxx)
TestBuilder.loadSource(file)
TestBuilder.finalize(xxx)
TestBuilder.publish(xxx)
```
#TODO 

## build base test
The base test is being built from a test template. A template will build a typical base test. While a full customized template can be built through the basic sv class builder
*user inputs example*:
```ruby
template :basename do
	env 'envname'
	run do
	end
	flow 'init','xxx' do
		xxx
	end
end
```
### template command
This is a global command to setup a test template, with its block being evaluated in a `TestTemplate` object. commands in `TestTemplate`:
- env, setup the env typename, which used to generate code to create an env
- 
## build tests from template

## built-in information
### testloop
This is available for all tests, it's the maximum loop for a test to run from init -> final

## sv class builder
we'll require database of `SVField`, `SVMethod`, and `SVClass` from a codelib to support a class build in this tool
The global command `template` supports to build a UVM class from class builder when an option is entered, example:
```ruby
template :name,:custom do
	# then codes here should compliant to the SVClass
end
```
When using custom template, the builder will be changed to ClassBuilder, the detailed code of defining the template are: [[#global template method]]




# codelib
**file** `lib_v1/svField.rb`
**rbcode** `SVField`
**file** `lib_v1/svMethod.rb`
**rbcode** `SVMethod`
**file** `lib_v1/svClass.rb`
**rbcode** `SVClass`



# TestBuilder
**file** `lib_v1/testBuilder.rb`
**module** `TestBuilder`

## global template method
#MARK
**def** `template(n,t=:default,&block)`
