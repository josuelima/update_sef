$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rubygems'
require 'sinatra'
require 'lib/sef_service'

configure do
  set :public_folder, Proc.new { File.join(root, "static") }
end

get '/' do
  haml :index
end

post '/corrigir-sef' do
  SefService.corrigir(params)
  send_file "upload/sef_corrigido.zip", :filename => "sef_corrigido.zip", :type => 'Application/octet-stream'
end