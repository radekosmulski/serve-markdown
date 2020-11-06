Gem::Specification.new do |s|
  s.name        = 'serve-markdown'
  s.version     = '0.0.5'
  s.date        = '2020-11-03'
  s.summary     = "Serve markdown files from current directory on localhost."
  s.description = "A simple solution for serving markdown files from current directory."
  s.authors     = ["Radek Osmulski"]
  s.email       = 'rosmulski@gmail.com'
  s.files       = Dir['lib/*.rb', 'lib/templates/*.html.erb']
  s.homepage    =
    'https://rubygems.org/gems/serve-markdown'
  s.license       = 'MIT'
  s.executables << 'serve-markdown'

  s.add_dependency 'erubi', '~> 1.9'
  s.add_dependency 'tilt', '~> 2.0'
  s.add_dependency 'pandoc-ruby', '~> 2.1'
  s.add_dependency 'webrick', '~> 1.6'
  s.add_dependency 'listen', '~> 3.2'
end
