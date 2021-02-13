chocolatey_package '7zip'

chocolatey_package 'git' do
  version '2.7.1'
  options '--params /GitAndUnixToolsOnPath'
end
