require_relative 'lib/pdf_matcher/version'

Gem::Specification.new do |spec|
  spec.name          = 'pdf_matcher'
  spec.version       = PdfMatcher::VERSION
  spec.authors       = ['Katsuya Hidaka']
  spec.email         = ['hidakatsuya@gmail.com']

  spec.summary       = 'A gem to compare two PDFs and output the differences using diff-pdf'
  spec.description   = 'PdfMatcher is a gem to compare two PDFs and output the differences using diff-pdf'
  spec.homepage      = 'https://github.com/hidakatsuya/pdf_matcher'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = 'https://github.com/hidakatsuya/pdf_matcher/blob/main/CHANGELOG.md'

  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^test/}) }
  end
  spec.require_paths = ['lib']
end
