lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'nifty/version'

Gem::Specification.new do |spec|
  spec.name          = 'nifty'
  spec.version       = Nifty::VERSION
  spec.authors       = ['gaotongfei']
  spec.email         = ['gaotongfei1995@gmail.com']

  spec.summary       = 'light weight rails query result builder'
  spec.description   = 'light weight rails query result builder'
  spec.homepage      = 'https://github.com/gaotongfei/nifty'

  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'minitest-reporters'
end
