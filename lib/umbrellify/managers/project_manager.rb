require "xcodeproj"

module Umbrellify
  class ProjectManager
    def initialize(project_path, configuration)
      @project_path = project_path
      @configuration = configuration
    end

    # =-=-=-=-=-=-=-=-=-=-=-=- Public Interface =-=-=-=-=-=-=-=-=-=-=-=-

    def apply
      open_project

      umbrella_target = add_umbrella_target_if_needed
      umbrella_files_path = create_umbrella_files
      add_umbrella_files_to_target(umbrella_files_path, umbrella_target)
      add_dependency_to_main_target(umbrella_target)

      @project.save
    end

    # =-=-=-=-=-=-=-=-=-=-=-=- Private =-=-=-=-=-=-=-=-=-=-=-=-

    def open_project
      @project = Xcodeproj::Project.open(@project_path)
    end

    private :open_project

    def add_umbrella_target_if_needed
      existing_umbrella_targets = @project.targets.select { |t| t.name == umbrella_name }

      umbrella_target = existing_umbrella_targets.first

      if umbrella_target.nil?
        umbrella_target = @project.new_target(:framework, umbrella_name, :ios, "10.0")
        @project.save
      end

      return umbrella_target
    end

    private :add_umbrella_target_if_needed

    def create_umbrella_files
      project_dir_path = File.dirname(@project_path)
      work_path = "#{project_dir_path}/#{umbrella_name}"

      umbrella_source_path = "#{work_path}/#{umbrella_name}-combined.swift"

      Dir.mkdir(work_path) unless Dir.exist?(work_path)
      File.write(umbrella_source_path, umbrella_source(@configuration.managed_imports))

      return work_path
    end

    private :create_umbrella_files

    def add_umbrella_files_to_target(path, target)
      work_group = @project.main_group

      work_group.children.select { |child| child.name == umbrella_name }.each do |child|
        remove_files(child)
      end

      add_files(path, work_group, target)
    end

    private :add_umbrella_files_to_target

    def add_dependency_to_main_target(target)
      main_target.add_dependency(target)
    end

    private :add_dependency_to_main_target

    # =-=-=-=-=-=-=-=-=-=-=-=- Helpers =-=-=-=-=-=-=-=-=-=-=-=-

    def umbrella_name
      @configuration.umbrella_name
    end

    private :umbrella_name

    def main_target
      @project.targets.select { |t|
        t.name == @configuration.main_target_name
      }.first
    end

    private :main_target

    def umbrella_source(managed_frameworks)
      exported_imports = managed_frameworks.map { |f| "@_exported import #{f}" }.join("\n")

      source = <<SOURCE
// This file is generated automatically by Umbrellify.
// Do not edit contents of this file!

#{exported_imports}
SOURCE
    end

    private :umbrella_source

    def add_files(directory, group, target)
      Dir.glob(directory) do |item|
        next if item == "." or item == ".DS_Store"

        if File.directory?(item)
          new_folder = File.basename(item)
          created_group = group.new_group(new_folder)
          add_files("#{item}/*", created_group, target)
        else
          file_reference = group.new_file(item)
          target.add_file_references([file_reference])
        end
      end
    end

    private :add_files

    def remove_files(object)
      if object.isa == "PBXGroup"
        object.children.each do |child|
          remove_files(child)
        end
      end

      object.remove_from_project
    end

    private :remove_files
  end
end