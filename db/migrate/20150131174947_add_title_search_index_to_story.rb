class AddTitleSearchIndexToStory < ActiveRecord::Migration
  def change
    reversible do |story|
      story.up do
        execute <<-SQL
          create index story_title_gin_eng_idx on stories using gin(to_tsvector('english', title));
        SQL
      end
      story.down do
        execute <<-SQL
          drop index story_title_gin_eng_idx;
        SQL
      end
    end
  end
end
