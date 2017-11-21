# Example of a whyrun_safe_ruby_block that will execute when test is run

ruby_block 'foo' do
  block do
    @name = 'bar'
  end
  action :run
end

whyrun_safe_ruby_block 'bah' do
  block do
    @name = 'baz'
  end
  action :run
end
