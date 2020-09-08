# frozen_string_literal: true

module AwsSRP
  # AWS Cognito flow
  class Flow
    attr_reader :pool_id, :username, :password, :srp

    def initialize(pool_id, username, password)
      @pool_id = pool_id
      @username = username
      @password = password

      @srp = SRP.new
    end

    def now
      @now ||= Time.now.utc.strftime('%a %b %-e %H:%M:%S UTC %Y')
    end

    def init_auth
      {
        AuthParameters: {
          USERNAME: username,
          SRP_A: srp.aa.str
        }
      }
    end

    def verify_password(response)
      response = PasswordVerifierResponse.new(response)

      srp.username = [pool_id, response.user_id].join
      srp.password = password
      srp.salt = response.salt
      srp.bb = response.bb

      hmac = Hasher.new(srp.hkdf)
        .update(pool_id)
        .update(response.user_id)
        .update(response.secret_block, base64: true)
        .update(now)

      {
        ChallengeName: response.challenge_name,
        ChallengeResponses: {
          USERNAME: response.user_id,
          PASSWORD_CLAIM_SECRET_BLOCK: response.secret_block,
          TIMESTAMP: now,
          PASSWORD_CLAIM_SIGNATURE: hmac.digest64
        }
      }
    end
  end
end
