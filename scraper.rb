require 'open-uri'
require 'nokogiri'

def fetch_top_movie_urls
  top_movies_url = 'https://www.imdb.com/chart/top'
  html_file = open(top_movies_url).read
  html_doc = Nokogiri::HTML(html_file)

  result = []
  html_doc.search('.titleColumn a').first(5).each do |link|
    result << "https://www.imdb.com" + link.attributes['href'].value.gsub(/\?.+/,'')
  end
  return result
end

def scrape_movie(url)
  html_file = open(url, "Accept-Language" => "en").read
  html_doc = Nokogiri::HTML(html_file)

  name_year = html_doc.search('h1').text.strip.match(/(?<title>.+).\((?<year>\d{4})\)$/)

  director = html_doc.search('.credit_summary_item:nth-of-type(1)').text.gsub(/Director:/,'').strip

  cast = html_doc.search('.credit_summary_item:nth-of-type(3)').search('a').first(3).map(&:text)
  {
    title: name_year[:title],
    year: name_year[:year].to_i,
    storyline: html_doc.search('.summary_text').text.strip,
    director: director,
    cast: cast

  }
end

