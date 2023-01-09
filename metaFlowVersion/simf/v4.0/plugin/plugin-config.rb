plugin 'xcelium' do
	xlm = Xcelium.new(self,Context.debug);
    self.instance_variable_set('@xcelium',xlm);
    self.define_singleton_method :xcelium do
        return @xcelium;
    end
end
