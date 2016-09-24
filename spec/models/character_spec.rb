require 'rails_helper'

describe Character do
  describe '.new' do
    it 'creates a character with a name' do
      expect do
        create(:character)
      end.to_not raise_error
    end

    context 'without a name' do
      it 'raises an error' do
        expect do
          create(:character, name: nil)
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
