class Main
  get "/youtube" do
    haml :youtube
  end

  get "/youtube/:id" do
    haml :video, {}, :video=>Video[params[:id].to_i]
  end
end
