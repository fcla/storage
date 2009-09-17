module SimpleStorage
  
  class Silo
    
    def initialize root
      @root = root
    end
    
    def write! name
      open(path(name), 'w') { |io| yield io } if block_given?
    end
    
    def delete! name
      FileUtils::rm_rf path(name)
    end
    
    def file_for name
      path(name)
    end
    
    def has? name
      File.exist? path(name)
    end
    
    def entries
      Dir.chdir @root do
        Dir['*']
      end
    end
    
    private
    
    def path name
      File.join @root, name
    end
    
  end
  
end