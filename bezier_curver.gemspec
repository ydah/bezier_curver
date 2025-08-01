# frozen_string_literal: true

require_relative 'lib/bezier_curver/version'

Gem::Specification.new do |spec|
  spec.name = 'bezier_curver'
  spec.version = BezierCurver::VERSION
  spec.authors = ['Yudai Takada']
  spec.email = ['t.yudai92@gmail.com']

  spec.summary               = 'A tool for drawing Bezier curves with Ruby2D'
  spec.description           = 'Interactive Bezier curve drawing tool using Ruby2D. Click to add control points and draw 4th degree Bezier curves.'
  spec.homepage              = 'https://github.com/ydah/bezier_curver'
  spec.license               = 'MIT'
  spec.required_ruby_version = '>= 3.2'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/master/CHANGELOG.md"
  spec.metadata['rubygems_mfa_required'] = 'true'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ Gemfile .gitignore .github/])
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'ruby2d', '~> 0.12'
end
