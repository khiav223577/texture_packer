#!/usr/bin/env ruby
require 'yaml'
require 'pathname'
require 'fileutils'
# ----------------------------------------------------------------
# ● 載入 yaml
# ----------------------------------------------------------------
def load_yaml(path)
  begin
    return YAML.load_file(Pathname.new(__dir__).join(path)) || {}
  rescue Errno::ENOENT
    return {}
  end
end

SETTING = load_yaml('setting.yml')

def exec_cmd(cmd)
  puts cmd
  puts `#{cmd}`
end

def write_to_file(path, content)
  puts "output: #{path} #{File.write(path, content)} bytes"
end

exec_cmd('TexturePacker packer.tps')

def get_mixin(func, css)
  return "@mixin #{func}{ #{css} }\n"
end

# ----------------------------------------------------------------
# ● 由路徑計算 class 名字
# ----------------------------------------------------------------
dir_name = File.expand_path(Dir.pwd).gsub(/.*\/Texture-Packer\/.*?\/(.*)/, '\1')
base_dir_name = File.basename(dir_name)
theme = base_dir_name[/[^_]+$/]
dir_without_theme = base_dir_name[0...-(theme.size + 1)]

content = File.read('packed.css')

Dir['images/**/'].map{|s| s[/images\/(.*)\//, 1] }.compact.map{|s| "#{s.gsub('/', '-')}-" }.each do |path| #"images/aaa/bbb/ccc.png" => "aaa-bbb-"
  content.gsub!(path, path.gsub('-', '_')) #aaa-bbb => aaa_bbb
end

data = {}
content.gsub!(/-disabled \{/, ':disabled {') #-disabled => :disabled
content.gsub!(/-([\w]+)([^\w][\w]+|) \{/, '[\1]\2 {')
output0 = content
output0.sub!(/(\/\*(.|\n)*?\*\/)/, '') #去掉註解
output0 = $1 + "\n"
# puts content
def extract_rule!(content)
  content.sub!(/^\.([a-zA-Z0-9_-]+)((?:\:\w+|\[\w+\])*) \{(.*?)\}/, '') #抓 rule
  return [$1, $2, $3] #$1 = selector, $2 = prefix, $3 = css
end
def split_prefixs(selector)
  selector.sub!(/^\.([a-zA-Z0-9_-]+)(:\w+|\[\w+\])?/, '') #抓 rule
end
loop do
  selector, prefix, css = extract_rule!(content)
  break if selector == nil
  next if selector == "sprite"
  prefixs = prefix.scan(/\[\w+\]|\:\w+/) #[m]:disabled => ['[m]', ':disabled']
  prefixs.map! do |prefix| 
    case prefix
    when '[active]' ; ':active' # 因為 TexturePacker 會把 xxx-active-hover 轉成 xxx-active:hover 而不是 xxx:active:hover
    when '[hover]' ; ':hover'
    else ; prefix
    end
  end
  # p [selector, prefix, css]
  (data[selector] ||= {})[prefixs] = "#{css};"
end
# data = {selector => {nil => 'xxx', ':disabeld' => 'xxx', '[m]' => 'xxx'}}
output1 = "" #mixin的output
output1 += get_mixin("#{base_dir_name}_sprite", "background-image: image-url('#{dir_name}.png')")
output2 = "" #scss的output
output2 += "body[theme='#{theme}']{\n"
output2 += "  .#{dir_without_theme}_sprite{\n"
output2 += "    @include #{base_dir_name}_sprite();\n"
class CssRule
  def initialize
    @hash = {}
  end
  def add(prefixs, css)
    if prefixs.size > 0
      (@hash[prefixs.first] ||= CssRule.new).add(prefixs[1..-1], css)
    else
      @css = css
    end
  end
  def generate_css
    inner_css = @hash.map do |prefix, obj|
      case
      when (prefix == nil || prefix == '')
        [obj.generate_css]
      when prefix[0] == ':'
        ["&#{prefix}, &.#{prefix[1..-1]}{ ", obj.generate_css, " }"]
      when prefix == '[m]'
        ["@media(max-width: $mobile_width){ ", obj.generate_css, " }"]
      else
        ["&#{prefix}{ ", obj.generate_css, " }"]
      end
    end
    inner = inner_css.size == 0 ? '' : " #{inner_css.join('')}"
    return "#{@css}#{inner}"
  end
end
for selector, css_data in data
  func = "#{base_dir_name}_#{selector}"
  rules = CssRule.new
  css_data.each{|prefixs, css| #EX: prefixs == [':hover']
    rules.add(prefixs, css)
  }
  output1 << get_mixin(func, rules.generate_css)
  output2 << "    &.#{selector}{ @include #{func}(); }\n"
end
output2 += "  }\n"
output2 += "}\n"
output = output0 + output1 + output2

# ----------------------------------------------------------------
# ● 壓縮圖片
# ----------------------------------------------------------------
exec_cmd('pngquant packed.png --force')
write_to_file('packed.scss', output)

# ----------------------------------------------------------------
# ● 自動輸出到專案
# ----------------------------------------------------------------
if SETTING['project_dir']
  sub_dirs = dir_name.split(File::Separator)[0...-1]
  css_path = Pathname.new(SETTING['project_dir']).join('app', 'assets', 'stylesheets', 'packed_sprites', *sub_dirs, dir_without_theme)
  img_path = Pathname.new(SETTING['project_dir']).join('app', 'assets', 'images', *sub_dirs)
  FileUtils.mkdir_p(css_path)
  FileUtils.mkdir_p(img_path)
  write_to_file(css_path.join('mixin.scss'), output1)
  write_to_file(css_path.join('ocean.scss'), "@import './mixin.scss';\n\n#{output2}")
  FileUtils.cp('packed-fs8.png', img_path.join(base_dir_name + '.png'))
end

