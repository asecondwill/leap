module TextHelper
  def md(s)
    require 'github/markup'
    if s
      a = GitHub::Markup.render('README.markdown', s)            
      a.gsub!('.</strong>', '.</strong>&nbsp;')
      return a.html_safe 
    end
  end

  def markdown_filter(&block)
    concat(md(capture(&block)))
  end

  def snippet_filter(language, &block)    
    concat "<pre language='#{language}'><code>#{capture(&block)}</code></pre>".html_safe
   end

  def nl2br(str)
    str.gsub(/\r\n|\r|\n/, "<br />")
  end
end