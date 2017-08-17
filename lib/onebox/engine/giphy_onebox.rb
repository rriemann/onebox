module Onebox
  module Engine
    class GiphyOnebox
      include Engine
      include StandardEmbed

      matches_regexp(/^https?:\/\/(giphy\.com\/gifs|gph\.is)\//)
      always_https
      
      def to_html
        og = get_opengraph
        return video_html(og) if !Onebox::Helpers::blank?(og[:video_secure_url])
        return image_html(og) if !Onebox::Helpers::blank?(og[:image_url])
        nil
      end

      private

        def video_html(og)
          escaped_video = ::Onebox::Helpers.normalize_url_for_output(og[:video_secure_url])
          escaped_gif = ::Onebox::Helpers.normalize_url_for_output(og[:image_url])
          escaped_link = ::Onebox::Helpers.normalize_url_for_output(og[:url])

          <<-HTML
            <a href='#{escaped_link}' target='_blank'>
              <video width='#{og[:video_width]}' height='#{og[:video_height]}' #{Helpers.title_attr(og)} autoplay loop>
                <source src='#{escaped_video}' type='#{og[:video_type]}'>
                <source src='#{escaped_video.gsub('mp4', 'webm')}' type='video/webm'>
                <img src='#{escaped_gif}' width='#{og[:image_width]}' height='#{og[:image_height]}' #{Helpers.title_attr(og)} alt='Giphy'>
              </video>
            </a>
          HTML
        end

        def image_html(og)
          escaped_gif = ::Onebox::Helpers.normalize_url_for_output(og[:image_url])
          escaped_link = ::Onebox::Helpers.normalize_url_for_output(og[:url])

          <<-HTML
            <a href='#{escaped_link}' target='_blank'>
              <img src='#{escaped_gif}' width='#{og[:image_width]}' height='#{og[:image_height]}' #{Helpers.title_attr(og)} alt='Giphy'>
            </a>
          HTML
        end

    end
  end
end
