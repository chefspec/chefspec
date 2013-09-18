require 'spec_helper'

module ChefSpec
  module Matchers
    %w{package yum_package gem_package chef_gem windows_package}.each do |interpreter|
      describe "install_#{interpreter}_at_version" do
        let(:matcher) { send( "install_#{interpreter}_at_version", 'foo', '1.2.3') }

        it 'does not match when no resources exist' do
          expect(matcher).to_not be_matches({ resources: [] })
        end

        it 'does not match when there are no packages' do
          expect(matcher).to_not be_matches({
            node: {},
            resources: [{
              resource_name: 'template',
              path: '/tmp/config.conf',
              source: 'config.conf.erb'
            }]
          })
        end

        it 'does not match if is a different package and an unspecified version' do
          expect(matcher).to_not be_matches({
            node: {},
            resources: [{
              resource_name: interpreter,
              package_name: 'bar',
              version: nil,
              action: :install
            }]
          })
        end

        it 'does not match if it is the same package and version but a different action' do
          expect(matcher).to_not be_matches({
            node: {},
            resources: [{
              resource_name: interpreter,
              package_name: 'foo',
              version: '1.2.3',
              action: :upgrade
            }]
          })
        end

        it 'matches if is the same package, the correct version and the install action' do
          expect(matcher).to be_matches({
            node: {},
            resources: [{
              resource_name: interpreter,
              package_name: 'foo',
              version: '1.2.3',
              action: :install
            }]
          })
        end
      end
    end

    describe :package do
      it 'has right package resources' do
        expect(ChefSpec::ChefRunner::PACKAGE_RESOURCES).to eq %w(package apt_package dpkg_package easy_install_package freebsd_package gem_package macports_package portage_package rpm_package chef_gem solaris_package windows_package yum_package zypper_package python_pip)
      end

      [:install, :upgrade, :remove, :purge].each do |action|
        ChefSpec::ChefRunner::PACKAGE_RESOURCES.each do |interpreter|
          describe interpreter do
            context 'using a string' do
              let(:matcher) { send("#{action}_#{interpreter}", 'libcaca-devel') }
            
              it 'does not match when no resources exist' do
                expect(matcher).to_not be_matches({ resources: [] })
              end
              
              it 'does not match if it is the wrong package' do
                expect(matcher).to_not be_matches({
                  node: {},
                  resources: [{
                    resource_name: interpreter,
                    package_name: 'libcaca',
                    action: action
                  }]
                })
              end
              
              it 'does not match if it is the same package but a different action' do
                expect(matcher).to_not be_matches({
                  node: {},
                  resources: [{
                    resource_name: interpreter,
                    package_name: 'libcaca-devel',
                    action: :nothing
                  }]
                })
              end
              
              it 'does not match when there are no packages' do
                expect(matcher).to_not be_matches({
                  node: {},
                  resources: [{
                    resource_name: 'template',
                    path: '/tmp/config.conf',
                    source: 'config.conf.erb'
                  }]
                })
              end

              it 'matches if it is the same package and action' do
                expect(matcher).to be_matches({
                  node: {},
                  resources: [{
                    resource_name: interpreter,
                    package_name: 'libcaca-devel',
                    action: action
                  }]
                })
              end
            end
            
            context 'when using regex' do
              let(:matcher) { send("#{action}_#{interpreter}", /(ca){2}\-dev(el)?$/) }
    
              it 'matches when using regexp with right action and package' do
                expect(matcher).to be_matches({
                  node: {},
                  resources: [{
                    resource_name: interpreter,
                    package_name: 'libcaca-devel',
                    action: action
                  }]
                })
              end
            end
          end
        end
      end
    end
  end
end
