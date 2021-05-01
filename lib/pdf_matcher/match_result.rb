# frozen_string_literal: true

require 'forwardable'

module PdfMatcher
  class MatchResult < Struct.new(:matched, :pdf1_file, :pdf2_file, :diff_pdf_path)
    extend Forwardable

    alias :matched? :matched

    def_delegator :pdf1_file, :path, :pdf1_path
    def_delegator :pdf1_file, :data, :pdf1_data
    def_delegator :pdf2_file, :path, :pdf2_path
    def_delegator :pdf2_file, :data, :pdf2_data

    def diff_pdf_data
      @diff_pdf_data ||= diff_pdf_path&.binread
    end
  end
end
