require 'spec_helper'

module ChefSpec
  module Matchers
    describe :render_file do
      let(:matcher) { render_file('/etc/foo') }

      ['cookbook_file', 'file', 'template'].each do |type|
        context "a #{type} resource" do
          [:create, :create_if_missing].each do |action|
            let(:chef_run) do
              {
                node: {},
                resources: [{
                  resource_name: type,
                  identity:      '/etc/foo',
                  name:          '/etc/foo',
                  action:        action,
                }]
              }
            end

            it 'does not match when there are no resources' do
              expect(matcher).to_not be_matches({ node: {}, resources: [] })
            end

            it 'does not match when there are other types of resources' do
              expect(matcher).to_not be_matches({
                node: {},
                resources: [{
                  resource_name: 'bacon',
                  identity:      '/etc/foo',
                  name:          '/etc/foo',
                  action:        action,
                }]
              })
            end

            it 'does not match when the resource exists but has the wrong name attribute' do
              expect(matcher).to_not be_matches({
                node: {},
                resources: [{
                  resource_name: type,
                  identity:      '/invalid/path',
                  name:          '/invalid/path',
                  action:        action,
                }]
              })
            end

            it 'matches when the resource exists' do
              expect(matcher).to be_matches(chef_run)
            end

            context '#with_content' do
              let(:matcher) { render_file('/etc/foo').with_content('is content!') }
              let(:regex_matcher) { render_file('/etc/foo').with_content(/^This(.+)$/) }
              let(:stub_method) { "content_from_#{type}".to_sym }

              it 'does not match when the content does not match' do
                ChefSpec::Renderer.stub(:new) { double('renderer', content: 'Not the correct content') }
                expect(matcher).to_not be_matches(chef_run)
              end

              it 'does not match when the content does not match the regex' do
                ChefSpec::Renderer.stub(:new) { double('renderer', content: 'Not the correct content') }
                expect(regex_matcher).to_not be_matches(chef_run)
              end

              it 'matches when the content is an exact match' do
                ChefSpec::Renderer.stub(:new) { double('renderer', content: 'is content!') }
                expect(matcher).to be_matches(chef_run)
              end

              it 'matches when the content is an substring match' do
                ChefSpec::Renderer.stub(:new) { double('renderer', content: 'This is content!') }
                expect(matcher).to be_matches(chef_run)
              end

              it 'matches when the content matches the regular expression' do
                ChefSpec::Renderer.stub(:new) { double('renderer', content: 'This is other stuff') }
                expect(regex_matcher).to be_matches(chef_run)
              end
            end
          end
        end
      end
    end
  end
end
