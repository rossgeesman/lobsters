# encoding: utf-8


class StarterDataGenerator
  def initialize(user_email)
    @user_email = user_email
    @tag_dictionary = ["스타트업", "DBMS", "자바", "자바스크립트", "루비", "파이썬", "오픈소스", "C", "iOS", "안드로이드", "UX/UI",
     "하드웨어", "IoT", "web", "기계학습", "마케팅", "게임", "보안", "비트코인", "채용", "투자", "PHP", "SQL", "리눅스",
      "디자인", "빅데이터", "DB", "SQL", "마이크로소프트", "사업", "규제", "메이커", "다음카카오", "앱", "애널리틱스", "창업"]
    @particles = ["을", "를", "이", "가", "은", "는", "의", "들", "\"", "에"]
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
    tag_names = []
    if entry.content.present?
      tag_names = clean_tag_names(entry.content)
    else
      tag_names = clean_tag_names(entry.summary)
    end

    db_tag_names = []
    tag_names.each do |tag_name|
      tag = Tag.find_or_create_by!(tag: tag_name.downcase)
      db_tag_names << tag.tag
    end
    db_tag_names
  end

  def clean_tag_names(text)
    text = text.gsub(Regexp.union(@particles),' ')
    tag_names = text.split(" ") & @tag_dictionary
    uniq_tag_names = tag_names.uniq
    uniq_tag_names = ["기타"] if uniq_tag_names.empty?
    uniq_tag_names
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
