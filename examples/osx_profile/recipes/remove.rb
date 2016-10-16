osx_profile 'specifying profile' do
  profile 'screensaver/com.company.something.mobileconfig'
  action :remove
end

osx_profile 'screensaver/com.company.screensaver.mobileconfig' do
  action :remove
end
