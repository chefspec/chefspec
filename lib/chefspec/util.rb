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

    #
    # Remove leading and trailing blank lines, and trailing whitespace from each
    # line. This is useful for matching the content in a config file, when this
    # whitespace doesn't typically matter.
    #
    # @param [String] string
    #   the string to trim whitespace off of
    #
    def remove_config_file_whitespace(string)
      lines = string.lines
      # remove leading and trailing blank lines
      lines.shift while lines.first.strip.empty?
      lines.pop while lines.last.strip.empty?
      # remove trailing whitespace from lines
      lines.map(&:rstrip).join("\n")
    end
  end
end
