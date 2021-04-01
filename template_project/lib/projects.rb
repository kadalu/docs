require "yaml"

module Projects
  def list_projects
    YAML.load(File.read("./lib/projects.yaml"))
  end
end

use_helper Projects
