module ChefSpec::API
  #
  # Assert that a resource subscribes to another. Given a Chef Recipe that
  # subscribes a template resource to restart apache:
  #
  #     service 'apache2' do
  #       subscribes :create, 'template[/etc/apache2/config]'
  #     end
  #
  # The Examples section demonstrates the different ways to test a
  # subscription on a resource with ChefSpec.
  #
  # @example Assert a basic subscription
  #   service = chef_run.service('apache2')
  #   expect(service).to subscribe_to('template[/etc/apache2/config]')
  #
  # @example Assert a subscription with specified action
  #   expect(service).to subscribe_to('template[/etc/apache2/config]').on(:restart)
  #
  # @example Assert a subscription with specified action and timing
  #   expect(service).to subscribe_to('template[/etc/apache2/config]').on(:restart).immediately
  #
  #
  # @param [String] signature
  #   the signature of the notification to match
  #
  # @return [ChefSpec::Matchers::NotificationsMatcher]
  #
  def subscribe_to(signature)
    ChefSpec::Matchers::SubscribesMatcher.new(signature)
  end
end
