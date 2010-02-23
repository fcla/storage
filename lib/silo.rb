require 'fileutils'

module SimpleStorage

  class Atom

    attr_reader :data_path

    def initialize path
      @path = path
      FileUtils.mkdir_p @path

      @data_path = File.join @path, 'data'
      @sha1_path = File.join @path, 'sha1'
      @md5_path = File.join @path, 'md5'

      if block_given?

        # take in the data
        open @data_path, 'w' do |io|
          yield io
        end

        digests = {
          @sha1_path => Digest::SHA1.new,
          @md5_path => Digest::MD5.new
        }

        # update message digests
        open @data_path do |io|
          buffer_size = 1024 * 1024 * 10
          buffer = ""

          while io.read(buffer_size, buffer)
            digests.values.each { |d| d.update buffer }
          end

        end

        digests.each do |file, digest|
          open(file, 'w') { |io| io.write digest.hexdigest }
        end

      end

    end

    def data
      open(@data_path) { |io| io.read }
    end

    def sha1
      open(@sha1_path) { |io| io.read }
    end

    def md5
      open(@md5_path) { |io| io.read }
    end

  end

  class Silo

    def initialize root
      @root = root
    end

    def write! name
      Atom.new(path(name)) { |io| yield io }
    end

    def delete! name
      FileUtils::rm_rf path(name)
    end

    def [] name
      Atom.new path(name)
    end

    def has? name
      File.exist? path(name)
    end

    def entries
      Dir.chdir(@root) { Dir['*'] }
    end

    def nuke!
      pattern = File.join @root, '*'
      FileUtils::rm_rf Dir[pattern]
    end

    private

    def path name
      File.join @root, name
    end

  end

end
