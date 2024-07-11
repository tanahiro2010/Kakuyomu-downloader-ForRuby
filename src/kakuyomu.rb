# frozen_string_literal: true
require 'net/http'
require 'uri'
require 'nokogiri'

module Kakuyomu
  class App
    def initialize(data)
      puts "Initializing Kakuyomu App..."
      @book_id = nil
      if data[:book_id].nil?
        puts "Book ID not found"
      else
        @book_id = data[:book_id]
        puts "Book ID: #{@book_id}"
      end
    end

    def get_episode(book_id = @book_id)
      if @book_id.nil? || book_id.nil?
        puts "Book id doesn't set."
        false
      else
        base_url = "https://kakuyomu.jp/works/#{book_id}"
      end
    end

    def download(book_id = @book_id, user_agents)
      if @book_id.nil?
        puts "Book id doesn't set."
        false
      else
        base_url = "https://kakuyomu.jp/works/#{book_id}"
        puts "[INFO] base_url : #{base_url}"
        user_agent = user_agents.sample
        puts "[INFO] Use userAgent: #{user_agent}"

        # Get first episode's url
        url = URI.parse(base_url)
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(url)
        request['User-Agent'] = user_agent

        response = http.request(request)
        html = response.body

        first_html = Nokogiri::HTML(html)

        title = first_html.css("#app > div.DefaultTemplate_fixed__DLjCr.DefaultTemplate_isWeb__QRPlB.DefaultTemplate_fixedGlobalFooter___dZog > div > div > main > div.NewBox_box__45ont.NewBox_padding-px-4l__Kx_xT.NewBox_padding-pt-7l__Czm59 > div > div.Gap_size-2l__HWqrr.Gap_direction-y__Ee6Qv > div.Gap_size-3s__fjxCP.Gap_direction-y__Ee6Qv > h1 > span > a")[0].text
        puts "[INFO] title: #{title}"

        puts "[LOG] start getting url..."

        link_tag = first_html.css("#app > div.DefaultTemplate_fixed__DLjCr.DefaultTemplate_isWeb__QRPlB.DefaultTemplate_fixedGlobalFooter___dZog > div > div > main > div.NewBox_box__45ont.NewBox_padding-px-4l__Kx_xT.NewBox_padding-pt-7l__Czm59 > div > div.Gap_size-2l__HWqrr.Gap_direction-y__Ee6Qv > div.Gap_size-m__thYv4.Gap_direction-y__Ee6Qv > div > a").first

        if link_tag.nil?
          download(user_agents)
          return
        end

        first_url = "https://kakuyomu.jp#{link_tag[:href]}"
        puts "[INFO] First url: #{first_url}"

        all_no_html = first_html.css(
          "#app > div.DefaultTemplate_fixed__DLjCr.DefaultTemplate_isWeb__QRPlB.DefaultTemplate_fixedGlobalFooter___dZog > div > div > main > div:nth-child(4) > div.NewBox_box__45ont.NewBox_padding-pb-7l__WeU_U > div.Gap_size-7l__TyUOV.Gap_direction-y__Ee6Qv > div:nth-child(1) > div:nth-child(2) > div > div.NewBox_box__45ont.NewBox_padding-pt-2l__k25C7.NewBox_borderStyle-solid__F7tjp.NewBox_borderColor-defaultGray__NGE9f > div > div > ul:nth-child(2) > li:nth-child(1) > div"
        )[0]

        if all_no_html.nil?
          download(user_agents)
          return
        end

        # Extract text content and clean up
        all_no_text = all_no_html.content.strip

        # Remove non-digit characters and convert to integer
        all_no = all_no_text.gsub(/[^\d]/, '').to_i

        puts "[INFO] Episode count: #{all_no}"

        episode_url = first_url

        text = ""
        n = 1
        while true
          puts "[LOG] Downloading episode #{n}/#{all_no}"

          # URI オブジェクトを生成
          url = URI(episode_url)

          # Net::HTTP オブジェクトを生成
          http = Net::HTTP.new(url.host, url.port)
          http.use_ssl = true  # HTTPS 接続の場合は true を設定

          # HTTP リクエストオブジェクトを生成
          request = Net::HTTP::Get.new(url)
          request['User-Agent'] = user_agent  # ユーザーエージェントを設定

          # HTTP リクエストを送信してレスポンスを取得
          response = http.request(request)
          html = response.body

          # HTML を Nokogiri でパース
          html_doc = Nokogiri::HTML(html)

          # テキストを取得（例として widget-episodeBody の内容を結合）
          episode_text = html_doc.css(".widget-episodeBody.js-episode-body").text.strip
          text += "#{episode_text}\n"

          # 次のエピソードの URL を取得
          next_episode_link = html_doc.css("#contentMain-readNextEpisode").first
          if next_episode_link
            episode_url = URI.join(url, next_episode_link[:href]).to_s
          else
            puts "[ERROR] Next episode link not found!"
            break
          end
          n += 1
        end

        File.open("#{title}.txt", "w") do |f|
          f.puts text
        end
      end
    end
  end
end
