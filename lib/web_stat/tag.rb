require 'natto'
module WebStat
  class Tag
    attr_accessor :natto_mecab, :article
    
    def initialize(article)
      @natto_mecab = Natto::MeCab.new
      @article = article
    end
    
    def nouns
      words = []
      @natto_mecab.parse(@article) do |n|
        words << n.surface unless n.surface.empty?
      end
      words
    end
  end
end