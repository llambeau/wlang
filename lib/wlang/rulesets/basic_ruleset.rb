require 'wlang/rulesets/ruleset_utils'
module WLang
  class RuleSet
    
    #
    # Basic ruleset, commonly included by any wlang dialect (but some tags, like
    # <tt>${...}</tt> may be overriden). This ruleset is often installed conjointly
    # with WLang::RuleSet::Encoding which provides interresting overridings of 
    # <tt>${...}</tt> and <tt>+{...}</tt>. 
    #
    # For an overview of this ruleset, see the wlang {specification file}[link://files/specification.html].
    #
    module Basic
      U=WLang::RuleSet::Utils
  
      # Default mapping between tag symbols and methods
      DEFAULT_RULESET = {'!' => :execution, '%' => :modulation, '^' => :encoding,
                         '+' => :inclusion, '$' => :injection, '%!' => :recursive_application}
  
      # Rule implementation of <tt>!{wlang/ruby}</tt>.
      def self.execution(parser, offset)
        expression, reached = parser.parse(offset, "wlang/ruby")
        value = parser.evaluate(expression)
        result = value.nil? ? "" : value.to_s
        [result, reached]
      end
  
      # Rule implementation of <tt>%{wlang/active-string}{...}</tt>.
      def self.modulation(parser, offset)
        dialect, reached = parser.parse(offset, "wlang/active-string")
        result, reached = parser.parse_block(reached, dialect)
        [result, reached]
      end
  
      # Rule implementation of <tt>^{wlang/active-string}{...}</tt>
      def self.encoding(parser, offset)
        encoder, reached = parser.parse(offset, "wlang/active-string")
        result, reached = parser.parse_block(reached)
        result = parser.encode(result, encoder)
        [result, reached]
      end
    
      # Rule implementation of <tt>${wlang/ruby}</tt>
      def self.injection(parser, offset)
        execution(parser, offset)
      end
  
      # Rule implementation of <tt>+{wlang/ruby}</tt>
      def self.inclusion(parser, offset)
        execution(parser, offset)
      end
  
      # Rule implementation of <tt>%!{wlang/ruby using ... with ...}</tt>
      def self.recursive_application(parser, offset)
        dialect, reached = parser.parse(offset, "wlang/active-string")
        text, reached = parser.parse_block(reached)
    
        # decode expression
        decoded = U.expr(:qdialect, 
                         ["using", :expr, false], 
                         ["with",  :with, false]).decode(dialect, parser)
        parser.syntax_error(offset) if decoded.nil?
    
        # build context
        context = U.context_from_using_and_with(decoded)
    
        # instantiate
        instantiated = WLang::instantiate(text, context, decoded[:qdialect])
        [instantiated, reached]
      end
  
    end  # module Basic
  
  end
end