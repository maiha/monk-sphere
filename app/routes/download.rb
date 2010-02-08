require 'uri'

class Main
  post "/register" do
    begin
      Video.request(params[:url])
      status 200
      return "OK"
    rescue Exception => e
      status 503
      return "#{e.class}: #{e}"
    end
  end
end
