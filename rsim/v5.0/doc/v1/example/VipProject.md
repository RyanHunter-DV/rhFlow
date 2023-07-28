Two majority of the Vip project, one is used for local running examples, and another is for formal project using, which means this project will be required by other projects.

# Local running example

- root.rh, the root entry of local running.
    

```
rhload 'src/node' # load nodes
```

- vip component node:
    

```
component :VipComp do
  need :uvm # to include uvm component
  fileset 'package.sv'
  generator :default
end
```

- env component node:
    

```
component :VipEnv do
  need :uvm
  fileset 'EnvPackage.sv'
  generator :default
end
```

- design node:
    

```
design :VipExample do
  component :VipComp, :as=>:vip
  component :VipEnv, :as=>:env

  view :sim do
    design.vip.view(:sim)
    design.env.view(:sim)
  end
end
```

- config node:
    

```
config :BaseConfig do
  simulator :vcs
end
```

clone feature of a config

```
config :AceConfig, :clones=>:BaseConfig do

end
```

```
config :NoAceConfig, :clones=>:BaseConfig do
  VipExample(:sim)
  opt compile, '+define+
end
```