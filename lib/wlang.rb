require "wlang/version"
require "wlang/loader"
#
# WLang is a powerful code generation and templating engine
#
module WLang

  # These are allows block symbols
  SYMBOLS = "!^%\"$&'*+?@~#,-./:;=<>|_".chars.to_a

  # Template braces
  BRACES = ['{', '}']

  # Defines an anonymous dialect on the fly.
  #
  # Example:
  #
  #   d = WLang::dialect do
  #     tag('$') do |buf,fn| buf << evaluate(fn) end
  #     ...
  #   end
  #   d.render("Hello ${who}!", :who => "world")
  #   # => "Hello world!"
  #
  def dialect(superdialect = WLang::Dialect, &defn)
    Class.new(superdialect, &defn)
  end
  module_function :dialect

end # module WLang
require 'wlang/compiler'
require 'wlang/template'
require 'wlang/dialect'
require 'wlang/scope'
