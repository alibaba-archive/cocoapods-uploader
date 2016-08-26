
module Pod
  class Command
    class Upload < Command

      require 'cocoapods-uploader/command/maven/maven'
      require 'cocoapods-uploader/command/maven/set'

      self.abstract_command = true

      self.summary = 'Upload file/dir to remote storage.'

      self.description = <<-DESC
        Upload file/dir to remote storage.
      DESC

      self.default_subcommand = 'maven'

    end
  end
end
