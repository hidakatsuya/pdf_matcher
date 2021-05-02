# PdfMatcher

[![Gem Version](https://badge.fury.io/rb/pdf_matcher.svg)](https://badge.fury.io/rb/pdf_matcher)
[![Test](https://github.com/hidakatsuya/pdf_matcher/actions/workflows/test.yml/badge.svg?branch=main)](https://github.com/hidakatsuya/pdf_matcher/actions/workflows/test.yml)

A gem to compare two PDFs and output the differences using [diff-pdf](https://github.com/vslavik/diff-pdf).

## Prerequisites

### diff-pdf Required

This gem requires [diff-pdf](https://github.com/vslavik/diff-pdf). See [the README.md](https://github.com/vslavik/diff-pdf) for how to install it.

Note that you can install it with [hidakatsuya/setup-diff-pdf](https://github.com/hidakatsuya/setup-diff-pdf) in GitHub Action.

### Supported Ruby Versions

2.6, 2.7, 3.0

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
PdfMatcher.match?(pdf_a, pdf_b, diff_pdf_opts: ['--dpi=300']) #=> boolean

result = PdfMatcher.match(
  pdf_a, pdf_b,
  output_diff: nil,  # or '/path/to/diff.pdf' or Pathname('/path/to/diff.pdf')
  diff_pdf_opts: nil # or ['--dpi=300']
)
result.matched? #=> boolean

# Returns nil if pdf data is passed, otherwise returns path as Pathname.
result.pdf1_path #=> Pathname or nil
result.pdf2_path #=> Pathname or nil

result.pdf1_data #=> "%PDF-..."
result.pdf2_data #=> "%PDF-..."

# Returns nil if the output_diff parameter is nil.
result.diff_pdf_path #=> Pathname or nil
result.diff_pdf_data #=> "%PDF-..." or nil

PdfMatcher.config.diff_pdf_opts = ['--dpi=300']
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hidakatsuya/pdf_matcher. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/hidakatsuya/pdf_matcher/blob/master/CODE_OF_CONDUCT.md).

## Testing

```
$ bundle exec rake test
```

However, this gem requires diff-pdf. You can install it locally or use a docker container.

```
$ docker build -t pdf_matcher:latest .
$ docker run -v $PWD:/src:cached -it pdf_matcher bash

> src# bundle install
> src# bundle exec rake test
```

Or, you can run tests instantlly like this:

```
$ docker run --rm -v $PWD:/src -it pdf_matcher bash -c "bundle install && bundle exec rake test"
```


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the PdfMatcher project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/hidakatsuya/pdf_matcher/blob/master/CODE_OF_CONDUCT.md).
