# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)

require 'pdf_matcher'
require 'test/unit'
require 'test/unit/rr'
require 'prawn'
require 'pathname'

class TestCase < Test::Unit::TestCase
  setup do
    @tmpfiles = []
  end

  teardown do
    @tmpfiles.each(&:close!)
  end

  def assert_pdf(data)
    assert data.is_a?(String) && data.match?(/^%PDF-/)
  end

  def create_pdf_data(&block)
    prawn_document(&block).render
  end

  def create_pdf_file(&block)
    open_tempfile { |tmpfile|
      prawn_document(&block).render_file(tmpfile.path)
    }.path
  end

  def prawn_document(&block)
    Prawn::Document.new { instance_eval(&block) }
  end

  def open_tempfile(&block)
    tmpfile = Tempfile.open { |f| @tmpfiles << f; f }
    block.call(tmpfile) if block_given?
    tmpfile
  end

  def count_opened_files
    ObjectSpace.each_object(File).reject(&:closed?).count
  end

  def disable_gc
    was_disabled = GC.disable
    begin
      yield
    ensure
      GC.enable unless was_disabled
    end
  end
end
