$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'workarea/browse_option/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'workarea-browse_option'
  s.version     = Workarea::BrowseOption::VERSION
  s.authors     = ['Matt Duffy']
  s.email       = ['mduffy@workarea.com']
  s.homepage    = 'https://github.com/workarea-commerce/workarea-browse-option'
  s.summary     = 'Adds browsing products by an option to the Workarea Commerce Platform'
  s.description = 'Adds browsing products by an option (e.g. color) to the Workarea Commerce Platform'
  s.files = `git ls-files`.split("\n")
  s.license = 'Business Software License'

  s.required_ruby_version = '>= 2.3.0'

  s.add_dependency 'workarea', '~> 3.x', '>= 3.5.x'
end
