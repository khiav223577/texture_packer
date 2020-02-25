require 'optparse'

class TexturePacker::Cli::Options
  attr_reader :hook_run

  def initialize(argv)
    OptionParser.new do |opts|
      opts.on('-v', '--version', 'show the version number') do
        @hook_run = ->{ puts(TexturePacker::VERSION) }
      end

      opts.on("-h", "--help", "Prints this help") do
        @hook_run = ->{ puts(opts) }
      end
    end.parse!(argv)
  end
end
