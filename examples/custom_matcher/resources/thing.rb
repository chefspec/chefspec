actions :install, :remove
default_action :install

attribute :name,   kind_of: String, name_attribute: true
attribute :config, kind_of: [TrueClass, FalseClass]
