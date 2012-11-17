require 'spec_helper'

module ASIN
  describe ASIN do
    context "configuration" do
      it "should fail without secret and key" do
        expect { @helper.lookup 'bla' }.to raise_error(ArgumentError, "you are missing mandatory configuration options. please set [:secret, :key, :associate_tag]")
      end

      it "should fail with wrong configuration key" do
        lambda { @helper.configure :wrong => 'key' }.should raise_error(ArgumentError)
      end

      it "should not override the configuration" do
        config = @helper.configure :key => 'wont get overridden'
        config.key.should_not be_nil

        config = @helper.configure :secret => 'is also set'
        config.key.should_not be_nil
        config.secret.should_not be_nil
      end

      it "should work with a configuration block" do
        conf = ASIN::Configuration.configure do |config|
          config.key = 'bla'
        end
        conf.key.should eql('bla')
      end

      it "should read configuration from yml" do
        config = ASIN::Configuration.configure :yaml => 'spec/asin.yml'
        config.secret.should eql('secret_yml')
        config.key.should eql('key_yml')
        config.host.should eql('host_yml')
        config.logger.should eql('logger_yml')
      end

      it "should read configuration from yml with block" do
        conf = ASIN::Configuration.configure :yaml => 'spec/asin.yml' do |config, yml|
          config.secret = nil
          config.key = yml['secret']
        end
        conf.secret.should be_nil
        conf.key.should eql('secret_yml')
      end
    end
  end
end
