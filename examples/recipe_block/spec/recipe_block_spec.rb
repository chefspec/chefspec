describe 'recipe block' do
  platform 'ubuntu', '16.04'
  recipe do
    log 'this is a recipe block'
  end

  it { expect(chef_run).to write_log('this is a recipe block') }
  it { expect(subject).to write_log('this is a recipe block') }
  it { is_expected.to write_log('this is a recipe block') }
end

describe 'complex recipe block' do
  platform 'ubuntu', '16.04'
  recipe do
    package 'apache2' do
      version '1.2.3'
    end
    template '/etc/apache2/apache2.conf' do
      source 'apache2.conf.erb'
      owner 'root'
      variables platform: node['platform']
    end
    service 'apache2' do
      action [:start, :enable]
      subscribes :restart, 'template[/etc/apache2/apache2.conf]'
    end
  end

  it { is_expected.to install_package('apache2').with(version: '1.2.3') }
  it { is_expected.to render_file('/etc/apache2/apache2.conf').with_content("Hello ubuntu\n") }
  it { is_expected.to start_service('apache2') }
  it { is_expected.to enable_service('apache2') }
  it { expect(chef_run.template('/etc/apache2/apache2.conf')).to notify('service[apache2]') }
end
