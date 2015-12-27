module Indexable
  def index_term(term, klass=nil)
    if klass.present?
      ProductOption.where(name: term.downcase).first_or_initialize.tap do |suggestion|
        suggestion.increment! :popularity
      end
    else
      where(name: term.downcase).first_or_initialize.tap do |suggestion|
        suggestion.increment! :popularity
      end
    end
  end
end