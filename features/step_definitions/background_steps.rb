Given /^I am using the "(.+)" cookbook$/ do |cookbook|
  source      = File.join('examples', cookbook)
  destination = expand_path('.')

  FileUtils.cp_r(source, destination)
  cd(cookbook)
end
