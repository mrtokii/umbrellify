Gem::Specification.new do |s|
    s.name        = 'umbrellify'
    s.version     = '0.0.1'
    s.date        = '2020-03-25'
    s.summary     = 'Create alias for multiple Swift frameworks'
    s.description = 'Umbrellify is a tool that combines frameworks into an alias. It uses [@_exported] annotation to provide a single import declaration, which exports multiple other imports. The only supported language is Swift.'
    s.authors     = ['Vitaliy Salnikov']
    s.email       = 'mrtokii@outlook.com'
    s.files       = Dir['lib/**/*.rb']
    s.homepage    = 'https://github.com/mrtokii/umbrellify'
    s.license     = 'MIT'
    
    s.add_runtime_dependency 'xcodeproj', '~> 1.15'
    
    s.executables << 'umbrellify'
end