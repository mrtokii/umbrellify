module Umbrellify
  class SwiftSourceFile
    def initialize(file_path)
      @file_path = file_path
    end

    def get_file_text
      File.readlines(@file_path).join
    end

    private :get_file_text

    def strip_comments(file_text)
      comment_types = [
        /\/\/.*$/,    # one-line
        /\/\*.*\*\//m, # multiline
      ]

      result = file_text
      comment_types.each do |regexp|
        result = result.gsub regexp, ""
      end
      result
    end

    private :strip_comments

    def imports_list(file_text)
      import_search_regexp = /^import\s*(\w*).*$/
      file_text.scan(import_search_regexp).flatten
    end

    private :imports_list

    def needs_to_substitute_imports?(imports, managed_imports, configuration)
      return true unless configuration.substitute_managed_imports_only
      return true if imports.include? configuration.umbrella_name

      (managed_imports - imports).empty?
    end

    private :needs_to_substitute_imports?

    def override_file!(file_text)
      File.write(@file_path, file_text)
    end

    private :override_file!

    def substitute_imports_if_needed(configuration)
      umbrella_name = configuration.umbrella_name
      file_text = get_file_text()
      imports = imports_list(strip_comments(file_text))
      managed_imports = configuration.managed_imports

      if needs_to_substitute_imports?(imports, managed_imports, configuration)
        managed_imports_copy = managed_imports + [umbrella_name]
        umbrella_import = "import #{umbrella_name}"

        imports_list = imports.select { |value| managed_imports.include?(value) }
        
        imports_list.each_with_index do |value, index|
          regexp = /^import\s{1,}\b#{value}\b[^\n]*\n/ 
          substitution = index == imports_list.count - 1 ? "#{umbrella_import}\n" : ""

          file_text = file_text.gsub regexp, substitution
        end
      end

      return file_text
    end

    def substitute_imports_if_needed!(configuration)
      override_file! substitute_imports_if_needed(configuration)
    end
  end
end
