module ChefSpec
  module Util
    extend self

    #
    # Covert the given CaMelCaSeD string to under_score. Graciously borrowed
    # from http://stackoverflow.com/questions/1509915.
    #
    # @param [String] string
    #   the string to use for transformation
    #
    # @return [String]
    #
    def underscore(string)
      string
        .to_s
        .gsub(/::/, '/')
        .gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2')
        .gsub(/([a-z\d])([A-Z])/,'\1_\2')
        .tr('-', '_')
        .downcase
    end

    #
    # Convert an underscored string to it's camelcase equivalent constant.
    #
    # @param [String] string
    #   the string to convert
    #
    # @return [String]
    #
    def camelize(string)
      string
        .to_s
        .split('_')
        .map { |e| e.capitalize }
        .join
    end

    #
    # Truncate the given string to a certain number of characters.
    #
    # @param [String] string
    #   the string to truncate
    # @param [Hash] options
    #   the list of options (such as +length+)
    #
    def truncate(string, options = {})
      length = options[:length] || 30

      if string.length > length
        string[0..length-3] + '...'
      else
        string
      end
    end
  end
end
