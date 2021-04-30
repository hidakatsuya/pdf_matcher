# frozen_string_literal: true

module PdfMatcher
  module DiffPdf
    class CommandNotAvailable < StandardError; end

    def self.exec(pdf1_path, pdf2_path, output_diff: nil, options: nil)
      system("diff-pdf #{pdf1_path} #{pdf2_path} #{build_options(output_diff, options).join(' ')}")
    end

    def self.verify_available!
      raise CommandNotAvailable unless system('which diff-pdf > /dev/null 2>&1')
    end

    private

    def self.build_options(output_diff, options)
      (options || []).tap do |opts|
        opts << "--output-diff=#{output_diff}" if output_diff
      end
    end
  end
end
