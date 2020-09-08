# frozen_string_literal: true

module AwsSRP
  # Depends on the `msg` presence acts as a digest or a hmac
  class Hasher
    ALGORITHM = 'sha256'

    def self.digest(key, msg = nil)
      new(key, msg).digest
    end

    def self.hexdigest(key, msg = nil)
      new(key, msg).hexdigest
    end

    def initialize(key, msg = nil)
      @key = key
      @digest = OpenSSL::Digest.new(ALGORITHM)

      update(msg) if msg
    end

    def update(msg, base64: false)
      msg = Base64.strict_decode64(msg) if base64
      hmac.update(msg)

      self
    end

    def digest
      perform :digest
    end

    def hexdigest
      perform :hexdigest
    end

    def digest64
      Base64.strict_encode64(digest)
    end

    private

    def hmac
      @hmac ||= OpenSSL::HMAC.new(@key, @digest)
    end

    def perform(method)
      @hmac ? hmac.public_send(method) : @digest.public_send(method, @key)
    end
  end
end
