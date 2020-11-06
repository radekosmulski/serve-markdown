require 'erubi'
require 'tilt'
require 'webrick'
require 'optparse'
require 'pathname'
require 'fileutils'
require 'listen'

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

layout_path = Pathname.new('templates/layout.html.erb').exist? ? 'templates/layout.html.erb' : File.join(__dir__, 'templates/layout.html.erb')
layout = Tilt.new(layout_path)

generate_html = Proc.new do
  FileUtils.remove_dir('html', force=true)
  FileUtils.mkdir('html')

  filenames = Dir['*.md'].map { |fn| fn[/(.*)\.md/, 1] } # removes the .md suffix from fns

  filenames.map { |fn| ["#{fn}.md", "#{fn}.html"] }.each do |md_fn, html_fn|
    contents = Tilt.new(md_fn).render
    File.open(File.join('html', html_fn), 'w') do |file|
      file.write layout.render(Object.new, contents: contents, filenames: filenames)
    end
  end
end

generate_html.call

listener = Listen.to('.') do |modified, added ,removed|
  generate_html.call
end
listener.start

root = File.expand_path 'html'
server = WEBrick::HTTPServer.new :Port => 8000, :DocumentRoot => root
trap 'INT' do server.shutdown end
server.start
