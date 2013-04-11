require 'zip/zip'
require 'csv'
require 'lib/util'

module EdocService

  def self.filtrar params
    arquivo = Util.upload_txt(params[:edoc_arquivo])
    corrigido = self.corrige arquivo, params
    Util.salva_arquivo corrigido, "edoc_filtrado"
  end

  private

    def self.corrige arquivo, params  
      arquivo_corrigido = []    
      CSV.foreach("upload/upload_tmp/unziped/#{arquivo}", :col_sep => '|', :encoding => "ISO-8859-1") do |row|    
        new_row = []
        
        if params[:registro].include?(row[1])          
          params[:registro].each_with_index do |registro, index|
            next unless registro == row[1]

            new_row << ""
            new_row << row[1]
            campos_replace = params[:campos][index]
            campos_replace.split(",").each do |c|
              new_row << row[c.to_i]              
            end

          end
        end
        arquivo_corrigido << new_row.join("|") unless new_row.empty?
      end
      arquivo_corrigido
    end
end