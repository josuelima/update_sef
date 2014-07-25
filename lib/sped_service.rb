require 'zip/zip'
require 'csv'
require 'lib/util'

module SpedService

  def self.corrigir params
    arquivo = Util.upload_txt(params[:sef_arquivo])
    corrigido = self.corrige arquivo, params
    Util.salva_arquivo corrigido, "sped_corrigido"
  end

  private

    def self.corrige arquivo, params  
      arquivo_corrigido = []
      
      params[:registro].map! { |m| m.upcase }
      params[:linha].map! { |m| m.to_i }

      line = 1

      CSV.foreach("upload/upload_tmp/unziped/#{arquivo}", :col_sep => '|', :encoding => "ISO-8859-1") do |row|    
        row_copy = row.clone

        if params[:registro].include?(row[1].upcase)
          params[:registro].each_with_index do |registro, index|
            next unless registro == row[1].upcase

            if compare(row_copy[params[:campo][index].to_i], params[:regra][index], params[:filtro][index])
              row_copy[params[:campo_sub][index].to_i] = params[:substituir][index]
            end

          end
        end

        if params[:linha].include?(line)
          params[:linha].each_with_index do |linha, index|
            row_copy[params[:campo_rule_2][index].to_i] = params[:substituir_2][index] if linha == line
          end
        end

        arquivo_corrigido << row_copy.join("|")
        line += 1
      end
      arquivo_corrigido
    end

    def self.compare(field, condition, compare_to)
      case condition
        when "="
          return field == compare_to
        when "!="
          return field != compare_to
        when "<"
          return field < compare_to
        when ">"
          return field > compare_to
        end
    end
end