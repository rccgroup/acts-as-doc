# frozen_string_literal: true

require_relative './acts_as_doc/response_parser'

module ActsAsDoc
  # Example:
  #   class A
  #     extend ActsAsDoc::Schema
  #   end
  #
  #   >> A.swagger_schema
  module Schema
    # @return [Hash] Swagger schema hash
    def swagger_schema
      path = const_source_location(self.name).first
      parser = ResponseParser.new(File.read(path))
      parser.parse
      parser.schema
    end
  end
end
