require "test/unit"
require "acts_as_doc"
require_relative './a'
require_relative './b'

class ActsAsDocTest < Test::Unit::TestCase
  def test_swagger_schema_in_common
    expected = {
      'total' => { description: 'total books', type: 'integer'},
      'ids' => { description: 'id array', type: 'array' },
      'item' => {
        description: 'book item',
        type: 'array',
        properties: {
          'id' => { description: 'book id', type: 'integer' },
          'author' => {
            description: 'book author',
            type: 'object',
            properties: {
              'name' => { description: 'book author name', type: 'string' }
            }
          },
          'status' => { description: 'book status', type: 'integer' }
        }
      }
    }
    assert_equal expected, A.swagger_schema
  end

  def test_swagger_schema_in_extend
    expected = {
      'total' => { description: 'total books', type: 'integer'},
      'ids' => { description: 'id array', type: 'array' },
      'item' => {
        description: 'book item',
        type: 'array',
        properties: {
          'id' => { description: 'book id', type: 'integer' },
          'author' => {
            description: 'book author',
            type: 'object',
            properties: {
              'name' => { description: 'book author name', type: 'string' },
              'address' => { description: 'book author address', type: 'string' }
            }
          },
          'status' => { description: 'book status', type: 'integer' }
        }
      }
    }
    assert_equal expected, B.swagger_schema
  end
end
