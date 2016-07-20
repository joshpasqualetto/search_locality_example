# Stelligent Search Locality

## Summary
This is a programming exercise to find two words within a set of documents, and being able to define the proximity (slop) between the two regardless of sentences, etc. This solution uses Ferret, which is a LUCENE like search library written in C with ruby bindings.

## Usage
`bundle install`
`rake server`

## Test data
Data is provided in sample_docs/ that is loaded on request, so data can be updated while server is running

## Querying

Run `rake server` to run sinatra

Phrase Query:
`curl --data "search_terms=Continuous Delivery,Dr. Fowler&slop=3" localhost:4567/search`

Term Query:
`curl --data "search_terms=fox,dog&slop=3" localhost:4567/search`

## Flaws/Features/TODO)
* Only takes two search terms, separated by a comma (No commas in the query terms)
* Slop is the proximity between words, with cardinal numbering (0 is valid)
* Does not handle failures other then spitting the backtrace out to the requester
* Loads files in sample_docs for every request, This could be very slow if a large number of files are present, but the content is fresh.

## Development
`rake test`

* Run guard while developing to auto-run tests
* Ensure all tests pass
* rspec for unit testing
* rubocop for ruby lint checking
