## global def::feature, used to add features to specific caller
#
class DesignFeature; ##{{{

	attr :name,:value;

	def initialize name,val ##{{{
		@name  = name;
		@value = val;
	end ##}}}


end ##}}}

class FeatureRegistry; ##{{{
end ##}}}


def feature *args ##{{{
	## branch for adding new features
	if args.size == 2
		ft = DesignFeature.new(args[0].to_s,args[1]);
		self.addFeature(ft);
		return;
	end

	## branch for getting feature value
	return self.getFeatureRegistry;

end ##}}}
