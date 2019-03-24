require 'natto'
module WebStat
  class Tag
    attr_accessor :natto_mecab, :article
    
    def initialize(article)
      @natto_mecab = Natto::MeCab.new
      @article = article
    end
    
    def nouns
      words = Hash.new
      @natto_mecab.parse(@article) do |n|
        if n.feature =~ /固有名詞/ && !n.surface.empty?
          words[n.surface] = 1 unless words[n.surface]
          words[n.surface] += 1
        end
      end
      words.keys
    end
  end
end