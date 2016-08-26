require 'cocoapods-uploader/command/maven/config'
require 'rest-client'
require 'zip'
require 'fileutils'

module Pod
  class Command
    class Maven < Upload
      self.summary = 'Upload file/dir to remote maven repository.'

      self.description = <<-DESC
        Upload file/dir to remote maven repository.
      DESC

      self.arguments = [
            CLAide::Argument.new('PATH', true),
            CLAide::Argument.new('SPEC', true)
        ]

      def initialize(argv)
        @path = argv.shift_argument
        @spec = argv.shift_argument
        super
      end

      def validate!
        super
        help! 'path & spec is required.' unless @path && @spec
      end

      def run
        version = Specification.from_file(@spec).version
        name = Specification.from_file(@spec).name
       
        file_name = "#{name}.gz"
        compress_file(@path,file_name)

        setting = Pod::Setting.new
        setting.open
        
        url = "#{setting.host}#{setting.suffix.gsub('+repo+',setting.repo)}/#{name.downcase}/#{name.downcase}/#{version}/#{file_name.downcase}"
        puts "Upload url: #{url}"
        RestClient::Resource.new(url, :user => "#{setting.user}", :password => "#{setting.password}").post(:file => File.new(file_name.downcase)).code

      end


      private

      def compress_file(path,file_name)
        file = "./#{file_name}"
        if Pod::Config.instance.verbose?
          puts "Compress File #{file}"
        end
        if File.exist?(file)
          FileUtils.rm(file)
        end
        entries = [path]#Dir.entries(path) - %w(. ..)
        Zip::File.open(file, ::Zip::File::CREATE) do |io|
          write_entries entries, '', io
        end
      end

      def write_entries(entries, inpath, io)
        entries.each do |e|
          entry_path = inpath == '' ? e : File.join(inpath, e)
          zip_path = File.join('.', entry_path)

          if Pod::Config.instance.verbose?
            puts "Deflating #{zip_path}"
          end

          if File.directory? zip_path
            recursively_deflate_directory(zip_path, io, entry_path)
          else
            put_into_archive(zip_path, io, entry_path)
          end
        end
      end

      def recursively_deflate_directory(zip_path, io, entry_path)
        io.mkdir entry_path
        subdir = Dir.entries(zip_path) - %w(. ..)
        write_entries subdir, entry_path, io
      end

      def put_into_archive(zip_path, io, entry_path)
        io.get_output_stream(entry_path) do |f|
          f.puts(File.open(zip_path, 'rb').read)
        end
      end

    end
  end
end
