osx_profile 'explicit_action' do
  profile 'screensaver/com.company.screensaver.mobileconfig'
  action :install
end

osx_profile 'implicit_action' do
  profile 'screensaver/com.company.screensaver.mobileconfig'
end
