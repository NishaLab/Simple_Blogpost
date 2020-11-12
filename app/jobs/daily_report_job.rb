class DailyReportJob < ApplicationJob
  queue_as :default

  def perform
    SessionsController.new.daily_report
  end
end
