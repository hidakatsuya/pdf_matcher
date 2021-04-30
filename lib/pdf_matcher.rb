require_relative 'pdf_matcher/version'

module PdfMatcher
  Config = Struct.new(
    :diff_pdf_opts
  )
  def self.config
    @config ||= Config.new(nil)
  end

  def self.match?(*args)
    match(*args).matched?
  end

  def self.match(*args)
    Matcher.new(*args).match
  end
end
