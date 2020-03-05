require 'optparse'

class TexturePacker::Cli::Options
  attr_reader :hook_run
  attr_reader :proejct_dir

  def initialize(argv)
    OptionParser.new do |opts|
      opts.on('-v', '--version', 'show the version number') do
        @hook_run = ->{ puts(TexturePacker::VERSION) }
      end

      opts.on("-h", "--help", "Prints this help") do
        @hook_run = ->{ puts(opts) }
      end

      opts.on("-pPATH", "--project_dir=PATH", "Copy the generated scss files / images to specified project") do |val|
        @proejct_dir = val
      end
    end.parse!(argv)
  end
end
