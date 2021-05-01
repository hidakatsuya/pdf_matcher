# frozen_string_literal: true

require_relative 'pdf_matcher/version'
require_relative 'pdf_matcher/matcher'

module PdfMatcher
  Config = Struct.new(
    # Options for diff-pdf.
    # It will be applied as the default options when executing diff-pdf. Default is nil.
    #
    #     PdfMatcher.config.diff_pdf_opts = ['--dpi=300', '--grayscale']
    #     PdfMatcher.config.diff_pdf_opts = %w(--dpi=300 --grayscale)
    #
    # See `diff-pdf --help` for available options.
    :diff_pdf_opts
  )
  def self.config
    @config ||= Config.new(nil)
  end

  def self.match?(pdf1, pdf2, output_diff: nil, diff_pdf_opts: nil)
    match(pdf1, pdf2, output_diff: output_diff, diff_pdf_opts: diff_pdf_opts).matched?
  end

  def self.match(pdf1, pdf2, output_diff: nil, diff_pdf_opts: nil)
    Matcher.new(pdf1, pdf2, output_diff: output_diff, diff_pdf_opts: diff_pdf_opts).match
  end
end
