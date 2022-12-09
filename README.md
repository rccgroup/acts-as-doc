# acts-as-doc
Add swagger comment to any ruby file for generating swagger response doc struct

# Install

Add this line to your application's Gemfile:

```
gem 'acts_as_doc'
```

# Usage

```ruby
class A
  extend ActsAsDoc::Schema

  # @prop [integer] :total Total
end

A.swagger_schema
# => 
{
  'total' => {type: 'integer', description: 'Total'}  
}
```

# Test

Run Test Unit
```
rake test
```


