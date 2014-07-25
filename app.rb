$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'sinatra'
require 'lib/sped_service'

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
end

get '/' do
  haml :index
end

post '/corrigir-sped' do
  SpedService.corrigir(params)
  send_file "upload/sped_corrigido.zip", :filename => "sped_corrigido.zip", :type => 'Application/octet-stream'
end