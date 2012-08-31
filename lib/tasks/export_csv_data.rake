require 'csv'
namespace :maphub do
  namespace :users do
    task :export_csv_data => :environment do
      CSV.open("csv_export_" + Time.now.to_i.to_s + ".csv", "w") do |csv|
        header  = "userid | annotationid | creation_time | condition | text | accepted_tags | rejected_tags | neutral_tags"
        csv << [header]
        User.all.each do |user|
          user.annotations.all.each do |annotation|
         
            line = "#{user.email} | #{annotation.id} | #{annotation.created_at} | #{annotation.condition} | #{annotation.body} | "
            annotation.tags.all.each do |tag|
              if tag.accepted?
                line << "#{tag.label} "
              end
            end
            line << "| "
            annotation.tags.all.each do |tag|
              if tag.rejected?
                line << "#{tag.label} "
              end
            end
            line << "| "
            annotation.tags.all.each do |tag|
              if tag.neutral?
                line << "#{tag.label} "
              end
            end
            csv << [line]
          end #annotation loop
        end #user loop
      end #CSV open
    end #export_csv_data task
  end #users namespace
end #maphub namespace
