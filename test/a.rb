class A
  extend ActsAsDoc::Schema

  # @success
  # @prop [integer] :total total books
  # @prop [array] :ids id array
  # @prop [array] $item book item
  # @prop [integer] $item.id book id
  # @prop [object] $item.$author book author
  # @prop [string] $item.$author.name book author name
  # @prop [integer] $item.status book status
end
