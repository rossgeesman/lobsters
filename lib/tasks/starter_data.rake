# encoding: utf-8

class StarterDataGenerator
  def initialize(user_email)
    @user_email = user_email
    @tag_dictionary = ["스타트업", "DBMS", "자바", "Java", "자바스크립트", "루비", "파이썬", "오픈소스", "C", "iOS", "안드로이드", "UX\/UI",
     "하드웨어", "IoT", "web", "기계학습", "마케팅", "게임", "보안", "비트코인", "채용", "투자", "PHP", "SQL", "리눅스",
      "디자인", "빅데이터", "DB", "SQL", "마이크로소프트", "사업", "규제", "메이커", "다음카카오", "앱", "애널리틱스", "창업"]
  end

  def generate(feed_url: feed_url)
    user = User.where(email: @user_email).first
    raise "Can't find user email(#{@user_email})" if user.nil?

    feed = Feedjira::Feed.fetch_and_parse(feed_url)
    
    feed.entries.each do |entry|
      Story.create_with_entry(entry: entry, user: user, tag_names: extract_tag_names(entry))
    end
  end

  def extract_tag_names(entry)
    tag_names = clean_tag_names(entry.content.present? ? entry.content : entry.summary)

    db_tag_names = []
    tag_names.each do |tag_name|
      tag = Tag.find_or_create_by!(tag: tag_name.downcase)
      db_tag_names << tag.tag
    end
    db_tag_names
  end

  def clean_tag_names(text)
    regexp_str = "(^|\s)(#{@tag_dictionary.join('|')})[^A-Za-z]{0,3}(\b|\s)"
    tag_names = text.scan(/#{regexp_str}/).collect { |el| el[1] }

    tag_names.uniq!
    tag_names.empty? ? ["기타"] : tag_names
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
    generator = StarterDataGenerator.new(ENV["GENERATOR_EMAIL"])
    [
      'http://helloworld.naver.com/rss',
      'http://besuccess.com/feed/',
      'http://zdnetkorea.feedsportal.com/c/34249/f/622757/index.rss',
      'http://feeds.feedburner.com/bloter',
      'http://www.memoriesreloaded.net/feeds/posts/default',
      'https://feeds.feedburner.com/imaso'
    ].each do |feed|
      generator.generate(feed_url: feed)
    end
    
  end
end
