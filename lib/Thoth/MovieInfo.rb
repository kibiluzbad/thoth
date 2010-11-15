module Thoth

  # Helpers para recuperar informações do filme do http://imdb.com
  # utilizando Nokogiri.

  module MovieInfo

    # Recupera o nome e o ano de lançamento do filme.

    def get_title_and_year(doc)
      title = ""
      year = ""
      h1_tag = doc.xpath('//h1').first
      if h1_tag
          
        title = h1_tag.children[0].content.strip
        match = h1_tag.content.to_s.match(/\((\d{4})\)/)        
        year = match[1] unless match.nil?

      end
      
      return title, year      
    end

    # Recupera a nota do filme atribuida pelos usuário do imdb.

    def get_rating(doc)
      rating = 0
        doc.xpath('//span[@class="rating-rating"]').each do|v|
        match = /[\d\.][^\/]+/.match(v.content)
        rating = match[0].to_f unless match.nil?
      end
      rating
    end

  # Recupera o mote do filme.

  def get_tagline(doc)
    father = nil
    tagline = ''
    doc.xpath('//h4[@class="inline"]').each do|v|
      father = v unless v.content != 'Taglines:'
    end

    if(!father.nil?)
      father = father.parent
      tagline = father.children[2].content.strip
    end
    tagline
  end

  # Recupera a trama do filme.

  def get_plot(doc)
    plot = ''
    doc.xpath('//td[@id="overview-top"]//p').each do|v|
      plot = v.content.strip
    end
    plot
  end

  # Recupera os generos do filme.

  def get_genres(doc)
    genres = []
    tag_genres = nil
    doc.xpath('//h4[@class="inline"]').each do|v|
      tag_genres = v if v.content == 'Genres:'
    end
    links = tag_genres.parent.children.select{|a| a.to_s.match(/^\<a/)} unless tag_genres.nil?
    links.each{|link| genres.push(link.to_s.match(/\>([^<]+)/)[1])} unless links.nil?
    genres
  end

  # Recupera os diretores do filme.

  def get_directors(doc)
    directors = []
    tag_diretors = nil
    doc.xpath('//h4[@class="inline"]').each do|v|
      tag_diretors = v if v.content.strip == 'Director:' || v.content.strip == 'Directors:'
    end
    links = tag_diretors.parent.children.select{|a| a.to_s.match(/^\<a/)} unless tag_diretors.nil?

    links.each do |link|
      directors.push(Thoth::Director.new do |d|
        d.name = link.to_s.match(/\>([^<]+)/)[1]
        d.url = "http://www.imdb.com#{link.to_s.match(/href\=\"([^\"]+)/)[1]}"
        d.imdbid = link.to_s.match(/\/(nm[\d]+)\//)[1]
      end)
    end unless links.nil?

    directors
  end

  # Recupera o elenco do filme.

  def get_cast(doc)
    cast = []
    doc.xpath('//table[@class="cast_list"]//tr').each do|v|
      actor = v.xpath('td[@class="name"]//a').first
      name = v.xpath('td[@class="character"]//a').first

      if(!actor.nil? && !name.nil?)
        url = v.xpath('td[@class="name"]//a').first.attributes["href"].value
        picture_path = v.xpath('td[@class="primary_photo"]//a//img').first.attributes["src"].value
        imdbid = url.match(/\/(nm[\d]+)\//)[1]

        cast.push(Thoth::Character.new do |c|
          c.actor = actor.content.strip
          c.name = name.content.strip
          c.url = "http://www.imdb.com#{url}"
          c.picture_path = picture_path
          c.imdbid = imdbid
        end)
      end
    end

    cast
  end

  # Recupera o tempo de duração do filme.

  def get_runtime(doc)
    father = nil
    tagline = ''
    doc.xpath('//h4[@class="inline"]').each do|v|
      father = v unless v.content != 'Runtime:'
    end

    if(!father.nil?)
      father = father.parent
      tagline = father.children[2].content.strip
    end
    tagline
  end

  # Recupera os escriotres do filme.

  def get_writers(doc)
    writers = []
    tag_writers = nil
    doc.xpath('//h4[@class="inline"]').each do|v|
      tag_writers = v if v.content.strip == 'Writer:' || v.content.strip == 'Writers:'
    end
    links = tag_writers.parent.children.select{|a| a.to_s.match(/^\<a/)} unless tag_writers.nil?

    links.each do |link|
      imdbid_match = link.to_s.match(/\/(nm[\d]+)\//)
      if imdbid_match
        writers.push(Thoth::Writer.new do |w|
          w.name = link.to_s.match(/\>([^<]+)/)[1]
          w.url = "http://www.imdb.com#{link.to_s.match(/href\=\"([^\"]+)/)[1]}"
          w.imdbid = imdbid_match[1]
        end)
      end
    end unless links.nil?

    writers
  end

  # Recupera as recomendações para esse filme.

  def get_recomendations(doc)
    recommendations = []

    doc.xpath('//div[@id="recommend"]//div//a').each do|v|
      unless v.content.empty?
        recommendations.push(Thoth::Recommendation.new do |rec|
          rec.title = v.content.strip
          rec.url = "http://www.imdb.com#{v.attributes["href"].value}"
          rec.picture_path = v.parent.xpath('a//img').first.attributes["src"].value
        end)
      end
    end

    recommendations
  end

  # Recupera o caminho da imagem no imdb.

  def get_picture_path(doc)
    image = nil
    doc.xpath('//td[@id="img_primary"]//img').each do|v|
      image = v
    end
    image.attributes["src"].value unless image.nil?
  end

  # Recupera a quantidade de votos.

  def get_votes(doc)
    votes = 0
    doc.xpath('//a[@href="ratings"]').each do|v|
      votes = v.content.strip.gsub(/[a-zA-Z\s\,]+/,'').to_f
    end
    votes
  end

  # Recupera a posicao do filme no top250.

  def get_top250(doc)

    tag = doc.xpath('//div[@class="article highlighted"]//a').first
    return 0 if tag.nil?
      
    match = tag.content.strip.to_s.match(/\#(\d+)/)
    match[1].to_i if match
  end

  # Recupera a os outros nomes do filme.

  def get_akas(doc)
    akas = []
    tag_akas = nil
    doc.xpath('//h4[@class="inline"]').each do|v|
      tag_akas = v if v.content.strip == 'Also Known As:'
    end
    akas.push(tag_akas.parent.children[2].content.strip) unless tag_akas.nil?
    akas
  end

  # Recupera os nomes do filme em outros idiomas
  
  def get_alternative_titles(doc_release_info)
    titles = []
    tag_akas = nil
    doc_release_info.xpath('//h5//a[@name="akas"]').each do|v|
      tag_akas = v 
    end
    unless tag_akas.nil?
      table = tag_akas.parent.next.next
      table.xpath("tr").each do |tr|
        titles.push(Thoth::AlternativeTitle.new do |atitle|
            atitle.title = tr.children[0].content.strip
            atitle.country = tr.children[2].content.strip
        end) 
      end
    end
    titles
  end
end
end

