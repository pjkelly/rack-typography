require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "rack-typography"
    gem.summary = %Q{Rack middleware for automatically cleaning typography}
    gem.description = gem.summary
    gem.email = "me@pjkel.ly"
    gem.homepage = "http://github.com/pjkelly/rack-typography"
    gem.authors = ["PJ Kelly"]
    gem.files = FileList['lib/**/*.rb']
    gem.add_dependency 'rack', '>= 1.0.0'
    gem.add_dependency 'rubypants', '>= 0.2.0'
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'rake/testtask'
Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'test'
  test.pattern = 'test/**/*_test.rb'
  test.verbose = true
end

task :default => :test

task :spec do
  system("spec --options spec/spec.opts spec/*_spec.rb") || raise
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = File.read('VERSION')
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "rack-typography #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
