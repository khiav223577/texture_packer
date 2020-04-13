require 'pathname'
require 'fileutils'
require 'texture_packer'

class TexturePacker::Cli
  def initialize(argv)
    @options = Options.new(argv)
  end

  def run
    return @options.hook_run.call if @options.hook_run

    pack_css!

    packer = create_packer
    output0, output1, output2 = packer.parse!
    output = output0 + output1 + output2

    compress_images! # 壓縮圖片
    write_to_file('packed.scss', output)

    write_to_project_dir!(packer, output1, output2) if @options.project_dir
  end

  private

  def pack_css!
    exec_cmd('TexturePacker', 'packer.tps')
  end

  # ----------------------------------------------------------------
  # ● 壓縮圖片
  # ----------------------------------------------------------------
  def compress_images!
    output_paths_mapping.each do |_, path|
      exec_cmd('pngquant', "#{path}.png", '--force')
    end
  end

  def create_packer
    split_type = case
                 when File.exist?('packed_tw_m.css') ; TexturePacker::SPLIT_BY_I18N_AND_MOBILE
                 when File.exist?('packed_m.css')    ; TexturePacker::SPLIT_BY_MOBILE
                 when File.exist?('packed_tw.css')   ; TexturePacker::SPLIT_I18N
                 end

    # 由路徑計算 class 名字
    dir_name = File.expand_path(Dir.pwd).gsub(%r{.*/Texture-Packer/.*?/(.*)}, '\1')

    content = output_paths_mapping.map{|_, path| File.read("#{path}.css") }.join
    return TexturePacker.new(dir_name, output_paths_mapping, content, split_type)
  end

  def output_paths_mapping
    @output_paths_mapping ||= begin
      Dir['*.css'].sort.map do |path|
        name = File.basename(path, '.css')
        next [name[/packed_(.*)/, 1], name]
      end.to_h
    end
  end

  # ----------------------------------------------------------------
  # ● 自動輸出到專案
  # ----------------------------------------------------------------
  def write_to_project_dir!(packer, output1, output2)
    css_pre_lines = ["@import './mixin.scss';"]
    css_pre_lines.unshift("@import 'global_mixins';") if packer.need_global_mixins?

    sub_dirs = packer.dir_name.split(File::Separator)[0...-1]

    project_assets_path = Pathname.new(@options.project_dir).join('app', 'assets')
    css_path = project_assets_path.join('stylesheets', 'packed_sprites', *sub_dirs, packer.dir_without_theme)
    img_path = project_assets_path.join('images', *sub_dirs)
    FileUtils.mkdir_p(css_path)
    FileUtils.mkdir_p(img_path)
    write_to_file(css_path.join('mixin.scss'), output1)
    write_to_file(css_path.join('ocean.scss'), "#{css_pre_lines.join("\n")}\n\n#{output2}")
    packer.output_paths_mapping.each do |_, path|
      FileUtils.cp("#{path}-fs8.png", img_path.join("#{path.sub('packed', packer.base_dir_name)}.png"))
    end
  end

  def exec_cmd(*args)
    puts args.join(' ')
    puts system(*args)
  rescue => e
    puts e
  end

  def write_to_file(path, content)
    puts "output: #{path} #{File.write(path, content)} bytes"
  end
end

require 'texture_packer/cli/options'
