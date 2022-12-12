Column = Struct.new(:name, :type, :comment)

class Book
  def self.columns
    [
      Column.new(:id, :integer, 'book id')
    ]
  end

  class Author
    def self.columns
      [
        Column.new(:name, :string, 'book author name'),
        Column.new(:address, :string, 'book author address')
      ]
    end
  end
end

class B
  extend ActsAsDoc::Schema

  # @success
  # @prop [integer] :total total books
  # @prop [array] :ids id array
  # @prop [array] $item book item
  # @prop [array<Book>] $item (id)
  # @prop [object] $item.$author book author
  # @prop [object<Book::Author>] $item.$author (name, address)
  # @prop [integer] $item.status book status
end
