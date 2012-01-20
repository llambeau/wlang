module WLang
  class Compiler
    class ProcCallRemoval < Filter

      recurse_on :template, :strconcat, :wlang, :modulo

      def on_fn(core)
        if core.first == :static
          [:arg, core.last]
        else
          [:fn, call(core)]
        end
      end

    end # class ProcCallRemoval
  end # class Compiler
end # module WLang
