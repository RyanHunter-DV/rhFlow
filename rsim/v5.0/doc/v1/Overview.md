This chapter will list all possible usage/issues or features this tool are going to solve, it's kind of a very beginning state to collecting requirements and provide the features, and because of the lack of experience, this chapter may continue updating.
# Features
This chapter depicts the target build goal of Rsim tool.
## Flexible step specification to run the tool
**BuildOnly**
The BuildOnly feature let user to call the tool to build target HDL & Verif files only. Support building multiple config targets by multiple using the `-b <ConfigName>` option.
Details in [[v5.0/doc/v1/features/BuildOnly|BuildOnly]].
**CompileOnly**
#TBD 
**RunOnly**
#TBD 
**ManuallyStepChosen**
#TBD 

#TBD more other features

## Support loading ipxact based user nodes
The user nodes are simply ruby extension files, but can call pre-defined ipxact based flow methodology commands to specify user customized database.
### Design configuration
The design configuration in ipxact is used to build a specific project with the included design. The design can be configured for:
- different views, such as RTL view for synthesis, simulation view etc.
- tool options, can set options for different generator tool chains, simulator tools.
- parameters, define and overrides parameters for different components.
- Need configuration, the included design cannot be directly published to target, unless users has set a `need` command, which will explicitly need a component for this config.
More features and details in [[features/ipxact/Config|Config]]. #TBD , need build the details
### Design
The design is the only top meta-data collection of a project. It'll collect all available components within this project.
- Support component instance, by which can set alias name for a component so that it can be easily operated by the design configuration.
More details in [[features/ipxact/Design|Design]] #TBD , need build the details
### Component
Component is the central placeholder for the meta-data designs, such as HDL or Verif sources.
- Specify source files/dirs, a component must shall specify the source files/dirs that this component mainly operate on.
- Specify generator, while building this component, the generator will be called.
- Parameter definition, looks like a local config for component, for example, by using of the parameter can specify different filesets.
- Nested component, if a component that will use another component(s), then can use a `need` command to declare the reliance relations.
- busInterface, channel etc more features for HDL shall be added #TBD
More details in [[features/ipxact/Component|Component]] #TBD , need build the details.
## Support exporting a design and corresponding configuration for integration
#TBD 



--- 