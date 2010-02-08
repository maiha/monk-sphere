
class Main
  helpers do

    # Your helpers go here. You can also create another file in app/helpers with the same format.
    # All helpers defined here will be available across all the application.
    #
    # @example A helper method for date formatting.
    #
    #   def format_date(date, format = "%d/%m/%Y")
    #     date.strftime(format)
    #   end

    # http://www.gittr.com/index.php/archive/using-rackutils-in-sinatra-escape_html-h-in-rails/
    include Rack::Utils
    alias_method :h, :escape_html

    def haml(template, options = {}, locals = {})
      options[:escape_html] = false unless options.include?(:escape_html)
      super(template, options, locals)
    end

    def video_state(v)
      localize = {
        "init"        => "初期",
        "request"     => "処理待ち",
        "downloading" => "DL中",
        "fetched"     => "完了",
        "error"       => "エラー"
      }
      label = localize[v.state] || v.state.to_s

      content_tag :span, label, :class=>v.state
    end

    def video_keywords(v)
      v.keywords.to_a.join(", ")
    end
  end
end
