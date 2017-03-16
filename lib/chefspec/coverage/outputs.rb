module ChefSpec
   class Coverage
     class Output
       def output(text)
         raise RuntimeError, "Must override Output#output"
       end
     end

     #
     # @example Output results to stdout
     #   add_output PutsOutput.new
     #
     class PutsOutput < Output
       def output(text)
         puts text
       end
     end

     #
     # @example Output results to block for processing
     #   add_output do |output|
     #      puts output
     #   end
     #
     class BlockOutput < Output
       def initialize(&block)
         @block = block
       end

       def output(text)
         @block.call(text)
       end
     end
  end
end
