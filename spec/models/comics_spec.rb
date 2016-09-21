require 'rails_helper'
require 'ffaker'

describe Comic.new do
  let(:user) { create(:user) }
  let(:comic) { create(:comic) }
  let(:comic_with_year) { create(:comic, title: 'Brilliant (2011) #7') }
  let(:comic_without_year) { create(:comic, title: 'Brilliant') }
  let(:comic_with_image) { create(:comic, thumbnail: { 'path' => 'logo', 'extension' => 'jpg' }) }

  describe '#upvoted?' do
    it 'returns true if the current user has upvoted a certain comic' do
      upvote = create(:upvote, user: user, comic_id: comic.id)

      comic.upvote = upvote

      expect(comic.upvoted?).to be_truthy
    end
  end

  describe '#total_upvotes' do
    it 'returns the total number of upvotes of a certain comic' do
      total_upvotes = 3

      total_upvotes.times do
        create(:upvote, user: user, comic_id: comic.id)
      end

      expect(comic.total_upvotes).to eq(total_upvotes)
    end
  end

  describe '#name' do
    context 'with a comic that have a title that has more than the name' do
      it 'scrapes the title and fetchs the name of the comic' do
        expect(comic_with_year.name).to eq('Brilliant')
      end
    end

    context 'with a comic that have a title that have only the name' do
      it 'scrapes the title and fetchs the name of the comic' do
        expect(comic_without_year.name).to eq('Brilliant')
      end
    end
  end

  describe '#year' do
    context 'with a comic that have the title in its title' do
      it 'scrapes the title and fetchs the name of the comic' do
        expect(comic_with_year.year).to eq('2011')
      end
    end

    context 'with a comic that does not have the title in its title' do
      it 'scrapes the title and fetchs the name of the comic' do
        expect(comic_without_year.year).to be_nil
      end
    end
  end

  describe '#thumb_path' do
    it "concatenates the thumbnail's filepath and its extension " do
      expect(comic_with_image.thumb_path).to eq('logo.jpg')
    end
  end
end
