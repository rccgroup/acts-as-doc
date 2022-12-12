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

    TYPE_MAPPER = {
      integer: 'integer',
      string: 'string',
      decimal: 'number',
      text: 'string',
      geography: 'string',
      json: 'object',
      jsonb: 'object',
      array: 'array'
    }.freeze

    # 处理注释
    #
    # @param token [String] one line of comments
    def on_comment(token)
      @comments ||= []
      @comments << token[1..]
    end

    # Make props recursion
    #
    # @example
    #   >> ActsAsDoc::ResponseParser.props_recursion!({}, '$a.$b.c', 'c', 'd')
    #   # => {'a' => }
    #
    # @return [Hash] 处理过的hash
    # rubocop:disable all
    def self.props_recursion!(hash, name, type, desc = '', klass = nil)
      arr = name.split('.')
      name = arr.shift.sub(/^\$/, '')

      hash[name] = {} unless hash.key?(name)

      if arr.empty?
        if klass && (matches = desc.match(/^\(([a-zA-Z]+)\)$/))
          columns = Object.const_get(klass).columns.map do |column|
            [ column.name.to_s, [TYPE_MAPPER[column.type], column.comment] ]
          end.to_h

          matches[1].split(',').each do |attr_name|
            c_type, c_desc = columns[attr_name]
            self.props_recursion!(hash, "$#{name}.#{attr_name}", c_type, c_desc)
          end
        else
          hash[name].merge!(type: type, description: desc)
        end
      else
        nest_hash = hash[name]
        nest_hash[:properties] = {} unless nest_hash.key?(:properties)
        self.props_recursion!(nest_hash[:properties], arr.join('.'), type, desc, klass)
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

          matches = type.match(/\[(?<type>[a-zA-Z<>]+)\]/)
          type = matches ? matches[:type] : 'string'

          klass_matches = type.match(/(?<type>[a-zA-Z]+)<(?<klass>[a-zA-Z]+)>/)
          klass = nil
          if klass_matches
            type = SUPPORT_TYPES.include?(klass_matches[:type]) ? klass_matches[:type] : 'string'
            klass = klass_matches[:klass]
          end

          if name.start_with?(':')
            name = name.sub(/^:/, '')
            schema[name] = { type: type, description: desc }
          end

          if name.start_with?(REF_FLAG)
            self.class.props_recursion!(schema, name, type, desc, klass)
          end
        end
      end
      schema
    end
  end
end
