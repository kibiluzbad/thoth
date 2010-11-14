module Thoth
  
  # Helpers para recuperar informações do filme do http://imdb.com
  # utilizando Nokogiri.
  
  module MovieInfo
    
    # Recupera o nome e o ano de lançamento do filme.
    
    def get_title_and_year(doc)
      title = ""
      year = ""
      doc.xpath('//h1').each do|v|
        match = /(.[^\(]+)(\(\d+\))/.match(v.content)
        title = match[1].strip unless match.nil?
        year = match[2].gsub(/[\(\)]/,'') unless match.nil?
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
		    d.url = link.to_s.match(/href\=\"([^\"]+)/)[1]
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
            c.url = url
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
      	writers.push(Thoth::Writer.new do |w|
		  	w.name = link.to_s.match(/\>([^<]+)/)[1]
		    w.url = link.to_s.match(/href\=\"([^\"]+)/)[1]
		    w.imdbid = link.to_s.match(/\/(nm[\d]+)\//)[1]
        end)
      end unless links.nil?
      
      writers
    end
    
    # Recupera as recomendações para esse filme.
    
    def get_recomendations(doc)
      recomendations = []
      
      doc.xpath('//div[@id="recommend"]//div//a').each do|v|
        recomendations.push(v.content.strip) unless v.content.strip.empty?
      end
      
      recomendations
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
      tag.nil? ? 0 : tag.content.strip.to_s.match(/\#(\d+)/)[1].to_i
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
    
  end
end
