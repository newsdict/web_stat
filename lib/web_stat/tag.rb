require 'natto'
module WebStat
  class Tag
    attr_accessor :natto_mecab, :article
    
    def initialize(article, userdic: nil)
      @natto_mecab = Natto::MeCab.new(userdic: userdic)
      @article = article
    end
    
    # Keyword extraction
    # @param part_of_speech ex) 名詞, 固有名詞 etc... only Japanese
    def nouns(part_of_speech: "固有名詞")
      words = Hash.new
      @natto_mecab.parse(@article) do |n|
        features = n.feature.split(",")
        if include_recursive?(features, Array(part_of_speech))
          words[n.surface] = 1 unless words[n.surface]
          words[n.surface] += 1
        end
      end
      words.keys
    end
    
    private
    # A array include? B array.
    # @param target A array
    # @param list B array
    def include_recursive?(target, list)
      list.map { |v|target.include?(v) }.all?
    end
  end
end