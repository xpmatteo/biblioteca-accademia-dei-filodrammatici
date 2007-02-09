
module Import
  
  class Base
    def initialize(verbose=false)
      @verbose = verbose
    end
    
    def log(message)
      puts message if @verbose
    end

    def clean_title(title)
      case title
      when /^(.*) \/ ([^.]*\.) (\(\()?(.*)$/
        title = $1 + ". " + ucfirst($2) + " " + $4 
      when /^(.*) \/ ([^;]*) (; .*)$/
        title = $1 + ". " + ucfirst($2) + $3
      when /^(.*) \/ ([^;.:]*.)$/
        title = $1 + ". " + ucfirst($2)
      end
      title.gsub(" :", ":").gsub(" ;", ";")
    end

    def ucfirst(s)
      s[0,1].upcase + s[1, s.length-1]
    end
  end
  
end