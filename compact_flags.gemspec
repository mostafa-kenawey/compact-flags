$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "compact_flags/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "compact_flags"
  s.version     = CompactFlags::VERSION
  s.authors     = ["Dr-Click", "ModSaid"]
  s.email       = ["ragab.mostafa@gmail.com", "mahmoud@modsaid.com"]
  s.homepage    = "https://github.com/dr-click/compact-flags"
  s.summary     = "Ruby Gem to store many boolean flags in an integer column by utilizing bits"
  s.description = "CompactFlags comes to serve models with several boolean flags. in large data volumes where the flags can be used to slice the data in several ways. queries tend to be heavier and more indexes are needed by time."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
end
