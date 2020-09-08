# frozen_string_literal: true

RSpec.describe AwsSRP::Hasher do
  let(:key) { 'KEY___' }
  let(:msg) { 'MSG___' }
  let(:msg64) { Base64.strict_encode64(msg) }
  let(:hasher) { described_class.new(key) }
  let(:hasher_with_msg) { described_class.new(key, msg) }

  describe '.digest' do
    it 'returns a digest for the given arguments' do
      expect(described_class.digest(key)).to eql OpenSSL::Digest::SHA256.digest(key)
      expect(described_class.digest(key, msg)).to eql OpenSSL::HMAC.digest('sha256', key, msg)
    end
  end

  describe '.hexdigest' do
    it 'returns a hexdigest for the given arguments' do
      expect(described_class.hexdigest(key)).to eql OpenSSL::Digest::SHA256.hexdigest(key)
      expect(described_class.hexdigest(key, msg)).to eql OpenSSL::HMAC.hexdigest('sha256', key, msg)
    end
  end

  describe '#digest' do
    it 'returns a sha256 digest if the message has not been passed' do
      expect(hasher.digest).to eql OpenSSL::Digest::SHA256.digest(key)
    end

    it 'returns a sha256 hmac digest if the message has been passed' do
      expect(hasher_with_msg.digest).to eql OpenSSL::HMAC.digest('sha256', key, msg)
    end

    it 'starts acting as a hmac right after providing the message' do
      expect(hasher.digest).to eql OpenSSL::Digest::SHA256.digest(key)

      hasher.update(msg)

      expect(hasher.digest).to eql OpenSSL::HMAC.digest('sha256', key, msg)
    end
  end

  describe '#hexdigest' do
    it 'returns a sha256 hexdigest if the message has not been passed' do
      expect(hasher.hexdigest).to eql OpenSSL::Digest::SHA256.hexdigest(key)
    end

    it 'returns a sha256 hmac hexdigest if the message has been passed' do
      expect(hasher_with_msg.hexdigest).to eql OpenSSL::HMAC.hexdigest('sha256', key, msg)
    end

    it 'starts acting as a hmac right after providing the message' do
      expect(hasher.hexdigest).to eql OpenSSL::Digest::SHA256.hexdigest(key)

      hasher.update(msg)

      expect(hasher.hexdigest).to eql OpenSSL::HMAC.hexdigest('sha256', key, msg)
    end
  end

  describe '#digest64' do
    it 'returns a base64 encoded digest' do
      expect(hasher.digest64).to eql Base64.strict_encode64(::Digest::SHA256.digest(key))
    end
  end

  describe '#update' do
    it 'updates the hmac digest and starts treating the object as a hmac' do
      expect(hasher.digest).to eql OpenSSL::Digest::SHA256.digest(key)

      hasher.update(msg)

      expect(hasher.digest).to eql OpenSSL::HMAC.digest('sha256', key, msg)
    end

    it 'decodes the arguments if requested' do
      hasher.update(msg64, base64: true)

      expect(hasher.digest).to eql OpenSSL::HMAC.digest('sha256', key, msg)
    end
  end
end
