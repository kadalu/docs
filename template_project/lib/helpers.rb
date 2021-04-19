require "yaml"

use_helper Nanoc::Helpers::Blogging
use_helper Nanoc::Helpers::Rendering

def link_from_title(project, version, title)
  "/#{project}/#{version}/#{title.gsub(/\s/, "-").downcase}/"
end

def sidemenu(project, version)
  YAML.load(File.read("./content/#{project}/#{version}/index.yml"))
end

def first_chapter(project, version)
  chapters = YAML.load(File.read("./content/#{project}/#{version}/index.yml"))
  first_one = nil
  sidemenu(project, version).each do |section|
    section["chapters"].each do |chapter|
      first_one = chapter
      break
    end

    break
  end

  first_one
end

$projects = nil

def supported_versions(project_name)
  $projects = list_projects if $projects.nil?

  versions = []
  $projects.each do |project|
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

def project_and_version_from_url(item_path)
  $projects = list_projects if $projects.nil?
  parts = item_path.gsub("/docs/", "/").split("/", 4)
  project_name = ""
  project_version = ""
  chapter = ""
  $projects.each do |project|
    if project["name"] == parts[1]
      project_version = parts[2]
      project_name = parts[1]
    end
  end

  if project_name != "" && project_version != "" && parts.size == 4
    chapter = parts[3]
  end
  
  [project_name, project_version, chapter]
end

def project_from_url(item_path)
  parts = item_path.gsub("/docs/", "/").split("/", 4)

  parts[1]
end

def project_from_name(name)
  $projects = list_projects if $projects.nil?
  project = nil
  $projects.each do |proj|
    if proj["name"] == name
      project = proj
      break
    end
  end

  project
end
