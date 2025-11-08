A component is a central place holder for an object meta-data. So it can be defined for a single verilog module, or a standalone IP design.
- Component can have other nested components.

A component can have different [[view]] that for different purpose, to extract information from the meta-data.

# Elements of component
- [[view]], define different views of this component, used for different purpose.
- [[connection]], define external connections of this component object, it's optional element, used specifically for RTL design, and for RTL design, the file also contains instance connectivity information.
- 



# Example
*a single component for an IP*
```ruby
component :IPname do |variant|
	connection 'connectivity_file'
	view :rtl do
		moduleName "IPname_#{variant}"
		comp_opt '-define xxxx'
		parameter ''
		filesets 'path/file.v'
		filesets 'path/fileb.v'
	end
	view :shell do
	end
end
```

*nested components*
```ruby
component :SoCname do |variant|
	connection 'thisConnectivity'
	component :IPname, :as=> :Ip0
	component :IPname2, :as => :Ip2
end
```