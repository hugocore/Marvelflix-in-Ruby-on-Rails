require 'rails_helper'

describe User do
  describe '.create' do
    context 'with a valid user' do
      it 'creates a user' do
        expect do
          create(:user, email: 'my@email.com', password: 'something12345')
        end.to_not raise_error
      end
    end

    context 'with an e-mail' do
      it 'raises an error' do
        expect do
          create(:user, email: 'wrong!', password: 'something12345')
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with short password' do
      it 'raises an error' do
        expect do
          create(:user, email: 'wrong!', password: '12345')
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
