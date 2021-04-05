require "yaml"

def link_from_title(project, version, title)
  "/#{project}/#{version}/#{title.gsub(/\s/, "-").downcase}"
end

def sidemenu(project, version)
  YAML.load(File.read("./content/#{project}/#{version}/index.yml"))
end

def supported_versions(project_name)
  projects = YAML.load(File.read("./content/projects.yml"))

  versions = []
  projects.each do |project|
    if project["name"] == project_name
      versions = project["versions"]
      break
    end
  end

  versions
end

def list_projects
  YAML.load(File.read("./content/projects.yml"))
end
