module ApiDocsHelper
    def show_code (code)
         raw code.gsub!(/</, '&lt;').gsub!(/>/, '&gt;')
    end
end
