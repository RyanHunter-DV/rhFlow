Design, which is also means a design context, is collection of all components which will be included while loading it. The design can have component instances with specific views. #PH
# view
A certain view of a design can be used to setup certain component instances, generator and tool options, by which a config can be easier by just using a certain view of a design.
## inheritance in view
For different view, which will have different component instance, but in some circumstance, two or more views may have same component instances, to reduce the coding of component instance, the view has ability to inherit from other views, which will reuse the component instances in other view.

```ruby
design :name do

	view :common do
		instance 'A',:as => :a0
	end
	view :subb, :clones => :common do
		isntance "B", :as=> :b0
	end

end
```

#TBD 

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