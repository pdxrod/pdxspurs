# [           {
#	              "id":"sport/2012/jul/26/london-2012-gareth-bale-sepp-blatter",
#	            "sectionId":"sport",
#  	          "sectionName":"Sport",
#	        "webPublicationDate":"2012-07-26T10:05:29Z",
#	      "webTitle":"London 2012: Sepp Blatter criticised for Gareth Bale comments",
#            "webUrl":"http://www.guardian.co.uk/sport/2012/jul/26/london-2012-gareth-bale-sepp-blatter",
#          "apiUrl":"http://content.guardianapis.com/sport/2012/jul/26/london-2012-gareth-bale-sepp-blatter"}, ... ]
	
require 'net/http'
require 'uri'

class Guardian
  
  # Formats date num_days ago: 'Sun Oct 05 10:00 2008' -> '20081005'
  def Guardian.display_date(num_days)
    t = Time.now - (num_days * ONE_DAY)
    d = t.to_s
    l = d.length
    y = d[l-4..l-1]
    d = d[8..9]
    m = t.month.to_s
    m = '0' + m if m.length < 2
    y + m + d
  end
  
  def Guardian.results
        url = "http://content.guardianapis.com/search?q=Tottenham&format=json&api-key=" +
         ApplicationController::GUARDIAN_API_KEY

	uri = URI.parse(url)
	res = Net::HTTP.get_response(uri)

	bod = res.body
	json = JSON.parse( bod )
        results = []
	json['response']['results'].each do |result|

 	     title = result['webTitle']
             url =   result['webUrl']
             str = '    <a href="' + url + '">' + title + '</a>' 
             results << str

	end
        results
  end

end


