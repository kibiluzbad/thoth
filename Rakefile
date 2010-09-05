require 'rake'  
require 'rake/rdoctask'  

namespace :rdoc do
  desc "Generate app documentation on docs."
  task :create do    
    puts "######## Creating RDoc documentation"  
    system "rm -rf docs"
    system "rdoc --charset utf8 --op docs/ --inline-source -T hana"  
  end
end

