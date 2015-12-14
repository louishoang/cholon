module Indexable
  def index_term(term)
    where(name: term.downcase).first_or_initialize.tap do |suggestion|
      suggestion.increment! :popularity
    end
  end
end