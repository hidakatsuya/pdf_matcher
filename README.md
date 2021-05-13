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

### PdfMatcher.match?

Returns true if the PDFs match, false otherwise.

```ruby
PdfMatcher.match?(pdf_a_data, pdf_b_data)
PdfMatcher.match?('/path/to/a.pdf', '/path/to/b.pdf')
PdfMatcher.match?(Pathname('/path/to/a.pdf'), Pathname('/path/to/b.pdf'))
```

#### `output_diff` option:

If the PDFs do not match, a difference PDF file will be generated at the path specified.

```ruby
PdfMatcher.match?(pdf_a_data, pdf_b_data, output_diff: '/path/to/diff.pdf')
```

#### `diff_pdf_opts` option:

The specified values will be set as options for the `diff-pdf` command.

```ruby
PdfMatcher.match?(pdf_a_data, pdf_b_data, diff_pdf_opts: ['--mark-differences', '--dpi=600'])
```

### PdfMatcher.match

Returns the PDF match result as a `PdfMatcher::MatchResult` object.

```ruby
result = PdfMatcher.match(
  pdf_a, pdf_b,
  output_diff: nil,
  diff_pdf_opts: nil
)

result.matched? #=> boolean

# Returns nil if pdf data is passed, otherwise returns path as Pathname.
result.pdf1_path #=> Pathname or nil
result.pdf2_path #=> Pathname or nil

result.pdf1_data #=> "%PDF-..."
result.pdf2_data #=> "%PDF-..."

# Returns nil if the output_diff parameter is nil or the PDFs do not match.
result.diff_pdf_path #=> Pathname or nil
result.diff_pdf_data #=> "%PDF-..." or nil
```

### Configuring the default options for the diff-pdf command

```ruby
PdfMatcher.config.diff_pdf_opts = %w(
  --mark-differences
  --channel-tolerance=40
)
```

See `diff-pdf --help` for available options of the diff-pdf.

## Use in Testing Frameworks

Try [pdf_matcher-testing gem](https://github.com/hidakatsuya/pdf_matcher-testing).

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
