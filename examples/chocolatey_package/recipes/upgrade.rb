chocolatey_package '7zip' do
  action :upgrade
end

chocolatey_package 'git' do
  version '2.7.1'
  action :upgrade
end
