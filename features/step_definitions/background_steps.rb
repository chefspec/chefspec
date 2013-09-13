Given /^I am using the "(.+)" cookbook$/ do |cookbook|
  FileUtils.cp_r(File.join('examples', cookbook), current_dir)
  cd(cookbook)
end
