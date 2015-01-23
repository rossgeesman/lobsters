class StarterDataGenerator
  def initialize(user_email)
    @user_email = user_email
  end

  def generate(feed_url: feed_url)
    user = User.where(email: @user_email).first
    raise "Can't find user email(#{@user_email})" if user.nil?

    feed = Feedjira::Feed.fetch_and_parse(feed_url)
    feed.entries.each do |entry|
      tag_names = []
      entry.title.split(' ').each do |tag_str|
        tag = Tag.find_or_create_by! tag: tag_str.downcase.delete(',')
        tag_names << tag.tag
      end
      Story.create_with_entry(entry: entry, user: user, tag_names: tag_names.uniq)
    end
  end
end

namespace :starter_data do
  desc 'Add test user'
  task :user => :environment do
    User.create!(
      username: "test", 
      email: "test@example.com", 
      password: "test", 
      is_admin: true, 
      is_moderator: true
    )
  end

  desc 'Generates story data from feed'
  task :feed => [:environment] do |t, args|
    generator = StarterDataGenerator.new('test@example.com')
    [
      'http://helloworld.naver.com/rss',
      'http://besuccess.com/feed/',
      'http://zdnetkorea.feedsportal.com/c/34249/f/622757/index.rss',
      'http://feeds.feedburner.com/bloter',
      'http://www.memoriesreloaded.net/feeds/posts/default'
    ].each do |feed|
      generator.generate(feed_url: feed)
    end
    
  end
end
