# frozen_string_literal: true

module PdfMatcher
  module PdfFile
    def self.init(path_or_data)
      case path_or_data
      # when a pdf path passed as a Pathname
      when Pathname
        File.new(path_or_data)
      when String
        # when a pdf data passed
        if path_or_data =~ /^%PDF-/
          Tempfile.new(path_or_data)
        # when a pdf path passed
        else
          File.new(path_or_data)
        end
      else
        raise ArgumentError
      end
    end

    class Base
      attr_reader :data, :path

      def initialize(data:, path:)
        @data = data
        @path = path
      end

      def open; end
      def close; end
    end

    class File < Base
      def initialize(path)
        super(data: nil, path: Pathname(path))
      end

      def data
        @data ||= path.binread
      end
    end

    class Tempfile < Base
      def initialize(data)
        super(data: data, path: nil)
        @io = nil
      end

      def open
        @io ||= Temfile.open
      end

      def path
        path = @io&.path
        path ? Pathname(path) : nil
      end

      def close
        @io&.close!
        @io = nil
      end
    end
  end
end
