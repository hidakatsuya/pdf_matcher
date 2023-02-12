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

    class UnknownDiffPdfExitCode < StandardError
      def initialize(code)
        super "pdf_matcher did not recognize the exit code #{code} from the diff-pdf command, " \
              'this probably means there is a problem with your installed version of diff-pdf.'
      end
    end

    def initialize
      verify_available!
    end

    def exec(pdf1_path, pdf2_path, output_diff: nil, options: nil)
      `diff-pdf #{build_options(output_diff, options).join(' ')} #{pdf1_path} #{pdf2_path} > /dev/null 2>&1`

      case $?.exitstatus
      when 0
        true
      when 1
        false
      else
        raise UnknownDiffPdfExitCode, $?.exitstatus
      end
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
