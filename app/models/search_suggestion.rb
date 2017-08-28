class SearchSuggestion

  def self.seed
    IcpsrRecord.find_each do |record|
      name = record.name
      1.upto(name.length - 1) do |n|
        prefix = name[0, n]
        $redis.zadd 'search-suggestions:' + prefix.downcase, record.icpsr_id, name.downcase
      end
    end
  end

  def self.terms_for(prefix)
    $redis.zrevrange 'search-suggestions:' + prefix.downcase, 0, 19, with_scores: false
  end

end
