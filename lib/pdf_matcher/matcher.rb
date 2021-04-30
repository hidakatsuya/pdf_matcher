# frozen_string_literal: true

require_relative 'pdf_file'
require_relative 'match_result'

module PdfMatcher
  class Matcher
    def initialize(pdf1, pdf2, output_diff: nil, diff_pdf_opts: nil)
      @pdf1 = PdfFile.init(pdf1)
      @pdf2 = PdfFile.init(pdf2)
      @output_diff_path = output_diff ? Pathname(output_diff) : nil
      @diff_pdf_opts = diff_pdf_opts || PdfMatcher.config.diff_pdf_opts
    end

    def match
      @result ||= MatchResult.new(match_pdfs, pdf1, pdf2, diff_pdf_path)
    end

    private

    attr_reader :pdf1, :pdf2, :output_diff_path, :diff_pdf_opts

    def pdfs
      @pdfs ||= [pdf1, pdf2]
    end

    def match_pdfs
      open_pdf_files do |pdf1_path, pdf2_path|
        DiffPdf.exec(
          pdf1_path, pdf2_path,
          output_diff: output_diff_path,
          options: diff_pdf_opts
        )
      end
    end

    def open_pdf_files
      pdfs.each(&:open)
      yield(pdf1.path, pdf2.path)
    ensure
      pdfs.each(&:close)
    end
  end
end
