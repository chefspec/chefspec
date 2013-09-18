require 'spec_helper'

module ChefSpec
  module Matchers
    describe :shared do
      describe '#define_resource_matchers' do
        it 'defines one matcher per action for the provided resource' do
          define_resource_matchers([:reverse, :drive, :brake], [:car], :car_name)
          [:reverse_car, :drive_car, :brake_car].each do |matcher|
            expect(matcher_defined?(matcher)).to be_true
          end
        end

        it 'defines one matcher per action for provided resources' do
          define_resource_matchers([:swing], [:golf_club, :cricket_bat], :name)
          expect(matcher_defined?(:swing_golf_club)).to be_true
          expect(matcher_defined?(:swing_cricket_bat)).to be_true
        end

        it 'defines a matcher that matches on resource type, name and action' do
          define_resource_matchers([:tail], [:log], :name)
          expect(tail_log('Hello')).to be_matches({
            resources: [{
              resource_name: 'log',
              action: 'tail',
              name: 'Hello'
            }]
          })
        end

        it 'defines a matcher that matches on resource type, name and action using a regexp for the name' do
          define_resource_matchers([:tail], [:log], :name)
          expect(tail_log(/He[l]+o/)).to be_matches({
            resources: [{
              resource_name: 'log',
              action: 'tail',
              name: 'Hello'
            }]
          })
        end

        it 'defines a matcher that matches on resource type, name and action using a regexp for the name and returns false' do
          define_resource_matchers([:tail], [:log], :name)
          expect(tail_log(/DoesntMatch/)).to_not be_matches({
            resources: [{
              resource_name: 'log',
              action: 'tail',
              name: 'Hello'
            }]
          })
        end

        it 'defines a should failure message' do
          define_resource_matchers([:climb], [:mountain], :name)
          expect(climb_mountain('everest').failure_message_for_should).to eq("No mountain resource matching name 'everest' with action :climb found.")
        end

        it 'defines a dynamically built should_not failure message' do
          define_resource_matchers([:climb], [:mountain], :name)
          matcher = climb_mountain(/Kili/)
          matcher.matches?({ resources: [{:resource_name => 'mountain', :action => 'climb', :name => 'Kilimanjaro'}] })
          expect(matcher.failure_message_for_should_not).to eq("Found mountain resource named 'Kilimanjaro' matching name: '(?-mix:Kili)' with action :climb that should not exist.")
        end

        describe '#with' do
          let(:matcher) { climb_mountain('Kilimanjaro').with(speed: :quick, team_size: (3..5), comment: /managed\b/)}
          let(:resource) do
            {
              node: {},
              resources: [{
                resource_name: 'mountain',
                name: 'Kilimanjaro',
                speed: :quick,
                comment: 'We managed it!',
                team_size: 5,
                action: :climb,
              }]
            }
          end

          it 'matches when we have exact match' do
            expect(matcher).to be_matches(resource)
          end

          it 'matches when the mountain has additional attributes' do
            resource[:resources].first[:path] = :straight
            expect(matcher).to be_matches(resource)
          end

          it 'does not match when name is wrong' do
            resource[:resources].first[:name] = 'Everest'
            expect(matcher).to_not be_matches(resource)
          end

          it 'does not match when the additional attribute (speed) differs' do
            resource[:resources].first[:speed] = :slow
            expect(matcher).to_not be_matches(resource)
          end

          it 'does not match when Regex fails to match' do
            resource[:resources].first[:comment] = 'Different comment!'
          	expect(matcher).to_not be_matches(resource)
          end

          it 'does not match when Range fails to match' do
            resource[:resources].first[:team_size] = (1..3)
          	expect(matcher).to_not be_matches(resource)
          end
        end
        
        describe "#with" do
          let(:resource) do
            { :resource_name => 'mountain',
              :name => 'Kilimanjaro',
              :speed => :quick,
              :comment => "We managed it!",
              :team_size => 5,
              :action => :climb }
          end
          let(:matcher) { climb_mountain('Kilimanjaro').with(:speed => :quick, :team_size => (3..5), :comment => /managed\b/)}
          it "matches when we have exact match" do
            expect( matcher ).to be_matches(:resources => [resource])
          end
          it "matches when the mountain has additional attributes" do
            expect( matcher ).to be_matches(:resources => [resource.merge(:path => :straight)])
          end
          it "does not match when name is wrong" do
            expect( matcher ).to_not be_matches(:resources => [resource.merge(:name => 'Everest')])
          end
          it "does not match when the additional attribute (speed) differs" do
            expect( matcher ).to_not be_matches(:resources => [resource.merge(:speed => :slow)])
          end
          it "does not match when Regex fails to match" do
          	expect( matcher ).to_not be_matches(:resources => [resource.merge(:comment => "We managedit!")])
          end
          it "does not match when Range fails to match" do
          	expect( matcher ).to_not be_matches(:resources => [resource.merge(:team_size => (1..3))])
          end
        end
      end

      describe '#resource_actions' do
        context 'array of symbols' do
          let(:resource) { double(:action => [:shake, :stir]) }
          it 'returns an array with symbols converted to strings' do
            expect(resource_actions(resource)).to eq(['shake', 'stir'])
          end
        end

        context 'symbol' do
          let(:resource) { double(:action => :shake) }
          it 'return an array containing the stringified symbol' do
            expect(resource_actions(resource)).to eq(['shake'])
          end
        end

        context 'string' do
          let(:resource) { double(:action => 'stir') }
          it 'returns an array containing the string' do
            expect(resource_actions(resource)).to eq(['stir'])
          end
        end
      end
    end
  end
end
