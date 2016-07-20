def index
  index = Ferret::I.new(analyzer: Ferret::Analysis::StandardAnalyzer.new([]))


  Dir.glob('sample_docs/*').each do |file|
    index << { filename: file, content: File.read(file).strip }
  end
  index
end

def query(terms, slop = 2)
  search_query = Ferret::Search::Spans::SpanNearQuery.new(slop: slop.to_i, in_order: false) # rubocop:disable Metrics/LineLength
  terms.split(',').each do |term|
    downcase_term = term.downcase
    if downcase_term.include?(' ') # Phrase Given
      search_query << Ferret::Search::Spans::SpanMultiTermQuery.new(:content, downcase_term.split(' ')) # rubocop:disable Metrics/LineLength
    else # Singular term given
      search_query << Ferret::Search::Spans::SpanTermQuery.new(:content, term)
    end
  end
  search_query
end

def return_results(results) # Formats results and converts to pretty JSON
  JSON.pretty_generate(JSON.parse(results.to_json))
end
