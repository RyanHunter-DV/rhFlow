A certain config is to generate a certain purposed design context. It can declare the views, parameters, and tool options that to run.
A config is build for certain purpose of a design context, which contains all meta-data that required for a certain usage, and all options and parameters to generate the target database according to current meta-data.
So it supports:
# Design instance
A design being loaded into current tool, will be shown as a global method name that can be called with the view name as one of the args. By doing so, users can specify what kind of the meta-data will be used by current config.
Example:
```
config :ConfigName do
  ADefinedDesign(:viewname)
  # options such as tool configurations, generator options
  # parameters for a component
  # features, TBD
end
```
# Options used to process this config
The options indicate to the tool options, such as generator tools, EDA tools and so on. By using of options, can specify the special options when this config being called by that tool.
Brief example:
```
config :ConfigName do
  ADefinedDesign(:viewname)
  opt compile, '-A "option string"','-B "option string"',...
  # the nested components will be automatically instantiated into the design,
  # same hierarchy as the component.
  opt design.compA.generator, '-A "option string"',...
end
```
The opt command used by a config block will specify the options of a certain tool, The Config object will have built in tool, which are: compile, elab, run, they are the simulator, may be vcs, or xsim, are provided by `simulator` command of the config.
# Simulator specification
As above said, a config can use `simulator` command to specify a simulator tool to run, just like:
```
config :name do
  simulator :vcs
  simulator :xrun
  simulator :questa # TBD
end
```
# Parameters for components
Parameter used for component meta-data to define a configurable variable for such component data, in config, if users want to use a different parameter, then it need to change it like:
```
config :name do
  ADefinedDesign(:view)
  design.compA.param :pa=>'value string', ...
end
```
# Features for components
component can have features defined in a design or config, this is #TBD later.
# Clone a config
when defining a config, can use a clone to get all executions from the cloned config.