require 'pathname'
require 'fileutils'
require 'erubi'
require 'tilt'
require 'webrick'
require 'optparse'

@options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: markdown-serve [options]"
  opts.on("-h", "--help", "Prints this help") do
    puts opts; exit
  end

  opts.on("-o", "--output-templates", "Output templates to local directory") do
    FileUtils.cp_r File.join(__dir__, 'templates'), '.'; exit
  end
end.parse!

FileUtils.remove_dir('html', force=true)
FileUtils.mkdir('html')

layout_path = Pathname.new('templates/layout.html.erb').exist? ? 'templates/layout.html.erb' : File.join(__dir__, 'templates/layout.html.erb')

layout = Tilt.new(layout_path)
filenames = Dir['*.md'].map { |fn| fn[/(.*)\.md/, 1] } # removes the .md suffix from fns

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
