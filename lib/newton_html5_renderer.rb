class NewtonHtml5Renderer < Redcarpet::Render::XHTML
  def block_code(code, language)
    # Find a code block caption if present. Code block captions are a new line starting with !--.
    caption = code.match(/^!--(.*)$/)[1] rescue nil
    code.gsub!(/^!--.*$/, '')

		markup = "<figure class=\"code\">\n"
    markup << "\t<pre><code class=\"#{language}\">#{code.strip}</code></pre>\n"

    if caption
			markup << "\t<figcaption>#{caption.strip}</figcaption>\n"
    end
    
		markup << "</figure>"
    
    return markup
  end
  
  def block_quote(quote)
    # Find a quote attribution if present and remove it from quote.
    attrib = quote.match(/^<p>--(.*)<\/p>$/)[1] rescue nil
    quote.gsub!(/^<p>--.*$/, '')
    
    markup = "<figure class=\"quote\">\n"
    markup << "\t<blockquote>\n"
    markup << "\t\t#{quote.strip}\n"
    markup << "\t</blockquote>\n"

    if attrib
      markup << "\n\t<figcaption>#{attrib.strip}</figcaption>\n"
    end

    markup << "</figure>\n"
    
    return markup
  end
  

  def image(link, title, alt_text)
    markup = "<figure class=\"image\">\n"
    markup << "\t<img src=\"#{link}\" alt=\"#{alt_text}\" />\n"
    
    if title.present?
      markup << "\t<figcaption>#{title.strip}</figcaption>\n"
    end
    
    markup << "</figure>\n"

    return markup
  end

end
