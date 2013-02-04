require File.expand_path('../../spec_helper', __FILE__)

# TODO add tests for multiple targets!

# @return [Lockfile]
#
def generate_lockfile
  hash = {}
  hash['PODS'] = []
  hash['DEPENDENCIES'] = []
  hash['SPEC CHECKSUMS'] = []
  hash['COCOAPODS'] = Pod::VERSION
  Pod::Lockfile.new(hash)
end

# @return [Podfile]
#
def generate_podfile(pods = ['JSONKit'])
  podfile = Pod::Podfile.new do
    platform :ios
    xcodeproj 'SampleProject/SampleProject'
    pods.each { |name| pod name }
  end
end
module Pod
  describe Installer do

    # before do
    #   @sandbox = temporary_sandbox
    #   config.repos_dir = fixture('spec-repos')
    #   config.sandbox_root = @sandbox.root
    #   FileUtils.cp_r(fixture('integration/JSONKit'), @sandbox.root + 'JSONKit')
    # end
    #

    # it 'tells each pod to link its headers' do
    #   @pods[0].expects(:link_headers)
    #   do_install!
    # end

    describe "Concerning pre-installation computations" do
      # @sandbox = temporary_sandbox
      # config.sandbox_root = temporary_sandbox.root
      # FileUtils.cp_r(fixture('integration/JSONKit'), @sandbox.root + 'JSONKit')

      # resolver = Resolver.new(podfile, nil, @sandbox)
      # @installer = Installer.new(resolver)
      # target_installer = @installer.target_installers.first
      # target_installer.install

      before do
        podfile    = generate_podfile
        lockfile   = generate_lockfile
        @installer = Installer.new(config.sandbox, podfile, lockfile)
        SpecHelper.create_sample_app_copy_from_fixture('SampleProject')
        @installer.install!
      end

      it "marks all pods as added if there is no lockfile" do
        true.should.be.true
        # @installer.pods_added_from_the_lockfile.should == ['JSONKit']
      end

      #       it "adds the files of the pod to the Pods project only once" do
      #         @installer.install!
      #         group = @installer.project.pods.groups.find { |g| g.name == 'Reachability' }
      #         group.files.map(&:name).sort.should == ["Reachability.h", "Reachability.m"]
      #         end

      # it 'clears out its headers root when preparing for install' do
      #   @sandbox.prepare_for_install
      #   @sandbox.build_headers.root.should.not.exist
      # end
    end

    # describe "by default" do
    #   before do
    #     podfile = Podfile.new do
    #       platform :ios
    #       xcodeproj 'MyProject'
    #       pod 'JSONKit'
    #     end

    #     @sandbox = temporary_sandbox
    #     config.sandbox_root = temporary_sandbox.root
    #     FileUtils.cp_r(fixture('integration/JSONKit'), @sandbox.root + 'JSONKit')
    #     @installer = Installer.new(@sandbox, podfile)
    #     target_installer = @installer.target_installers.first
    #     target_installer.generate_xcconfig([], @sandbox)
    #     @xcconfig = target_installer.xcconfig.to_hash
    #   end
    #
    #   it "omits empty target definitions" do
    #     podfile = Podfile.new do
    #       platform :ios
    #       target :not_empty do
    #         pod 'JSONKit'
    #       end
    #     end
    #     installer = Installer.new(@sandbox, podfile)
    #     installer.target_installers.map(&:target_definition).map(&:name).should == [:not_empty]
    #   end

    #   it "forces downloading of the `bleeding edge' version of a pod" do
    #     podfile = Podfile.new do
    #       platform :ios
    #       pod 'JSONKit', :head
    #     end
    #     installer = Installer.new(@sandbox, podfile)
    #     pod = installer.pods.first
    #     downloader = stub('Downloader')
    #     Downloader.stubs(:for_pod).returns(downloader)
    #     downloader.expects(:download_head)
    #     installer.download_pod(pod)
    #   end
    # end

    # describe "concerning multiple pods originating form the same spec" do
    #   extend SpecHelper::Fixture

    #   before do
    #     sandbox = temporary_sandbox
    #     Config.instance.sandbox_root = sandbox.root
    #     Config.instance.integrate_targets = false
    #     podspec_path = fixture('integration/Reachability/Reachability.podspec')
    #     podfile = Podfile.new do
    #       platform :osx
    #       pod 'Reachability', :podspec => podspec_path.to_s
    #       target :debug do
    #         pod 'Reachability'
    #       end
    #     end
    #     resolver = Resolver.new(podfile, nil, sandbox)
    #     @installer = Installer.new(resolver)
    #   end

    #   # The double installation leads to a bug when different subspecs are
    #   # activated for the same pod. We need a way to install a pod only
    #   # once while keeping all the files of the actived subspecs.
    #   #
    #   # LocalPodSet?
    #   #
    #   it "installs the pods only once" do
    #     LocalPod.any_instance.stubs(:downloaded?).returns(false)
    #     Downloader::GitHub.any_instance.expects(:download).once
    #     @installer.install!
    #   end

    #   it "cleans a pod only once" do
    #     LocalPod.any_instance.expects(:clean!).once
    #     @installer.install!
    #   end

    #   it "adds the files of the pod to the Pods project only once" do
    #     @installer.install!
    #     group = @installer.project.pods.groups.find { |g| g.name == 'Reachability' }
    #     group.files.map(&:name).should == ["Reachability.h", "Reachability.m"]
    #   end

    #   it "lists a pod only once" do
    #     reachability_pods = @installer.pods.map(&:to_s).select { |s| s.include?('Reachability') }
    #     reachability_pods.count.should == 1
    #   end
    # end

    # describe "concerning namespacing" do
    #   extend SpecHelper::Fixture

    #   before do
    #     sandbox = temporary_sandbox
    #     Config.instance.sandbox_root = sandbox.root
    #     Config.instance.integrate_targets = false
    #     podspec_path = fixture('chameleon')
    #     podfile = Podfile.new do
    #       platform :osx
    #       pod 'Chameleon', :local => podspec_path
    #     end
    #     resolver   = Resolver.new(podfile, nil, sandbox)
    #     @installer = Installer.new(resolver)
    #   end

    #   it "namespaces local pods" do
    #     @installer.install!
    #     group = @installer.project['Local Pods']
    #     group.groups.map(&:name).sort.should == %w| Chameleon |
    #   end

    #   it "namespaces subspecs" do
    #     @installer.install!
    #     group = @installer.project['Local Pods/Chameleon']
    #     group.groups.map(&:name).sort.should == %w| AVFoundation AssetsLibrary MediaPlayer MessageUI StoreKit UIKit |
    #   end
    # end
  end
end

