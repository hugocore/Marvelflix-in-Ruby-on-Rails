CHARACTERS_PER_REQUEST = 100

namespace :marvel do
  namespace :cache do
    desc 'Caches every character that Marvel has'
    task characters: :environment do
      api = Marvelite::API::Client.new(
        public_key: ENV['MARVEL_API_PUBLIC_KEY'],
        private_key: ENV['MARVEL_API_PRIVATE_KEY']
      )

      # Prepare iterator
      page = 0
      characters = []

      # Update the database in a transaction to builk-insert all the records in one transation, and
      # to avoid breaking something in case the loop breaks in the middle for some reason
      ActiveRecord::Base.transaction do
        # Reset all the characters
        Character.destroy_all

        loop do
          # Query Marvel about their current characters
          iterator = api.characters(offset: page, limit: CHARACTERS_PER_REQUEST)

          # Extract the characters data
          characters += iterator.dig(:data, :results).map do |character|
            Character.create(id: character.dig(:id), name: character.dig(:name))
          end

          # Prints out some progress
          puts "Cached #{characters.count} characters - Page no. #{page}..."

          # Change page
          page += CHARACTERS_PER_REQUEST

          # Wait a littttle bit to make sure we don't get banned by Marvel for abuse
          sleep(3)

          break if iterator.dig(:data, :results).empty?
        end
      end

      puts "Cached #{characters.count} characters"
    end
  end
end
