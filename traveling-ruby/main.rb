require 'net/http'
require 'time'
require 'openssl'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE # Don't do this at home.

SEARCH_URL = 'http://iapi.njuskalo.hr/?ctl=browse_ads&sort=new&categoryId=10920&locationId=2619&locationId_level_0=1153&locationId_level_1=1250&locationId_level_2=2619&price%5Bmin%5D=150&price%5Bmax%5D=400&mainAreaFrom=40&mainAreaTo=&adsWithImages=1&flatTypeId=0&floorCountId=0&roomCountId=0&flatFloorIdFrom=0&flatFloorIdTo=0&gardenAreaFrom=&gardenAreaTo=&balconyAreaFrom=&balconyAreaTo=&teraceAreaFrom=&teraceAreaTo=&yearBuiltFrom=&yearBuiltTo=&yearLastRebuildFrom=&yearLastRebuildTo='.freeze
RECIPIENTS = ['damir.svrtan@gmail.com'].freeze
MAILGUN_API_KEY = ENV.fetch('MAILGUN_API_KEY')

class NewApartments
  LAST_SCRAPPED_AT = Time.now - 500 * 60 # 5 minutes ago.
  attr_reader :url

  def initialize(url)
    @url = url
  end

  def any?
    publish_dates.any? { |time| time > LAST_SCRAPPED_AT }
  end

  private

  def publish_dates
    response_body
      .scan(/datetime\="(.*)" /)
      .map(&:first)
      .map { |time| Time.parse(time) }
  end

  def response_body
    Net::HTTP.get(URI(url))
  end
end

class MailgunEmailer
  DOMAIN = 'sandboxc0539931f2194f9fbed09ad7179d4901.mailgun.org'.freeze

  def self.call(subject, message, recipients)
    Net::HTTP.post_form(
      URI("https://api:key-#{MAILGUN_API_KEY}@api.mailgun.net/v3/#{DOMAIN}/messages"),
      from: "Njuskalo Bot <postmaster@#{DOMAIN}>",
      to: recipients,
      subject: subject,
      html: message
    )
  end
end

if NewApartments.new(SEARCH_URL).any?
  MailgunEmailer.call(
    'New Apartments found!',
    "Check new <a href='#{SEARCH_URL}'>apartments</a>",
    RECIPIENTS
  )
  puts 'New apartments found!'
else
  puts 'No new aparments :('
end
