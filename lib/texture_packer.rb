# frozen_string_literal: true

require 'texture_packer/version'

class TexturePacker
  attr_reader :dir_name
  attr_reader :base_dir_name
  attr_reader :dir_without_theme
  attr_reader :output_paths_mapping

  SPLIT_BY_MOBILE          = 'mobile'
  SPLIT_BY_I18N            = 'i18n'
  SPLIT_BY_I18N_AND_MOBILE = 'i18n_and_mobile'

  def initialize(dir_name, output_paths_mapping, content, split_type = nil)
    @output_paths_mapping = output_paths_mapping
    @content = content.dup
    @split_type = split_type

    @dir_name = dir_name
    @base_dir_name = File.basename(@dir_name)
    @theme = @base_dir_name[/[^_]+$/]
    @dir_without_theme = @base_dir_name[0...-(@theme.size + 1)]
  end

  def parse!
    Dir['images/**/'].map{|s| s[%r{images/(.*)/}, 1] }.compact.map{|s| "#{s.tr('/', '-')}-" }.each do |path| # "images/aaa/bbb/ccc.png" => "aaa-bbb-"
      @content.gsub!(path, path.tr('-', '_')) # aaa-bbb => aaa_bbb
    end

    data = {}
    @content.gsub!(/-disabled \{/, ':disabled {') #-disabled => :disabled
    loop{ break if @content.gsub!(/-([\w]+)((?:[^\w][\w]+)*) \{/, '[\1]\2 {') == nil }
    output0 = @content
    output0.sub!(%r{(/\*(.|\n)*?\*/)}, '') # 去掉註解
    output0 = $1 + "\n"

    loop do
      selector, string_prefix, css = extract_rule!
      break if selector == nil
      next if selector == 'sprite'
      prefixs = string_prefix.scan(/\[\w+\]|\:\w+/) # [m]:disabled => ['[m]', ':disabled']
      prefixs.map! do |prefix|
        case prefix
        when '[active]' then ':active' # 因為 TexturePacker 會把 xxx-active-hover 轉成 xxx-active:hover 而不是 xxx:active:hover
        when '[hover]'  then ':hover'
        else                 prefix
        end
      end
      # p [selector, prefix, css]
      (data[selector] ||= {})[prefixs] = "#{css};"
    end
    # data = {selector => {nil => 'xxx', ':disabeld' => 'xxx', '[m]' => 'xxx'}}
    output1 = '' # mixin的output
    @output_paths_mapping.map do |kind, _name|
      if kind == nil
        output1 += get_mixin("#{base_dir_name}_sprite", "background-image: image-url('#{@dir_name}.png');")
      else
        output1 += get_mixin("#{base_dir_name}_sprite_#{kind}", "background-image: image-url('#{@dir_name}_#{kind}.png');")
      end
    end
    output2 = '' # scss的output
    output2 += "body[theme='#{@theme}']{\n"
    output2 += "  .#{@dir_without_theme}_sprite{\n"
    case @split_type
    when SPLIT_BY_I18N_AND_MOBILE
      output2 += "    @include desktop{\n"
      output2 += "      &:lang(zh-TW){ @include #{base_dir_name}_sprite_tw; }\n"
      output2 += "      &:lang(zh-CN){ @include #{base_dir_name}_sprite_cn; }\n"
      output2 += "      &:lang(en){ @include #{base_dir_name}_sprite_en; }\n"
      output2 += "    }\n"

      output2 += "    @include mobile{\n"
      output2 += "      &:lang(zh-TW){ @include #{base_dir_name}_sprite_tw_m; }\n"
      output2 += "      &:lang(zh-CN){ @include #{base_dir_name}_sprite_cn_m; }\n"
      output2 += "      &:lang(en){ @include #{base_dir_name}_sprite_en_m; }\n"
      output2 += "    }\n"
    when SPLIT_BY_MOBILE
      output2 += "    @include desktop{ @include #{base_dir_name}_sprite; }\n"
      output2 += "    @include mobile{ @include #{base_dir_name}_sprite_m; }\n"
    when SPLIT_BY_I18N
      output2 += "    &:lang(zh-TW){ @include #{base_dir_name}_sprite_tw; }\n"
      output2 += "    &:lang(zh-CN){ @include #{base_dir_name}_sprite_cn; }\n"
      output2 += "    &:lang(en){ @include #{base_dir_name}_sprite_en; }\n"
    else
      if @output_paths_mapping.size > 1
        output2 += @output_paths_mapping.map do |kind, _name|
          next "    @include #{base_dir_name}_sprite;\n" if kind == nil
          next "    &[kind=\"#{kind}\"] { @include #{base_dir_name}_sprite_#{kind}; }\n"
        end.join
      else
        output2 += "    @include #{base_dir_name}_sprite;\n"
      end
    end
    # output2 += "    &.split_mobile{ @include mobile{ @include #{base_dir_name}_sprite_m; }}\n" if @split_type == SPLIT_BY_MOBILE
    data.each do |selector, css_data|
      func = "#{base_dir_name}_#{selector}"
      rules = CssRule.new
      css_data.each do |prefixs, css| # EX: prefixs == [':hover']
        rules.add(prefixs, css)
      end
      output1 << get_mixin(func, rules.generate_css)
      output2 << "    &.#{parse_language_selector!(selector)} { @include #{func}; }\n"
    end
    output2 += "  }\n"
    output2 += "}\n"
    return [output0, output1, output2]
  end

  def extract_rule!
    @content.sub!(/^\.([a-zA-Z0-9_-]+)((?:\:\w+|\[\w+\])*) \{(.*?)\}/, '') # 抓 rule
    return [$1, $2, $3] # $1 = selector, $2 = prefix, $3 = css
  end

  def get_mixin(func, css)
    return "@mixin #{func}{ #{css} }\n"
  end

  def parse_language_selector!(selector) # 向下相容
    language_parsed_array = selector.scan(/_(?:tw|cn|en)\z/)
    return selector if language_parsed_array.count.zero? # 如果沒有語言分類就回傳原本的 selector

    case language_parsed_array[0]
    when '_tw'
      return selector.gsub('_tw', ':lang(zh-TW)')
    when '_cn'
      return selector.gsub('_cn', ':lang(zh-CN)')
    when '_en'
      return selector.gsub('_en', ':lang(en)')
    end
  end

  def need_global_mixins?
    return true if @split_type == SPLIT_BY_MOBILE
    return false
  end

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
        case prefix
        when nil, ''
          [obj.generate_css]
        when /\A:/
          ["&#{prefix}, &.#{prefix[1..-1]}{ ", obj.generate_css, ' }']
        when '[m]'
          ['@include mobile{ ', obj.generate_css, ' }']
        when '[tw]'
          ['&:lang(zh-TW){ ', obj.generate_css, ' }']
        when '[cn]'
          ['&:lang(zh-CN){ ', obj.generate_css, ' }']
        when '[en]'
          ['&:lang(en){ ', obj.generate_css, ' }']
        else
          ["&#{prefix}{ ", obj.generate_css, ' }']
        end
      end
      inner = inner_css.size == 0 ? '' : " #{inner_css.join('')}"
      return "#{@css}#{inner}"
    end
  end
end
