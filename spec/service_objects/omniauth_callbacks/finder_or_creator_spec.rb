require 'rails_helper'

RSpec.describe OmniauthCallbacks::FinderOrCreator do
  let!(:consumer) { create(:consumer) }
  let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '12345678', info: {}) }

  describe '#call' do
    context 'consumer already has authorization' do
      it 'returns the consumer' do
        consumer.authorizations.create(provider: 'facebook', uid: '12345678')
        expect(described_class.new(auth).call).to eq consumer
      end
    end

    context 'consumer has not authorization' do
      context 'consumer already exists' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: consumer.email }) }
        it 'does not create new consumer' do
          expect { described_class.new(auth).call }.to_not change(Consumer, :count)
        end

        it 'creates authorization for consumer' do
          expect { described_class.new(auth).call }.to change(consumer.authorizations, :count).by(1)
        end

        it 'creates authorization with provider and uid' do
          authorization = described_class.new(auth).call.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end

        it 'returns the consumer' do
          expect(described_class.new(auth).call).to eq consumer
        end
      end

      context 'consumer does not exist' do
        let(:auth) { OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: { email: 'new@pro.com', name: 'name' }) }

        it 'creates new consumer' do
          expect { described_class.new(auth).call }.to change(Consumer, :count).by(1)
        end

        it 'returns new consumer' do
          expect(described_class.new(auth).call).to be_a(Consumer)
        end

        it 'fills consumer email' do
          consumer = described_class.new(auth).call
          expect(consumer.email).to eq auth.info[:email]
        end

        it 'creates authorization for consumer' do
          consumer = described_class.new(auth).call
          expect(consumer.authorizations).to_not be_empty
        end

        it 'creates authorization with provider, uid, checksum' do
          authorization = described_class.new(auth).call.authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
      end
    end
  end
end
