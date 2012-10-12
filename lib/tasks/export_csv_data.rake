require 'csv'
namespace :maphub do
  desc "Export maphub data to CSV files"
  task :export_csv_data => :environment do
    CSV.open("csv_export_" + Time.now.to_i.to_s + ".csv", "w", {col_sep: "|"}) do |csv|
      header  = ["userid", "annotationid", "creation_time", "condition", "text", "accepted_tags", "rejected_tags", "neutral_tags"]
      csv << header
      User.all.each do |user|
        user.annotations.all.each do |annotation|
          condition = ""
          if annotation.condition == 'manual-entry'
            condition = 'Condition A'
          elsif annotation.condition == 'user-suggest'
            condition = 'Condition B'
          elsif annotation.condition == 'semantic-tagging'
            condition = 'Condition C'
          elsif annotation.condition == 'semantic-tagging-wiki'
            condition = 'Condition D'
          end
          line = [user.email, annotation.id, annotation.created_at, condition, annotation.body]
          
          tags = annotation.tags.all
          line << tags.select{|tag| tag.accepted?}.collect{|tag| tag.label}.join(";")
          line << tags.select{|tag| tag.rejected?}.collect{|tag| tag.label}.join(";")
          line << tags.select{|tag| tag.neutral?}.collect{|tag| tag.label}.join(";")
          
          csv << line
        end #annotation loop
      end #user loop
    end #CSV open
  end #export_csv_data task
end #maphub namespace
