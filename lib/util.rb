require 'zip/zip'
require 'csv'

module Util

  def self.upload_txt arquivo
    self.clear_all
    self.upload(arquivo)    
    arquivo_unzip = self.unzip
    arquivo_unzip.delete_if { |f| !( f.split('/').last =~ /^[A-Za-z0-9]+[^\s]+(\.(?i)(txt))$/ ) }
    arquivo_unzip.first
  end

  private

    def self.upload arquivo
      File.open('upload/upload_tmp/' + "arquivo_zipado.zip", "w") do |f|
        f.write(arquivo[:tempfile].read)
      end
    end

    def self.unzip      
      unziped_files = []

      Zip::ZipFile.open("upload/upload_tmp/arquivo_zipado.zip") { |zip|
        zip.each { |f|
          zip.extract( f, "upload/upload_tmp/unziped/#{f.name.gsub(/[^0-9A-z.\-]/, '_')}" )
          unziped_files << "#{f.name.gsub(/[^0-9A-z.\-]/, '_')}"
        }
      }      

      unziped_files
    end

    def self.salva_arquivo dados, arquivo
      File.open("upload/#{arquivo}.txt", "w") do |f|
        dados.each do |line| 
          f.puts line
        end
      end     

      Zip::ZipOutputStream.open("upload/#{arquivo}.zip") { |zos|
        zos.put_next_entry "#{arquivo}.txt"
        file = File.open("upload/#{arquivo}.txt", "rb")
        zos.puts file.read
      }       
    end


    def self.clear_all
      FileUtils.rm_rf("upload")
      Dir::mkdir("upload") unless File.directory?("upload")
      Dir::mkdir("upload/upload_tmp") unless File.directory?("upload/upload_tmp")
      Dir::mkdir("upload/upload_tmp/unziped") unless File.directory?("upload/upload_tmp/unziped")
    end

end