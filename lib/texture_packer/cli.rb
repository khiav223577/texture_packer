require 'pathname'
require 'fileutils'
require 'texture_packer'

class TexturePacker::Cli
  def initialize(argv)
    @options = Options.new(argv)
  end

  def run
    return @options.hook_run.call if @options.hook_run

    exec_cmd('TexturePacker', 'packer.tps')

    if File.exists?('packed_mobile.css') # 向下相容
      exec_cmd('mv', 'packed_mobile.css', 'packed_m.css')
      exec_cmd('mv', 'packed_mobile.png', 'packed_m.png')
    end
    has_mobile = true if File.exists?('packed_m.css')

    # ----------------------------------------------------------------
    # ● 由路徑計算 class 名字
    # ----------------------------------------------------------------
    dir_name = File.expand_path(Dir.pwd).gsub(/.*\/Texture-Packer\/.*?\/(.*)/, '\1')

    output_paths_mapping = Dir['*.css'].map do |path|
      name = File.basename(path, '.css')
      next [name[/packed_(.*)/, 1], name]
    end.to_h

    content = output_paths_mapping.map{|_, path| File.read("#{path}.css") }.join
    packer = TexturePacker.new(dir_name, output_paths_mapping, content, has_mobile)
    output0, output1, output2 = packer.parse!
    output = output0 + output1 + output2

    # ----------------------------------------------------------------
    # ● 壓縮圖片
    # ----------------------------------------------------------------
    output_paths_mapping.each do |_, path|
      exec_cmd('pngquant', "#{path}.png", '--force')
    end

    write_to_file('packed.scss', output)

    # ----------------------------------------------------------------
    # ● 自動輸出到專案
    # ----------------------------------------------------------------
    write_to_project_dir(packer, has_mobile) if @options.project_dir
  end

  private

  def write_to_project_dir(packer, has_mobile)
    css_pre_lines = ["@import './mixin.scss';"]
    css_pre_lines.unshift("@import 'global_mixins';") if has_mobile

    sub_dirs = packer.dir_name.split(File::Separator)[0...-1]

    project_assets_path = Pathname.new(@options.project_dir).join('app', 'assets')
    css_path = project_assets_path.join('stylesheets', 'packed_sprites', *sub_dirs, packer.dir_without_theme)
    img_path = project_assets_path.join('images', *sub_dirs)
    FileUtils.mkdir_p(css_path)
    FileUtils.mkdir_p(img_path)
    write_to_file(css_path.join('mixin.scss'), output1)
    write_to_file(css_path.join('ocean.scss'), "#{css_pre_lines.join("\n")}\n\n#{output2}")
    output_paths_mapping.each do |_, path|
      FileUtils.cp("#{path}-fs8.png", img_path.join("#{path.sub('packed', packer.base_dir_name)}.png"))
      exec_cmd('pngquant', "#{path}.png", '--force')
    end
  end

  def exec_cmd(*args)
    begin
      puts args.join(' ')
      puts system(*args)
    rescue => e
      puts e
    end
  end

  def write_to_file(path, content)
    puts "output: #{path} #{File.write(path, content)} bytes"
  end
end

require 'texture_packer/cli/options'
