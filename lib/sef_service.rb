require 'zip/zip'
require 'csv'
require 'lib/util'

module SefService

  def self.corrigir params
    arquivo = Util.upload_txt(params[:sef_arquivo])
    corrigido = self.corrige arquivo, params
    Util.salva_arquivo corrigido, "sef_corrigido"
  end

  private

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
end