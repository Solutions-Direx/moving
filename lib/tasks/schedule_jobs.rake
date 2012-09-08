namespace :schedule_jobs do
  desc "Generate reports for confirmed quote if necessary"
  task :generate_reports => :environment do
    Quote.confirmed.each do |quote|
      if quote.report.blank?
        quote.create_report!(gas: quote.gas, start_time: quote.removal_at) 
        puts "Created report for quote ##{quote.code}."
      end
    end
  end
end