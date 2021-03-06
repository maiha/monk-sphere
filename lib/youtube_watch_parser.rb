
require 'open-uri'
require 'nokogiri'              # gem install nokogiri

class YoutubeWatchParser
  class CannotParse < RuntimeError; end

  attr_reader :t
  attr_reader :video_id

  def initialize(html)
    @html     = html
    @t        = extract_header(:t)
    @video_id = extract_header(:video_id)
  end

  def get_video
    "http://youtube.com/get_video.php?t=#{t}&video_id=#{video_id}&fmt=18"
  end

  private
    def doc
      @doc ||= Nokogiri::HTML(@html)
    end

    def extract_header(key)
      regex = /"#{key}":\s*"(.*?)"/
      array = @html.scan(regex).flatten
      case array.size
      when 0
        raise CannotParse, key.to_s
      when 1
        array.first
      else
        # video_id is ambigous. so strictly parse html with Nokogiri
        doc.xpath('//head/script').each do |e|
          value = e.html.scan(regex).flatten.first and
            return value
        end
        raise CannotParse, key.to_s
      end
    end
end
