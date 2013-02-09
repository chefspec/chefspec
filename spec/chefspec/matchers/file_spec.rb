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
        let(:matcher) { create_remote_file('/tmp/foo') }
        it "should not match when no resource with the expected path exists" do
          matcher.matches?(:resources => [{:resource_name => 'remote_file', :path => '/tmp/bar', :action => 'create'}]).should be false
        end
        it "should match when a remote file with the expected path exists" do
          matcher.matches?(:resources => [{:resource_name => 'remote_file', :path => '/tmp/foo', :action => 'create'}]).should be true
        end
      end
    end

    describe :create_remote_file_with_attributes do
      describe "#match" do
        let(:matcher) { create_remote_file_with_attributes('/tmp/foo', :source => 'http://www.example.com/foo', :checksum => 'deadbeef') }
        it "should not match when no resource with the expected path exists" do
          matcher.matches?(:resources => [{:resource_name => 'remote_file', :path => '/tmp/bar', :source => 'http://www.example.com/foo', :checksum => 'deadbeef', :action => 'create'}]).should be false
        end
        it "should not match when the source differs" do
          matcher.matches?(:resources => [{:resource_name => 'remote_file', :path => '/tmp/foo', :source => 'http://www.example.com/bar', :checksum => 'deadbeef', :action => 'create'}]).should be false
        end
        it "should not match when the source differs" do
          matcher.matches?(:resources => [{:resource_name => 'remote_file', :path => '/tmp/foo', :source => 'http://www.example.com/foo', :checksum => 'cafebabe', :action => 'create'}]).should be false
        end
        it "should match when a remote file with the expected path exists" do
          matcher.matches?(:resources => [{:resource_name => 'remote_file', :path => '/tmp/foo', :source => 'http://www.example.com/foo', :checksum => 'deadbeef', :action => 'create'}]).should be true
        end
        it "should match when the remote file has additional attributes" do
          matcher.matches?(:resources => [{:resource_name => 'remote_file', :path => '/tmp/foo', :smells_like_peanut_butter => true, :source => 'http://www.example.com/foo', :checksum => 'deadbeef', :action => 'create'}]).should be true
        end
      end
    end
  end
end
