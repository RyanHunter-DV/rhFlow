

class const: ## {

	class constError(BaseException): pass ## TODO

	def __setattr__(self,key,value): ## {
		if self.__dict__.has_key(key):
			raise self.constError("Changing constant "+key);
		else:
			self.__dict__[key] = value;
	## }

	def __getattr__(self,key): ## {
		if self.__dict__.has_key(key):
			## return self.__dict__[key];
			return self.key;
		else:
			return None;
	## }
## }
