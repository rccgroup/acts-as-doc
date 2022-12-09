# frozen_string_literal: true

require 'ripper'

module ActsAsDoc
  # @success and @prop comment parser
  class ResponseParser < Ripper::SexpBuilder
    SUPPORT_TYPES = %w[
      string
      number
      integer
      boolean
      array
      object
    ].freeze

    REF_FLAG = '$'

    # 处理注释
    #
    # @param token [String] one line of comments
    def on_comment(token)
      @comments ||= []
      @comments << token[1..]
    end

    # Make props recursion
    # @example
    #   >> ActsAsDoc::ResponseParser.props_recursion!({}, '$a.$b.c', 'c', 'd')
    #   # => {'a' => }
    #
    # @return [Hash] 处理过的hash
    # rubocop:disable all
    def self.props_recursion!(hash, name, type, desc)
      arr = name.split('.')
      name = arr.shift.sub(/^\$/, '')

      hash[name] = {} unless hash.key?(name)

      if arr.empty?
        hash[name].merge!(type: type, description: desc)
      else
        nest_hash = hash[name]
        nest_hash[:properties] = {} unless nest_hash.key?(:properties)
        self.props_recursion!(nest_hash[:properties], arr.join('.'), type, desc)
      end

      hash
    end

    # @return [Hash] response schema
    # rubocop:disable all
    def schema
      schema = {}
      @comments.each do |comment|
        comment.strip!
        # Only need to deal with @success and @prop
        next unless comment =~ /@(success|prop)/

        arr = comment.split
        tag, type, name = arr[..2]

        if tag == '@prop'
          desc = arr[3..] ? arr[3..].join(' ') : ''
          matches = type.match(/\[(?<type>#{SUPPORT_TYPES.join('|')})\]/)
          type = matches ? matches[:type] : 'string'

          if name.start_with?(':')
            name = name.sub(/^:/, '')
            schema[name] = { type: type, description: desc }
          end

          if name.start_with?(REF_FLAG)
            self.class.props_recursion!(schema, name, type, desc)
          end
        end
      end
      schema
    end
  end
end
