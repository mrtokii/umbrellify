Gem::Specification.new do |s|
    s.name        = 'umbrellify'
    s.version     = '0.0.1'
    s.date        = '2020-03-24'
    s.summary     = "umbrellify makes combined Swift frameworks"
    s.description = "Make combined Swift frameworks"
    s.authors     = ["Vitaliy Salnikov"]
    s.email       = 'mrtokii@outlook.com'
    s.files       = Dir['lib/**/*.rb']
    s.homepage    = 'https://rubygems.org/gems/umbrellify'
    s.license     = 'MIT'
    
    s.add_runtime_dependency 'xcodeproj'
    
    s.executables << 'umbrellify'
end