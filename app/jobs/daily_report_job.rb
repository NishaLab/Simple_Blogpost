class DailyReportJob < ApplicationJob
  queue_as :default

  def perform
    DailyReportSlackService.new.create_report
  end
end
