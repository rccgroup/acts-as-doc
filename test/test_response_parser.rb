require "test/unit"
require "acts_as_doc"

class ResponseParserTest < Test::Unit::TestCase
  def setup
    @parser = ActsAsDoc::ResponseParser.new(
      <<~CONTENT
        # This is comment
      CONTENT
    )
  end

  def test_on_comment
    @parser.parse
    expected = [
      " This is comment\n"
    ]
    assert_equal expected, @parser.instance_variable_get(:@comments)
  end

  def test_props_recursion!
    expected = {
      'a' => {
        :properties => {
          'b' => {
            :properties => {
              'c' => { description: 'bar', type: 'foo' }
            }
          }
        }
      }
    }
    hash = ActsAsDoc::ResponseParser.props_recursion!(
      {},
      '$a.$b.c',
      'foo',
      'bar'
    )
    assert_equal expected, hash
  end
end
