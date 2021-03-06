# frozen_string_literal: true

require 'singleton'
require 'forwardable'

module PdfMatcher
  class DiffPdf
    include Singleton

    class << self
      extend Forwardable
      def_delegator :instance, :exec
    end

    class CommandNotAvailable < StandardError
      def initialize
        super 'pdf_matcher requires diff-pdf command, but it does not seem to be installed. ' \
              'Please install it and try again.'
      end
    end

    def initialize
      verify_available!
    end

    def exec(pdf1_path, pdf2_path, output_diff: nil, options: nil)
      system("diff-pdf #{build_options(output_diff, options).join(' ')} #{pdf1_path} #{pdf2_path}")
    end

    private

    def verify_available!
      raise CommandNotAvailable unless system('which diff-pdf > /dev/null 2>&1')
    end

    def build_options(output_diff, options)
      (options || []).tap do |opts|
        opts << "--output-diff=#{output_diff}" if output_diff
      end
    end
  end
end
