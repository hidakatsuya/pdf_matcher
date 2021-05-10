# frozen_string_literal: true

require 'test_helper'

class PdfMatcherTest < TestCase
  sub_test_case '.match?' do
    test 'when specifying pdf datas' do
      pdf1_data = create_pdf_data { text 'Hello' }
      pdf2_data = create_pdf_data { text 'Goodbye' }

      assert_true PdfMatcher.match?(pdf1_data, pdf1_data)
      assert_false PdfMatcher.match?(pdf1_data, pdf2_data)
    end

    test 'when specifying pdf paths' do
      pdf1_path = create_pdf_file { text 'Hello' }
      pdf2_path = create_pdf_file { text 'Goodbye' }

      # as a string
      assert_true PdfMatcher.match?(pdf1_path, pdf1_path)
      assert_false PdfMatcher.match?(pdf1_path, pdf2_path)

      # as a Pathname
      assert_true PdfMatcher.match?(Pathname(pdf1_path), Pathname(pdf1_path))
      assert_false PdfMatcher.match?(Pathname(pdf1_path), Pathname(pdf2_path))
    end

    test 'specifying diff-pdf options' do
      pdf_data = create_pdf_data { text 'Hello' }

      diff_pdf_opts = ['--grayscale']

      mock(PdfMatcher::DiffPdf.instance).exec(
        is_a(Pathname), is_a(Pathname), output_diff: nil, options: diff_pdf_opts
      ).once

      PdfMatcher.match?(pdf_data, pdf_data, diff_pdf_opts: diff_pdf_opts)
    end

    test 'closing the file descriptor' do
      pdf_data = create_pdf_file { text 'Hello' }

      opened_files = { before: count_opened_files, after: nil }

      disable_gc {
        PdfMatcher.match?(pdf_data, pdf_data)
        opened_files[:after] = count_opened_files
      }

      assert_equal opened_files[:before], opened_files[:after]
    end

    sub_test_case 'generating a difference PDF' do
      test 'keep the PDF when the PDFs are not matched' do
        pdf1_data = create_pdf_data { text 'Hello' }
        pdf2_data = create_pdf_data { text 'Goodbye' }

        tmpfile = open_tempfile
        PdfMatcher.match?(pdf1_data, pdf2_data, output_diff: tmpfile.path)

        assert_pdf File.binread(tmpfile.path)
      end

      test 'remove (not keep) the PDF when the PDFs are matched' do
        pdf_data = create_pdf_data { text 'Hello' }

        tmpfile = open_tempfile
        PdfMatcher.match?(pdf_data, pdf_data, output_diff: tmpfile.path)

        assert_false File.exist?(tmpfile.path)
      end
    end
  end

  sub_test_case '.match' do
    test 'when specifying pdf datas' do
      pdf1_data = create_pdf_data { text 'Hello' }
      pdf2_data = create_pdf_data { text 'Goodbye' }

      tmpfile = open_tempfile
      result = PdfMatcher.match(pdf1_data, pdf2_data, output_diff: tmpfile.path)

      assert_instance_of PdfMatcher::MatchResult, result
      assert_false result.matched?
      assert_nil result.pdf1_path
      assert_nil result.pdf2_path
      assert_pdf result.pdf1_data
      assert_pdf result.pdf2_data
      assert_equal tmpfile.path, result.diff_pdf_path.to_s
      assert_equal File.binread(tmpfile.path), result.diff_pdf_data
    end

    test 'when specifying pdf paths' do
      pdf1_path = create_pdf_file { text 'Hello' }
      pdf2_path = create_pdf_file { text 'Goodbye' }

      tmpfile = open_tempfile
      result = PdfMatcher.match(pdf1_path, pdf2_path, output_diff: tmpfile.path)

      assert_instance_of PdfMatcher::MatchResult, result
      assert_false result.matched?
      assert_equal pdf1_path, result.pdf1_path.to_s
      assert_equal pdf2_path, result.pdf2_path.to_s
      assert_pdf result.pdf1_data
      assert_pdf result.pdf2_data
      assert_equal tmpfile.path, result.diff_pdf_path.to_s
      assert_equal File.binread(tmpfile.path), result.diff_pdf_data
    end

    test 'when the PDFs are matched' do
      pdf_data = create_pdf_data { text 'Hello' }

      tmpfile = open_tempfile
      result = PdfMatcher.match(pdf_data, pdf_data, output_diff: tmpfile.path)

      assert_instance_of PdfMatcher::MatchResult, result
      assert_true result.matched?
      assert_nil result.pdf1_path
      assert_nil result.pdf2_path
      assert_equal pdf_data, result.pdf1_data
      assert_equal pdf_data, result.pdf2_data
      assert_nil result.diff_pdf_path
      assert_nil result.diff_pdf_data
    end
  end

  sub_test_case 'config.diff_pdf_opts' do
    teardown { PdfMatcher.config.diff_pdf_opts = nil }

    test 'read and write' do
      assert_nil PdfMatcher.config.diff_pdf_opts

      PdfMatcher.config.diff_pdf_opts = ['--dpi=300', '--grayscale']

      assert_equal ['--dpi=300', '--grayscale'], PdfMatcher.config.diff_pdf_opts
    end

    test 'the options should be applied' do
      pdf_data = create_pdf_data { text 'Hi' }

      PdfMatcher.config.diff_pdf_opts = ['--grayscale']

      mock(PdfMatcher::DiffPdf.instance).exec(
        is_a(Pathname), is_a(Pathname), output_diff: nil, options: ['--grayscale']
      ).once

      PdfMatcher.match?(pdf_data, pdf_data)
    end
  end
end
