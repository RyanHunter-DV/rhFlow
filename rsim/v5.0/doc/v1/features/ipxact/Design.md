Design, which is also means a design context, is collection of all components which will be included while loading it. The design can have component instances with specific views. #PH
# view
A certain view of a design can be used to setup certain component instances, generator and tool options, by which a config can be easier by just using a certain view of a design.
# component instance
A component shall be explicitly instantiated if it want to be added in to a design, for example:
```ruby
design :name do
	view :viewname do
		instance 'ComponentA', :variant=> :variantname, :as=> :aliasname
		...
	end
	...
end
```