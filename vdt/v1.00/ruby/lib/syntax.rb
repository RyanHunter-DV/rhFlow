
class VdtsSyntax; ## {

	attr :singleComment, :multiCommentStart, :multiCommentEnd;

	def initialize useSyntax=:default; ## {{{
		setSingleCommentMark(useSyntax);
	end ## }}}


	public
	def detectCommentTypeAndPos(line); ## {
		index = 0;
		line.each_char do ## {
			|c|
		end ## }
	end ## }



	private
	def setSingleCommentMark(t); ## {{{
		@singleComment='//' if (t==:default);
		@multiCommentStart='/*' if (t==:default);
		@multiCommentEnd='*/' if (t==:default);
	end ## }}}

	def matchWithIndex(str,ptrn); ## {
		index = 0;
		str.each_char do ## {
			|c|
			## TODO
		end ## }
	end ## }

end ## }
