require 'spec_helper'

describe OmnideskAuth::Client do
  before do
    OmnideskAuth.reset!
  end

  after do
    OmnideskAuth.reset!
  end

  context 'module configuration' do
    before do
      OmnideskAuth.reset!
      OmnideskAuth.configure do |config|
        OmnideskAuth::Configurable.keys.each do |key|
          config.send("#{key}=", "Some #{key}")
        end
      end
    end

    after do
      OmnideskAuth.reset!
    end

    it 'inherits the module configuration' do
      client = OmnideskAuth::Client.new
      OmnideskAuth::Configurable.keys.each do |key|
        expect(client.instance_variable_get(:"@#{key}")).to eq("Some #{key}")
      end
    end

    context 'with class level configuration' do
      let(:opts) do
        { endpoint: 'https://mycompany.omnidesk.ru',
          secret: 'i10veruby' }
      end

      it 'overrides module configuration' do
        client = OmnideskAuth::Client.new(opts)
        expect(client.endpoint).to eq('https://mycompany.omnidesk.ru')
        expect(client.secret).to eq('i10veruby')
        expect(client.expire).to eq(OmnideskAuth.expire)
      end

      it 'can set configuration after initialization' do
        client = OmnideskAuth::Client.new
        client.configure do |config|
          opts.each do |key, value|
            config.send("#{key}=", value)
          end
        end

        expect(client.endpoint).to eq('https://mycompany.omnidesk.ru')
        expect(client.secret).to eq('i10veruby')
        expect(client.expire).to eq(OmnideskAuth.expire)
      end

      it 'masks secret on inspect' do
        client = OmnideskAuth::Client.new(opts)
        inspected = client.inspect
        expect(inspected).not_to include('il0veruby')
      end
    end
  end
end
