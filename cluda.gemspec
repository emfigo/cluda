Gem::Specification.new do |s|
  s.name           = 'cluda'
  s.version        = '0.0.1'
  s.date           = "#{Time.now.strftime("%Y-%m-%-d")}"
  s.summary        = 'CLuDA'
  s.license        = 'MIT'
  s.description    = 'CLustering Data Analysis gem'
  s.authors        = ['Enrique Figuerola']
  s.email          = 'hard_rock15@msn.com'
  s.files          = ['lib/cluda.rb']
  s.require_paths  = ['lib']
  s.homepage       = 'https://github.com/emfigo/cluda'

  s.add_development_dependency(%q<rspec>, [">= 2.11.0"])
  s.add_development_dependency(%q<rake>, [">= 0"])
end
