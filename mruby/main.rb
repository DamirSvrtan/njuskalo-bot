SEARCH_URL = 'http://iapi.njuskalo.hr/?ctl=browse_ads&sort=new&categoryId=10920&locationId=2619&locationId_level_0=1153&locationId_level_1=1250&locationId_level_2=2619&price%5Bmin%5D=150&price%5Bmax%5D=400&mainAreaFrom=40&mainAreaTo=&adsWithImages=1&flatTypeId=0&floorCountId=0&roomCountId=0&flatFloorIdFrom=0&flatFloorIdTo=0&gardenAreaFrom=&gardenAreaTo=&balconyAreaFrom=&balconyAreaTo=&teraceAreaFrom=&teraceAreaTo=&yearBuiltFrom=&yearBuiltTo=&yearLastRebuildFrom=&yearLastRebuildTo='
RECIPIENTS = ['damir.svrtan@gmail.com']
MAILGUN_API_KEY = ENV['MAILGUN_API_KEY']

class NewApartments
  LAST_SCRAPPED_AT = Time.now - 5000 * 60 # 5 minutes ago.
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
      .onig_regexp_scan(OnigRegexp.new('datetime\="(.*)" '))
      .map(&:first)
      .map { |time| Iso8601ToTime.new(time).call }
  end

  def response_body
    aha = SimpleHttp.new("http", "iapi.njuskalo.hr").request("GET", "?ctl=browse_ads&sort=new&categoryId=10920&locationId=2619&locationId_level_0=1153&locationId_level_1=1250&locationId_level_2=2619&price%5Bmin%5D=150&price%5Bmax%5D=400&mainAreaFrom=40&mainAreaTo=&adsWithImages=1&flatTypeId=0&floorCountId=0&roomCountId=0&flatFloorIdFrom=0&flatFloorIdTo=0&gardenAreaFrom=&gardenAreaTo=&balconyAreaFrom=&balconyAreaTo=&teraceAreaFrom=&teraceAreaTo=&yearBuiltFrom=&yearBuiltTo=&yearLastRebuildFrom=&yearLastRebuildTo=", {})
    aha.body
  end
end

class MailgunEmailer
  attr_reader :subject, :message, :recipients

  def initialize(subject, message, recipients)
    @subject = subject
    @message = message
    @recipients = recipients.join(', ')
  end

  def call
    `#{curl_call}`
  end

  def curl_call
    <<-HEREDOC
      curl -s --user 'api:key-#{MAILGUN_API_KEY}' \
          #{uri} \
          -F from='#{from}' \
          -F to='#{recipients}' \
          -F subject='Hello' \
          -F text='Testing some Mailgun awesomeness!'
    HEREDOC
  end

  private

  def uri
    "https://api.mailgun.net/v3/#{domain}/messages"
  end

  def from
    "Njuskalo Bot <postmaster@#{domain}>"
  end

  def domain
    'sandboxc0539931f2194f9fbed09ad7179d4901.mailgun.org'
  end
end

class Iso8601ToTime
  REGEX = OnigRegexp.new('(\d{4})-(\d{2})-(\d{2})T(\d{2})\:(\d{2})\:(\d{2})[+-](\d{2})\:(\d{2})')

  attr_reader :string

  def initialize(string)
    @string = string
  end

  def call
    Time.gm(year, month, day, hour, minute, second)
  end

  private

  def match_data
    string.match(REGEX)
  end

  def year
    match_data[1].to_i
  end

  def month
    match_data[2].to_i
  end

  def day
    match_data[3].to_i
  end

  def hour
    match_data[4].to_i - zone
  end

  def minute
    match_data[5].to_i
  end

  def second
    match_data[6].to_i
  end

  def zone
    match_data[7].to_i
  end
end

if NewApartments.new(SEARCH_URL).any?
  MailgunEmailer.new(
    'New Apartments found!',
    "Check new <a href='#{SEARCH_URL}'>apartments</a>",
    RECIPIENTS
  ).call
  puts 'New apartments found!'
else
  puts 'No new aparments :('
end
