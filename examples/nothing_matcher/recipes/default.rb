ruby_block "yes" do
  block {}
end

ruby_block "no" do
  action :nothing
  block {}
end

ruby_block "both" do
  action %i{run nothing}
  block {}
end
