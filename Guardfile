guard 'jekyll-plus', :serve => true do
  watch /.*/
  ignore /^_site/
end

guard 'livereload' do
  watch(%r{.+\.(js|html|css?)$})
  watch(%r{(.+)\.s[ac]ss}) { |m| "#{m[1]}.css" }
  watch(%r{(.+)\.rst}) { |m| "#{m[1]}.html" }
  watch(%r{(.+)\.md}) { |m| "#{m[1]}.html" }
  ignore /^_site/
end
