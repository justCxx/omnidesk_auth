require 'spec_helper'

describe OmnideskAuth do
  before do
    OmnideskAuth.reset!
  end

  after do
    OmnideskAuth.reset!
  end

  it 'sets defaults' do
    OmnideskAuth::Configurable.keys.each do |key|
      actual = OmnideskAuth.instance_variable_get(:"@#{key}")
      default = OmnideskAuth::Default.send(key)
      expect(actual).to eq(default)
    end
  end

  describe '.client' do
    it 'creates an OmnideskAuth::Client' do
      expect(OmnideskAuth.client).to be_kind_of OmnideskAuth::Client
    end

    it 'caches the client when the same options are passed' do
      expect(OmnideskAuth.client).to eq(OmnideskAuth.client)
    end

    it 'returns a fresh client when options are not the same' do
      client = OmnideskAuth.client

      OmnideskAuth.secret = 'i10loveruby'

      client_two = OmnideskAuth.client
      client_three = OmnideskAuth.client

      expect(client).not_to eq(client_two)
      expect(client_two).to eq(client_three)
    end
  end

  describe '.configure' do
    OmnideskAuth::Configurable.keys.each do |key|
      it "sets the #{key.to_s.tr('_', ' ')}" do
        OmnideskAuth.configure do |config|
          config.send("#{key}=", key)
        end
        expect(OmnideskAuth.instance_variable_get(:"@#{key}")).to eq(key)
      end
    end
  end
end
