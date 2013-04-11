$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'sinatra'
require 'lib/sef_service'
require 'lib/edoc_service'

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
end

get '/' do
  haml :index
end

## SEF 2

get '/corrigir-sef' do
  haml :corrigir_sef
end

post '/corrigir-sef' do
  SefService.corrigir(params)
  send_file "upload/sef_corrigido.zip", :filename => "sef_corrigido.zip", :type => 'Application/octet-stream'
end

## E-DOC

get '/filtrar-edoc' do
  haml :filtrar_edoc
end

post '/filtrar-edoc' do
  EdocService.filtrar(params)
  send_file "upload/edoc_filtrado.zip", :filename => "edoc_filtrado.zip", :type => 'Application/octet-stream'
end