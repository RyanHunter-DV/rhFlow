This chapter will list all possible usage/issues or features this tool are going to solve, it's kind of a very beginning state to collecting requirements and provide the features, and because of the lack of experience, this chapter may continue updating.

# Build only.
#TBD 
# Compile only.
#TBD 
# Run only.
#TBD 
# Manually step chosen.
Manually add/skip certain steps, just like: ‘<comp,run>’, then will compile and run the flow, attention that steps like ‘<build,run>’ is illegal, but tool will not report error specifically for this kind of operation.

# Regression support

Two types of the regression like simulation will be support, both of which will first try to build and compile a database, then run the remaining tests.

## Run a list of tests.

local run a certain list of tests, by giving a test list file.

## Formal regression.

formal regression support, with specific options being forced, such as wave dump disabled, UVM verbosity to ‘NONE’ level.

# Show available test lists.

'rsim -L', to list all available tests read by tool.

# RhDass flow
This flow used to generate `*.vsrc` file into HDL module.
#TBD

# Elaborating IP-XACT based meta-data.
See details in [[IP-XACTBase]] chapter.
