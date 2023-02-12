# frozen_string_literal: true

require 'test_helper'

class DiffPdfTest < TestCase
  setup do
    @pdf1_path = create_pdf_file { text 'pdf1' }
    @pdf2_path = create_pdf_file { text 'pdf2' }
  end

  def diff_pdf_exec(...)
    PdfMatcher::DiffPdf.exec(...)
  end

  sub_test_case 'return value' do
    test 'when diff-pdf returns 0' do
      result = diff_pdf_exec(@pdf1_path, @pdf1_path)
      assert_equal 0, $?.exitstatus
      assert_equal true, result
    end

    test 'when diff-pdf returns 1' do
      result = diff_pdf_exec(@pdf1_path, @pdf2_path)
      assert_equal 1, $?.exitstatus
      assert_equal false, result
    end

    test 'when diff-pdf returns other code' do
      assert_raise(PdfMatcher::DiffPdf::UnknownDiffPdfExitCode) do
        diff_pdf_exec(@pdf1_path, @pdf1_path, options: %w(--invalid-option-used-for-testing))
      end
      assert_equal 2, $?.exitstatus
    end
  end
end
