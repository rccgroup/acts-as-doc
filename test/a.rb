class A
  extend ActsAsDoc::Schema

  # @success
  # @prop [integer] :total total books
  # @prop [array] :ids id array
  # @prop [array] $books book items
  # @prop [integer] $books.id book id
  # @prop [object] $books.$author book author
  # @prop [string] $books.$author.name book author name
  # @prop [integer] $books.status book status
end
