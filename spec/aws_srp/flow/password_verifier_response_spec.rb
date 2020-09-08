# frozen_string_literal: true

RSpec.describe AwsSRP::Flow::PasswordVerifierResponse do
  let(:invalid_response) { { 'key' => 'value' } }
  let(:response) do
    {
      'ChallengeName' => 'challenge_name',
      'ChallengeParameters' => {
        'SALT' => 'salt',
        'SECRET_BLOCK' => 'secret_block',
        'SRP_B' => 'srp_b',
        'USER_ID_FOR_SRP' => 'user_id_for_srp'
      }
    }
  end
  let(:invalid_password_verifier) { described_class.new(invalid_response) }
  let(:password_verifier) { described_class.new(response) }

  describe '#challenge_name' do
    it 'raises and error when the path is not found' do
      expect { invalid_password_verifier.challenge_name }.to raise_error ArgumentError
    end

    it 'gets value from the response' do
      expect(password_verifier.challenge_name).to eql response['ChallengeName']
    end
  end

  describe '#salt' do
    it 'raises and error when the path is not found' do
      expect { invalid_password_verifier.salt }.to raise_error ArgumentError
    end

    it 'gets value from the response' do
      expect(password_verifier.salt).to eql response['ChallengeParameters']['SALT']
    end
  end

  describe '#secret_block' do
    it 'raises and error when the path is not found' do
      expect { invalid_password_verifier.secret_block }.to raise_error ArgumentError
    end

    it 'gets value from the response' do
      expect(password_verifier.secret_block).to eql response['ChallengeParameters']['SECRET_BLOCK']
    end
  end

  describe '#bb' do
    it 'raises and error when the path is not found' do
      expect { invalid_password_verifier.bb }.to raise_error ArgumentError
    end

    it 'gets value from the response' do
      expect(password_verifier.bb).to eql response['ChallengeParameters']['SRP_B']
    end
  end

  describe '#user_id' do
    it 'raises and error when the path is not found' do
      expect { invalid_password_verifier.user_id }.to raise_error ArgumentError
    end

    it 'gets value from the response' do
      expect(password_verifier.user_id).to eql response['ChallengeParameters']['USER_ID_FOR_SRP']
    end
  end
end
