require "umbrellify/configuration"
require "umbrellify/models/swift_source_file"

module Umbrellify
    class ImportsManager
    def initialize(configuration)
        @configuration = configuration
    end

    def process_directory(source_path)
        files = Dir[source_path]
        files.each do |file|
        source_file = SwiftSourceFile.new(file)
        source_file.substitute_imports_if_needed!(@configuration)
        end
    end
    end
end