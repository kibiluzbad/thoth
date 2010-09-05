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
            doc.xpath('//div[@class="starbar-meta"]//b').each do|v|                
                match = /[\d\.][^\/]+/.match(v.content)
                rating = match[0].to_f unless match.nil?
            end
            rating
        end
        
        # Recupera o mote do filme.
        
        def get_tagline(doc)
            father = nil
            tagline = ''
            doc.xpath('//h5').each do|v|                
                father = v unless v.content != 'Tagline:'
            end

            if(!father.nil?)
                father = father.next.next
                tagline = father.children[0].content.strip
            end
            tagline
        end
        
        # Recupera a trama do filme.
        
        def get_plot(doc)
            father = nil
            tagline = ''
            doc.xpath('//h5').each do|v|                
                father = v unless v.content != 'Plot:'
            end

            if(!father.nil?)
                father = father.next.next
                tagline = father.children[0].content.strip
            end
            tagline
        end
        
        # Recupera os generos do filme.
        
        def get_genres(doc)
            genres = []
            doc.xpath('//div[@class="info"]//div[@class="info-content"]//a').each do|v|
                if(/\/Sections\/Genres\/(\w+)\//.match(v.attr('href')))
                    genres.push(v.content)
                end
            end

            genres
        end
        
        # Recupera os diretores do filme.
        
        def get_directors(doc)
            director = []
            doc.xpath('//div[@id="director-info"]//div[@class="info-content"]//a').each do|v|
                director.push(Thoth::Director.new({:name => v.content,:url => v.attr('href')}))
            end
            director
        end
        
        # Recupera o elenco do filme.
        
        def get_cast(doc)
            cast = []
            doc.xpath('//table[@class="cast"]//tr').each do|v|
                cast.push(Thoth::Character.new do |c|
                    c.actor = v.children[1].content
                    c.name = v.children[3].content
                end)
            end

            cast
        end
        
        # Recupera o tempo de duração do filme.
        
        def get_runtime(doc)
            father = nil
            runtime = ''
            doc.xpath('//h5').each do|v|                
                father = v unless v.content != 'Runtime:'
            end

            if(!father.nil?)
                father = father.next
                runtime = father.content.strip
            end
            runtime
        end
        
        # Recupera os escriotres do filme.
        
        def get_writers(doc)
            father = nil
            writers = []
            doc.xpath('//h5').each do|v|                
                father = v unless v.content != 'Writers (WGA):'
            end

            if(!father.nil?)
                father = father.next.next
                father.children.each do |c|
                   writers.push(c.children[0].content) unless c.children.empty?
                end
            end
            writers
        end
        
        # Recupera as recomendações para esse filme.
        
        def get_recomendations(doc)
            recomendations = []
            
            doc.xpath('//table[@class="recs"]//tr//td//a').each do|v|                
                recomendations.push(v.content.strip) unless v.content.strip.empty?
            end

            recomendations
        end
    end
end
