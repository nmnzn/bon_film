require "net/http"
require "json"

class Movie < ApplicationRecord
  has_many :links

  def wikipedia_extract(locale: "fr")
    Rails.cache.fetch("wiki_extract:#{locale}:#{id}", expires_in: 7.days) do
      base = (locale == "fr") ? "https://fr.wikipedia.org" : "https://en.wikipedia.org"

      params = {
        action: "query",
        format: "json",
        prop: "extracts",
        explaintext: 1,
        exintro: 1,
        redirects: 1,
        titles: title.to_s
      }

      uri = URI("#{base}/w/api.php")
      uri.query = URI.encode_www_form(params)

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.read_timeout = 4
      http.open_timeout = 4

      res = http.get(uri.request_uri)
      return nil unless res.is_a?(Net::HTTPSuccess)

      data = JSON.parse(res.body)
      page = data.dig("query", "pages")&.values&.first
      extract = page&.dig("extract").to_s.strip

      extract.length >= 200 ? extract : nil
    rescue
      nil
    end
  end
end
