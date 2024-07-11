# frozen_string_literal: true
require 'net/http'
require 'uri'

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

    def get_episode book_id=@book_id
      if @book_id.nil? || book_id.nil?
        puts "Book id doesn't set."
        false
      else
        base_url = "https://kakuyomu.jp/works/#{book_id}"
      end
    end

    def download book_id=@book_id, userAgents
      if @book_id.nil?
        puts "Book id doesn't set."
        false
      else
        # Download
        base_url = "https://kakuyomu.jp/works/#{book_id}"
        puts "[INFO] base_url : #{base_url}"
        userAgent = userAgents.sample
        puts "[INFO] Use userAgent: #{userAgent}"

        # Get first episode's url
        url = URI.parse base_url
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true

        request = Net::HTTP::Get.new(url)

        request['User-Agent'] = userAgent

        response = http.request(request)
        html = response.body
        File.open("./index.html", "w") do |f|
          f.puts html
        end
        first_html = Nokogiri.HTML5(html)

        puts "[LOG] start getting url..."

        link_tag = first_html.css("#app > div.DefaultTemplate_fixed__DLjCr.DefaultTemplate_isWeb__QRPlB.DefaultTemplate_fixedGlobalFooter___dZog > div > div > main > div.NewBox_box__45ont.NewBox_padding-px-4l__Kx_xT.NewBox_padding-pt-7l__Czm59 > div > div.Gap_size-2l__HWqrr.Gap_direction-y__Ee6Qv > div.Gap_size-m__thYv4.Gap_direction-y__Ee6Qv > div > a")[0]

        if link_tag.nil?
          download userAgents=userAgents
          return
        end

        first_url = "https://kakuyomu.jp#{link_tag[:href]}"
        puts "[INFO] First url: #{first_url}"

        all_no_html = first_html.css(
          "#app > div.DefaultTemplate_fixed__DLjCr.DefaultTemplate_isWeb__QRPlB.DefaultTemplate_fixedGlobalFooter___dZog > div > div > main > div:nth-child(4) > div.NewBox_box__45ont.NewBox_padding-pb-7l__WeU_U > div.Gap_size-7l__TyUOV.Gap_direction-y__Ee6Qv > div:nth-child(1) > div:nth-child(2) > div > div.NewBox_box__45ont.NewBox_padding-pt-2l__k25C7.NewBox_borderStyle-solid__F7tjp.NewBox_borderColor-defaultGray__NGE9f > div > div > ul:nth-child(2) > li:nth-child(1) > div"
        )[0]

        if all_no_html.nil?
          download userAgents=userAgents
          return
        end

        all_no_array = all_no_html.content.chars

        puts "[INFO] All_no_array: #{all_no_array.to_s}"

        all_no_array.each do
          all_no_array.delete_at(0)
          if all_no_array[0] == " "
            all_no_array.delete_at(0)
            all_no_array.delete_at(0)
            break
          end
        end

        puts "[INFO] All_no_array: #{all_no_array.to_s}"

        len = all_no_array.length
        last_no = len - 1
        all_no_array.delete_at(last_no)

        all_no_str = ""
        all_no_array.each do |item|
          all_no_str += item
        end
        all_no = all_no_str.to_i

        puts "[INFO] General_all_no: #{all_no}"

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
          request['User-Agent'] = userAgent  # ユーザーエージェントを設定

          # HTTP リクエストを送信してレスポンスを取得
          response = http.request(request)
          html = response.body

          # HTML を Nokogiri でパース
          html_doc = Nokogiri::HTML5(html)

          # テキストを取得（例として widget-episodeBody の内容を結合）
          text += html_doc.css(".widget-episodeBody.js-episode-body").text.strip

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

        File.open("text", "w") do |f|
          f.puts text
        end
      end
    end
  end
end
