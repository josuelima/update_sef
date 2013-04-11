require 'zip/zip'
require 'csv'

module SefService

  def self.corrigir params
    self.clear_all

    self.upload(params[:sef_arquivo])    
    arquivo_sef = self.unzip
    arquivo_sef.delete_if { |f| !( f.split('/').last =~ /^[A-Za-z0-9]+[^\s]+(\.(?i)(txt))$/ ) }
    
    corrigido = self.corrige(arquivo_sef.first, params)
    self.salva_arquivo(corrigido)
  end

  private

    def self.upload file
      File.open('upload/upload_tmp/' + "sef.zip", "w") do |f|
        f.write(file[:tempfile].read)
      end
    end

    def self.unzip      
      unziped_files = []

      Zip::ZipFile.open("upload/upload_tmp/sef.zip") { |zip|
        zip.each { |f|
          zip.extract( f, "upload/upload_tmp/unziped/#{f.name.gsub(/[^0-9A-z.\-]/, '_')}" )
          unziped_files << "#{f.name.gsub(/[^0-9A-z.\-]/, '_')}"
        }
      }      

      unziped_files
    end

    def self.corrige arquivo, params  
      arquivo_corrigido = []    
      CSV.foreach("upload/upload_tmp/unziped/#{arquivo}", :col_sep => '|', :encoding => "ISO-8859-1") do |row|    
        row_copy = row.clone
        
        if params[:registro].include?(row[1])          
          params[:registro].each_with_index do |registro, index|
            next unless registro == row[1]

            campos_replace = params[:campos][index]
            campos_replace.split(",").each do |c|
              row_copy[c.to_i] = params[:substituir][index]
            end

          end
        end
        arquivo_corrigido << row_copy.join("|")
      end

      arquivo_corrigido
    end

    def self.salva_arquivo dados
      File.open("upload/sef_corrigido.txt", "w") do |f|
        dados.each do |line| 
          f.puts line
        end
      end     

      Zip::ZipOutputStream.open('upload/sef_corrigido.zip') { |zos|
        zos.put_next_entry 'sef_corrigido.txt'
        file = File.open("upload/sef_corrigido.txt", "rb")
        zos.puts file.read
      }       
    end


    def self.clear_all
      FileUtils.rm_rf("upload/upload_tmp")
      File.delete("upload/sef_corrigido.txt") if File.file?("upload/sef_corrigido.txt")
      File.delete("upload/sef_corrigido.zip") if File.file?("upload/sef_corrigido.zip")
      Dir::mkdir("upload/upload_tmp") unless File.directory?("upload/upload_tmp")
      Dir::mkdir("upload/upload_tmp/unziped") unless File.directory?("upload/upload_tmp/unziped")
    end

end