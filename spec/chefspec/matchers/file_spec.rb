require 'spec_helper'

module ChefSpec
  module Matchers
    describe :be_owned_by do
      describe '#match' do
        let(:matcher) { be_owned_by('user', 'group') }

        it 'does not match when the file is nil' do
          expect(matcher).to_not be_matches(nil)
        end

        it 'does not match when both the user and group are different' do
          expect(matcher).to_not be_matches({ owner: 'diff_user', group: 'diff_group' })
        end

        it 'does not match when the owning user is different' do
          expect(matcher).to_not be_matches({ owner: 'diff_user', group: 'group' })
        end

        it 'does not match when the owning group is different' do
          expect(matcher).to_not be_matches({ owner: 'user', group: 'diff_group' })
        end

        it 'matches when the user and group match' do
          expect(matcher).to be_matches({ owner: 'user', group: 'group' })
        end
      end
    end

    shared_examples('remote_file_template') do |remote_file_matcher, action|
      describe remote_file_matcher.to_sym do
        describe '#match' do
          let(:matcher) { send(remote_file_matcher, '/tmp/foo') }
          let(:chef_run) do
            {
              node: {},
              resources: [{
                resource_name: 'remote_file',
                path: '/tmp/foo',
                source: 'http://www.example.com/foo',
                checksum: 'deadbeef',
                action: action.to_sym
              }]
            }
          end

          it 'does not match when no resource with the expected path exists' do
            chef_run[:resources].first[:path] = '/tmp/bar'
            expect(matcher).to_not be_matches(chef_run)
          end

          it 'does not match when the action is not #{remote_file_matcher.to_sym}' do
            chef_run[:resources].first[:action] = :righteous
            expect(matcher).to_not be_matches(chef_run)
          end

          it 'matches when a remote file with the expected path exists' do
            expect(matcher).to be_matches(chef_run)
          end

          it 'matches when the resource action is an array element' do
            chef_run[:resources].first[:action] = Array(action.to_sym)
            expect(matcher).to be_matches(chef_run)
          end

          it 'matches when the resource action is a string' do
            chef_run[:resources].first[:action] = action.to_s
            expect(matcher).to be_matches(chef_run)
          end

          describe '#with' do
            let(:matcher) { send(remote_file_matcher, '/tmp/foo').with(source: 'http://www.example.com/foo', checksum: 'deadbeef') }

            it 'does not match when no remote file with the expected path exists' do
              chef_run[:resources].first[:path] = '/tmp/bar'
              expect(matcher).to_not be_matches(chef_run)
            end

            it 'does not match when the checksum differs' do
              chef_run[:resources].first[:checksum] = 'cafebabe'
              expect(matcher).to_not be_matches(chef_run)
            end

            it 'matches when a remote file with the expected path exists' do
              expect(matcher).to be_matches(chef_run)
            end

            it 'should match when the remote file has additional attributes' do
              chef_run[:resources].first[:smells_like_peanut_butter] = true
              expect(matcher).to be_matches(chef_run)
            end

            context 'when the attribute is :source' do
              [
                [  'foo'  ,  'foo'  ],
                [  'foo'  , ['foo'] ],
                [ ['foo'] ,  'foo'  ],
                [ ['foo'] , ['foo'] ]
              ].each do |expected, actual|
                it 'should match with equal sources' do
                  expect(send(remote_file_matcher, '/tmp/foo').with(source: expected)).to be_matches({
                    node: {},
                    resources: [chef_run[:resources].first.merge(source: actual)]
                  })
                end
              end

              [
                [  'foo'  ,  'bar'  ],
                [  'foo'  , ['bar'] ],
                [ ['foo'] ,  'bar'  ],
                [ ['foo'] , ['bar'] ],
              ].each do |expected,actual|
                it 'should not match with different sources' do
                  expect(send(remote_file_matcher, '/tmp/foo').with(source: expected)).to_not be_matches({
                    node: {},
                    resources: [chef_run[:resources].first.merge(source: actual)]
                  })
                end
              end
            end
          end
        end
      end
    end

    describe :create_remote_file do
      it_should_behave_like 'remote_file_template', 'create_remote_file', 'create'
    end

    describe :create_remote_file_if_missing do
      it_should_behave_like 'remote_file_template', 'create_remote_file_if_missing', 'create_if_missing'
    end
  end
end
