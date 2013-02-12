require 'spec_helper'

module ChefSpec
  module Matchers
    describe :be_owned_by do
      describe "#match" do
        let(:matcher) { be_owned_by('user', 'group') }
        it "should not match when the file is nil" do
          matcher.matches?(nil).should be false
        end
        it "should not match when both the user and group are different" do
          matcher.matches?({:owner =>'diff_user', :group =>'diff_group'}).should be false
        end
        it "should not match when the owning user is different" do
          matcher.matches?({:owner =>'diff_user', :group =>'group'}).should be false
        end
        it "should not match when the owning group is different" do
          matcher.matches?({:owner =>'user', :group =>'diff_group'}).should be false
        end
        it "should match when the user and group match" do
          matcher.matches?({:owner =>'user', :group =>'group'}).should be true
        end
      end
    end

    describe :create_remote_file do
      describe "#match" do
        let(:attributes) do
          { :resource_name => 'remote_file',
            :path          => '/tmp/foo',
            :source        => 'http://www.example.com/foo',
            :checksum      => 'deadbeef',
            :action        => :create }
        end
        def do_match(changed_attributes)
          matcher.matches?(:resources => [attributes.merge(changed_attributes)])
        end
        let(:matcher) { create_remote_file('/tmp/foo') }
        it "should not match when no resource with the expected path exists" do
          do_match(:path => '/tmp/bar').should be false
        end
        it "should not match when the action is not :create" do
          do_match(:action => :create_if_missing).should be false
        end
        it "should match when a remote file with the expected path exists" do
          do_match(attributes).should be true
        end
        it "should match when the resource action is an array element" do
          do_match(:action => [:create]).should be true
        end
        it "should match when the resource action is a string" do
          do_match(:action => 'create').should be true
        end

        describe "#with" do
          let(:matcher) do
            create_remote_file('/tmp/foo').with(
                               :source   => 'http://www.example.com/foo',
                               :checksum => 'deadbeef')
          end
          it "should not match when no remote file with the expected path exists" do
            do_match(:path => '/tmp/bar').should be false
          end
          it "should not match when the checksum differs" do
            do_match(:checksum => 'cafebabe').should be false
          end
          it "should match when a remote file with the expected path exists" do
            do_match(attributes).should be true
          end
          it "should match when the remote file has additional attributes" do
            do_match(:smells_like_peanut_butter => true).should be true
          end

          context "when the attribute is :source" do
            def match_sources(expected,actual)
              create_remote_file('/tmp/foo').
                with(:source => expected).
                matches?(:resources => [attributes.merge(:source => actual)])
            end

            [
              [  'foo'  ,  'foo'  ],
              [  'foo'  , ['foo'] ],
              [ ['foo'] ,  'foo'  ],
              [ ['foo'] , ['foo'] ]
            ].each do |expected,actual|
              it "should match with equal sources" do
                match_sources(expected, actual).should be true
              end
            end

            [
              [  'foo'  ,  'bar'  ],
              [  'foo'  , ['bar'] ],
              [ ['foo'] ,  'bar'  ],
              [ ['foo'] , ['bar'] ],
            ].each do |expected,actual|
              it "should not match with different sources" do
                match_sources(expected, actual).should be false
              end
            end
          end
        end
      end
    end
  end
end
