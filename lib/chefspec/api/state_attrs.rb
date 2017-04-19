module ChefSpec::API
  #
  # Assert that a Chef resource has certain state attributes (since Chef
  # 11.8.0):
  #
  #     state_attrs :time, :temperature
  #
  # @see https://github.com/opscode/chef/blob/e43d7ebda/lib/chef/resource/file.rb#L32-L37
  #
  # The Examples section demonstrates the different ways to test a
  # resource's +state_attrs+ with ChefSpec.
  #
  # @example Assert the +lwrp+ resource has two state attributes
  #   expect(lwrp).to have_state_attrs(:time, :temperature)
  #
  #
  # @param [Array] state_attrs
  #   the list of state attributes to assert
  #
  # @return [ChefSpec::Matchers::StateAttrsMatcher]
  #
  def have_state_attrs(*state_attrs)
    ChefSpec::Matchers::StateAttrsMatcher.new(state_attrs)
  end
end
