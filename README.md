# PdfMatcher

A library to compare two PDFs and output the differences using [diff-pdf](https://github.com/vslavik/diff-pdf).

## Prerequisites

This gem requires [diff-pdf](https://github.com/vslavik/diff-pdf). See [the README.md](https://github.com/vslavik/diff-pdf) for how to install it.

Note that you can install it with [hidakatsuya/setup-diff-pdf](https://github.com/hidakatsuya/setup-diff-pdf) in GitHub Action.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'pdf_matcher'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install pdf_matcher

## Usage

```ruby
require 'pdf_matcher'

PdfMatcher.match?(pdf_a, pdf_b) #=> boolean

PdfMatcher.match?('/path/to/a.pdf', '/path/to/b.pdf') #=> boolean
PdfMatcher.match?(Pathname('/path/to/a.pdf'), Pathname('/path/to/b.pdf')) #=> boolean

PdfMatcher.match?(pdf_a, pdf_b, output_diff: '/path/to/diff.pdf') #=> boolean
PdfMatcher.match?(pdf_a, pdf_b, diff_pdf_opts: ['dpi=300']) #=> boolean

result = PdfMatcher.match(pdf_a, pdf_b, output_diff: true or false or nil or '/path/to/diff.pdf' or Pathname, diff_pdf_opts: ['dpi=300'])
result.matched? #=> boolean
result.pdf_first #=> data of pdf_a
result.pdf_second #=> data of pdf_b

# when output_diff is nil or false
result.diff_pdf #=> nil

# when output_diff is true or '/path/to/pdf' or Pathname('/path/to/pdf')
result.diff_pdf #=> pdf data

PdfMatcher.config.diff_pdf_opts = ['dpi=300']
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hidakatsuya/pdf_matcher. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/hidakatsuya/pdf_matcher/blob/master/CODE_OF_CONDUCT.md).

## Testing

```
$ bundle exec rake
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PdfMatcher project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hidakatsuya/pdf_matcher/blob/master/CODE_OF_CONDUCT.md).
