require 'sinatra/base'
require 'haml'
require 'sass'

class SassHandler < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/templates/sass'

  get '/css/*.css' do
    filename = params[:splat].first
    sass filename.to_sym
  end
end

class App < Sinatra::Base
  use SassHandler
  set :views, File.dirname(__FILE__) + '/templates'
  set :public_dir, File.dirname(__FILE__) + '/public'

  def pick_random_line(filename)
    chosen_line = nil
    File.foreach(filename).each_with_index do |line, number|
      chosen_line = line if rand < 1.0/(number+1)
    end
    return chosen_line
  end

  def read_line_number(filename, number)
    return nil if number < 1
    line = File.readlines(filename)[number-1]
    line ? line.chomp : nil
  end

  get '/' do
    full_line = self.pick_random_line "lines.txt"
    line = full_line.split('-')
    @number = line[0]
    redirect '/' + @number
  end

  get '/*' do
    full_line = read_line_number 'lines.txt', (params[:splat].first).to_i
    line = full_line.split('-')
    @line = line[1]
    @number = line[0]
    haml :index
  end
end

App.run! if __FILE__ == $0
