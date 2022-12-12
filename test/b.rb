Column = Struct.new(:name, :type, :comment)

class Book
  def self.columns
    [
      Column.new(:id, :integer, 'book id')
    ]
  end
end

class BookAuthor
  def self.columns
    [
      Column.new(:name, :string, 'book author name')
    ]
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
  # @prop [object<BookAuthor>] $item.$author (name)
  # @prop [integer] $item.status book status
end
