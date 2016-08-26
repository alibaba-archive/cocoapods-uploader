require 'cocoapods-uploader/command/maven/config'
require 'rest-client'
require 'zip'
require 'fileutils'

module Pod
  class Command
    class Maven < Upload
      attr_accessor :path, :spec

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
       
        file_name = "#{name}.zip"
        compress(@path.dup,file_name)

        setting = Pod::Setting.new
        setting.open
        
        url = "#{setting.host}#{setting.suffix.gsub('+repo+',setting.repo)}/#{name.downcase}/#{name.downcase}/#{version}/#{file_name.downcase}"
        puts "Upload url: #{url}"
        RestClient::Resource.new(url, :user => "#{setting.user}", :password => "#{setting.password}").post(:file => File.new(file_name.downcase)).code

      end


      private

      def compress(path,file_name)
        path.sub!(%r[/$],'')
        archive = File.join(File.dirname(path),file_name)
        if Pod::Config.instance.verbose?
          puts "Compress to File #{archive}"
        end
        FileUtils.rm archive, :force=>true

        Zip::OutputStream.open(archive) do |zip|
          Dir["#{path}/**/**"].reject{|f|f==archive}.each do |file|
            if Pod::Config.instance.verbose?
              puts "Deflating #{file}"
            end
            entry = Zip::Entry.new("", file)
            entry.gather_fileinfo_from_srcpath(file)
            zip.put_next_entry(entry, nil, nil, Zip::Entry::DEFLATED, Zlib::BEST_COMPRESSION)
            entry.write_to_zip_output_stream(zip)
          end
        end
      end

    end
  end
end
