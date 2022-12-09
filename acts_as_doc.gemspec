# rubocop:disable all
Gem::Specification.new do |s|
  s.name        = "acts_as_doc"
  s.version     = "1.0.0"
  s.summary     = "Generate swagger response doc"
  s.description = "Add swagger comment to any ruby file for generating swagger response doc struct"
  s.authors     = ["alex.zang"]
  s.email       = "alex.zang@rccchina.com"
  s.files       = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test)/}) }
  s.homepage    = "https://github.com/rccgroup/acts-as-doc"
  s.license     = "MIT"
  s.required_ruby_version = '>= 2.7.0'
end
