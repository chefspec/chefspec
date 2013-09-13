module ChefSpec
  class Error < StandardError; end

  class CommandNotStubbedError < Error
    def initialize(command)
      message =  "Real commands are disabled. Unregistered command: `#{command}`"
      message << "\n\n"
      message << "You can stub this command with:"
      message << "\n\n"
      message << "  #{Stubs::CommandStub.new(command).and_return(true).signature}"

      unless Stubs::CommandRegistry.stubs.empty?
        message << "\n\n"
        message << "registered command stubs:"
        message << "\n"

        Stubs::CommandRegistry.stubs.each do |command|
          message << "\n  #{command.signature}"
        end
      end

      message << "\n\n"
      message << "="*60
      super(message)
    end
  end

  class SearchNotStubbedError < Error
    def initialize(type, query)
      message =  "Real searches are disabled. Unregistered search: search(#{type.inspect}, #{query.inspect})"
      message << "\n\n"
      message << "You can stub this search with:"
      message << "\n\n"
      message << "  #{Stubs::SearchStub.new(type, query).and_return({}).signature}"

      unless Stubs::SearchRegistry.stubs.empty?
        message << "\n\n"
        message << "registered search stubs:"
        message << "\n"

        Stubs::SearchRegistry.stubs.each do |search|
          message << "\n  #{search.signature}"
        end
      end

      message << "\n\n"
      message << "="*60
      super(message)
    end
  end

  class DataBagNotStubbedError < Error
    def initialize(bag)
      message =  "Real data_bags are disabled. Unregistered data_bag: data_bag(#{bag.inspect})"
      message << "\n\n"
      message << "You can stub this data_bag with:"
      message << "\n\n"
      message << "  #{Stubs::DataBagStub.new(bag).and_return({}).signature}"

      unless Stubs::DataBagRegistry.stubs.empty?
        message << "\n\n"
        message << "registered data_bag stubs:"
        message << "\n"

        Stubs::DataBagRegistry.stubs.each do |data_bag|
          message << "\n  #{data_bag.signature}"
        end
      end

      message << "\n\n"
      message << "="*60
      super(message)
    end
  end

  class DataBagItemNotStubbedError < Error
    def initialize(bag, id)
      message =  "Real data_bag_items are disabled. Unregistered search: data_bag_item(#{bag.inspect}, #{id.inspect})"
      message << "\n\n"
      message << "You can stub this data_bag_item with:"
      message << "\n\n"
      message << "  #{Stubs::DataBagItemStub.new(bag, id).and_return({}).signature}"

      unless Stubs::DataBagItemRegistry.stubs.empty?
        message << "\n\n"
        message << "registered data_bag_item stubs:"
        message << "\n"

        Stubs::DataBagItemRegistry.stubs.each do |data_bag_item|
          message << "\n  #{data_bag_item.signature}"
        end
      end

      message << "\n\n"
      message << "="*60
      super(message)
    end
  end
end
