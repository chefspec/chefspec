require 'chef/run_context/cookbook_compiler'

Chef::RunContext::CookbookCompiler.prepend(Module.new do
  # List of compile phases as of Chef 14:
  # compile_libraries
  # compile_ohai_plugins
  # compile_attributes
  # compile_lwrps
  # compile_resource_definitions
  # compile_recipes

  #
  # Compile phases that should only ever run once, globally.
  #

  def load_libraries_from_cookbook(cookbook)
    return super unless $CHEFSPEC_MODE
    $CHEFSPEC_LIBRARY_PRELOAD ||= {}
    # Already loaded this once.
    return if $CHEFSPEC_LIBRARY_PRELOAD[cookbook]
    $CHEFSPEC_LIBRARY_PRELOAD[cookbook] = true
    super
  end

  def load_ohai_plugins_from_cookbook(cookbook)
    return super unless $CHEFSPEC_MODE
    $CHEFSPEC_OHAI_PRELOAD ||= {}
    # Already loaded this once.
    return if $CHEFSPEC_OHAI_PRELOAD[cookbook]
    $CHEFSPEC_OHAI_PRELOAD[cookbook] = true
    super
  end

  def load_lwrps_from_cookbook(cookbook)
    return super unless $CHEFSPEC_MODE
    $CHEFSPEC_LWRP_PRELOAD ||= {}
    # Already loaded this once.
    return if $CHEFSPEC_LWRP_PRELOAD[cookbook]
    $CHEFSPEC_LWRP_PRELOAD[cookbook] = true
    super
  end

  def load_resource_definitions_from_cookbook(cookbook)
    return super unless $CHEFSPEC_MODE
    $CHEFSPEC_DEFINITION_PRELOAD ||= {}
    # Already loaded this once.
    return if $CHEFSPEC_DEFINITION_PRELOAD[cookbook]
    $CHEFSPEC_DEFINITION_PRELOAD[cookbook] = true
    super
  end

  #
  # Compile phases that should not run during preload
  #

  def compile_ohai_plugins
    return super unless $CHEFSPEC_MODE
    return if $CHEFSPEC_PRELOAD
    super
  end

  def compile_attributes
    return super unless $CHEFSPEC_MODE
    return if $CHEFSPEC_PRELOAD
    super
  end

  def compile_recipes
    return super unless $CHEFSPEC_MODE
    return if $CHEFSPEC_PRELOAD
    super
  end
end)
