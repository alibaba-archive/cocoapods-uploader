require 'cocoapods-uploader/command/maven/maven'
module Pod
  class Command
    class Set < Maven
      self.summary = 'Setting remote maven repository.'

      self.description = <<-DESC
        Setting remote maven repository.
      DESC

      self.arguments = [
            CLAide::Argument.new('HOST', true),
            CLAide::Argument.new('REPO', true),
            CLAide::Argument.new('USER', false),
            CLAide::Argument.new('PASSWORD', false),
            CLAide::Argument.new('SUFFIX', false)
        ]

      def initialize(argv)
        @host     = argv.shift_argument
        @repo     = argv.shift_argument
        @user     = argv.shift_argument
        @password = argv.shift_argument
        @suffix   = argv.shift_argument
        super
      end

      def validate!
        # super
        help! 'host & repo  is required.' unless @host && @repo 
      end

      def run
        config = Pod::Setting.new('user'=>@user,'password'=> @password,'host'=>@host,'repo'=>@repo,'suffix'=>@suffix)
        config.save
      end

    end
  end
end
