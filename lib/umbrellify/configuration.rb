require "yaml"

module Umbrellify
  class Configuration
    def initialize(config_path)
      configuration = YAML.load_file(config_path)

      @umbrella_name = configuration["umbrella_target_name"]
      @main_target_name = configuration["main_target_name"]
      @managed_imports = configuration["managed_targets"]
      @project_path = configuration["project_path"]
      @source_path = configuration["source_path"]
      @substitute_managed_imports_only = configuration["substitute_managed_imports_only"]
    end

    # Getters

    def umbrella_name
      @umbrella_name
    end

    def main_target_name
      @main_target_name
    end

    def managed_imports
      @managed_imports
    end
    
    def project_path
      @project_path
    end
    
    def source_path
      @source_path
    end

    def substitute_managed_imports_only
      @substitute_managed_imports_only
    end
  end
end
