class SearchSuggestion

  def self.seed
    IcpsrRecord.find_each do |record|
      name = record.name
      state = record.state_abbreviation
      date = record.date_execution.to_s
      1.upto(name.length) do |n|
        prefix = name[0, n]
        $redis.zadd 'search-suggestions:' + prefix.downcase, record.icpsr_id, name.downcase + " - " + state
      end
      1.upto(date.length) do |n|
        prefix = date[0, n]
        $redis.zadd 'search-suggestions:' + prefix.downcase, record.icpsr_id, date + " - " + name.downcase + " - " + state
      end
    end
  end

  def self.terms_for(prefix)
    $redis.zrevrange 'search-suggestions:' + prefix.downcase, 0, 19, with_scores: false
  end

end
