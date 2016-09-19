class Comic < OpenStruct
  # Each comic has a title that follows this format: name + year + issuenumber, for
  # example "Brilliant (2011) #7". Captures each part separately.
  TITLE_FORMAT = %r{(.*) \((.*)\) \#(.*)}
  TITLE_NO_ELEMENTS = 3
  NAME_POS = 1
  YEAR_POS = 2

  def upvoted?
    upvote.present?
  end

  def total_upvotes
    @_upvotes ||= Upvote.where(comic_id: id).count
  end

  def to_partial_path
    'comic'.freeze
  end

  # Get the name of the comic without the comic's starting year or issuenumber, for example
  #
  # > Comic.new(title: "Brilliant (2011) #7").name
  # => "Brilliant"
  def name
    scrape_title(NAME_POS)
  end

  # Get the year
  #
  # > Comic.new(title: "Brilliant (2011) #7").year
  # => "Brilliant"
  def year
    scrape_title(YEAR_POS)
  end

  # Builds the comic's thumbnail image path by concatenating its filepath and extension. More info
  # at http://developer.marvel.com/documentation/images
  def thumb_path
    [thumbnail['path'], thumbnail['extension']].join('.')
  end

  private

  # Parses the title and use regular expressions to scrape its information
  def scrape_title(position)
    matches = title.match(TITLE_FORMAT)

    matches.size > TITLE_NO_ELEMENTS ? matches[position] : title
  end
end
