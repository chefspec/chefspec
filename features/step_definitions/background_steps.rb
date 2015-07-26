Given /^I am using the "(.+)" cookbook$/ do |cookbook|
  FileUtils.cp_r(File.join('examples', cookbook), expand_path('.'))
  cd(cookbook)
end
