# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/transparent_trash/version"

Gem::Specification.new do |s|
  s.version = Decidim::TransparentTrash.version
  s.authors = ["Quentinchampenois"]
  s.email = ["26109239+Quentinchampenois@users.noreply.github.com"]
  s.license = "AGPL-3.0"
  s.homepage = "https://decidim.org"
  s.metadata = {
    "bug_tracker_uri" => "https://github.com/decidim/decidim/issues",
    "documentation_uri" => "https://docs.decidim.org/",
    "funding_uri" => "https://opencollective.com/decidim",
    "homepage_uri" => "https://decidim.org",
    "source_code_uri" => "https://github.com/decidim/decidim"
  }
  s.required_ruby_version = ">= 3.0.2"

  s.name = "decidim-transparent_trash"
  s.summary = "A decidim transparent_trash module"
  s.description = "Provide a transparent trash where rejected initiatives are public and accessible."

  s.files = Dir["{app,config,lib,vendor}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]
end
