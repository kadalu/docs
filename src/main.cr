require "yaml"

struct Project
  include YAML::Serializable

  property name = "",
           title = "",
           description = "",
           docs_dir = "docs",
           repo = "",
           versions = [] of String
end

def prepare_versioned_docs(project, version)
  `cd #{ENV["ROOT_DIR"]}/tmpdocs/#{project.name} && git checkout -b v#{version} #{version}`
  Dir.mkdir_p("#{ENV["ROOT_DIR"]}/tmpdocs/project/content/#{project.name}")

  # TODO: Replace Relative links, *.md links and *.adoc links

  `cp -r #{ENV["ROOT_DIR"]}/tmpdocs/#{project.name}/#{project.docs_dir} #{ENV["ROOT_DIR"]}/tmpdocs/project/content/#{project.name}/#{version}`

  version_dir = "#{ENV["ROOT_DIR"]}/tmpdocs/project/content/#{project.name}/#{version}"
  # Create empty redirect.html file
  `echo > #{version_dir}/redirect.html`
end

def init_rootdirs
  Dir.mkdir_p("#{ENV["ROOT_DIR"]}/tmpdocs")
  `cp -r template_project #{ENV["ROOT_DIR"]}/tmpdocs/project`
end

def clone_project(project)
  `git clone --depth 1 #{project.repo} #{ENV["ROOT_DIR"]}/tmpdocs/#{project.name}`
  `cd #{ENV["ROOT_DIR"]}/tmpdocs/#{project.name} && git fetch --depth=1 origin +refs/tags/*:refs/tags/*`
end

def build_docs_site
  `rm -rf #{ENV["ROOT_DIR"]}/tmpdocs/project/node_modules`
  `cd #{ENV["ROOT_DIR"]}/tmpdocs/project && bundle install`
  `cd #{ENV["ROOT_DIR"]}/tmpdocs/project && npm install`
  `cd #{ENV["ROOT_DIR"]}/tmpdocs/project && npm run prod:css`
  `cd #{ENV["ROOT_DIR"]}/tmpdocs/project && bundle exec nanoc`
end

def build(projects)
  ENV["ROOT_DIR"] ||= Path[Dir.current].expand.to_s

  init_rootdirs

  projects.each do |project|
    # Default values and derived fields
    project.name = project.repo.split("/")[-1] if project.name == ""

    if project.versions.size == 0
      # No versions specified
      next
    end

    clone_project(project)
    project.versions.each do |ver|
      prepare_versioned_docs(project, ver)
    end
  end

  build_docs_site
end

if ARGV.size != 1
  STDERR.puts "Usage: kadalu-docgen <projects-yaml>"
  exit(1)
end

build(Array(Project).from_yaml(File.read(ARGV[0])))
