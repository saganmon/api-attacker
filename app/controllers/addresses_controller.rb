class AddressesController < ApplicationController

  def index
    # hash形式でパラメタ文字列を指定し、URL形式にエンコード
    params = URI.encode_www_form({zipcode: get_params})
    # URIを解析し、hostやportをバラバラに取得できるようにする
    uri = URI.parse("http://zipcloud.ibsnet.co.jp/api/search?#{params}")
    # リクエストパラメタを、インスタンス変数に格納
    @query = uri.query

    # [GETリクエスト]
    # Net::HTTP.startで新しくHTTPセッションを開始し、結果をresponseへ格納
    # 既にセッションが開始している場合はIOErrorが発生
    response = Net::HTTP.start(uri.host, uri.port) do |http|
      # 接続時に待つ最大秒数を設定
      # タイムアウト時はTimeoutError例外が発生
      http.open_timeout = 5
      # 読み込み一回でブロックして良い最大秒数を設定
      # デフォルトは60秒
      # タイムアウト時はTimeoutError例外が発生
      http.read_timeout = 10
      # ここでWebAPIを叩いている
      # Net::HTTPResponseのインスタンスが返ってくる
      http.get(uri.request_uri)
    end
    # 例外処理の開始
    begin
      # responseの値に応じて処理を分ける
      case response
      # 成功した場合
      when Net::HTTPSuccess
        # [JSONパース処理]
        # responseのbody要素をJSON形式で解釈し、hashに変換
        # JSON::ParserErrorが発生する可能性がある
        @result = JSON.parse(response.body)
        # 表示用の変数に結果を格納
        @zipcode = @result["results"][0]["zipcode"]
        @address1 = @result["results"][0]["address1"]
        @address2 = @result["results"][0]["address2"]
        @address3 = @result["results"][0]["address3"]
      # 別のURLに飛ばされた場合
      when Net::HTTPRedirection
        @message = "Redirection: code=#{response.code} message=#{response.message}"
      # その他エラー
      else
        @message = "HTTP ERROR: code=#{response.code} message=#{response.message}"
      end
    # エラー時処理
    rescue IOError => e
      @message = "e.message"
    rescue TimeoutError => e
      @message = "e.message"
    rescue JSON::ParserError => e
      @message = "e.message"
    rescue => e
      @message = "e.message"
    end
  end


  private

  def get_params
    params.require(:postal_code)[:number]
  end

end
