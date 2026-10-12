module TestHelper
  def helper_method
    'hello'
  end
end

template '/tmp/template_with_helper' do
  helpers TestHelper
end

template '/tmp/template_with_variables' do
  source 'template_with_variables.erb'
end
