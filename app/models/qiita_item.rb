require 'json'

class QiitaItem
  def self.get
    url = 'https://qiita.com'
    connection = Faraday.new(url: url)
    response = connection.get do |req|
      req.url '/api/v2/items', page: 1, per_page: 100, query: 'tag:Rails updated:>2019-02 stocks:>3'
    end

    # QiitaのAPIから返ってきたJSONをパース
    json = JSON.parse(response.body)
    # 記事を一旦いいね数の降順でソートして記事タイトル／URL／いいね数のハッシュ形式にしたものを新しい配列をmapメソッドで生成
    json.sort_by { |i| i['likes_count']}.reverse.map do |item|
      { title: item['title'], url: item['url'], likes_count: item['likes_count'] }
    end.take(20)
  end
end