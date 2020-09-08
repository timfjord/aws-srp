# frozen_string_literal: true

module AwsSRP
  class Flow
    # Password Verifier Challange response wrapper
    class PasswordVerifierResponse
      attr_reader :response

      def initialize(response)
        @response = response
      end

      def challenge_name
        dig!('ChallengeName')
      end

      def salt
        dig!('ChallengeParameters', 'SALT')
      end

      def secret_block
        dig!('ChallengeParameters', 'SECRET_BLOCK')
      end

      def bb
        dig!('ChallengeParameters', 'SRP_B')
      end

      def user_id
        dig!('ChallengeParameters', 'USER_ID_FOR_SRP')
      end

      private

      def dig!(*path)
        response.dig(*path) ||
          raise(ArgumentError, "#{path.join('/')} not found in the response")
      end
    end
  end
end
