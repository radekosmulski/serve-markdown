require 'erubi'
require 'tilt'
require 'fileutils'
require 'webrick'

FileUtils.remove_dir('html', force=true)
FileUtils.mkdir('html')

layout = Tilt.new(File.join(__dir__, 'templates/layout.html.erb'))
filenames = Dir['*.md'].map { |fn| fn[/(.*)\.md/, 1] } # removing the .md suffix from fns

filenames.map { |fn| ["#{fn}.md", "#{fn}.html"] }.each do |md_fn, html_fn|
  contents = Tilt.new(md_fn).render
  File.open(File.join('html', html_fn), 'w') do |file|
    file.write layout.render(Object.new, contents: contents, filenames: filenames)
  end
end

root = File.expand_path 'html'
server = WEBrick::HTTPServer.new :Port => 8000, :DocumentRoot => root
trap 'INT' do server.shutdown end
server.start
