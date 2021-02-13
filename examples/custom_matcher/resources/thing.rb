actions :install, :remove
default_action :install

attribute :config, kind_of: [TrueClass, FalseClass]
