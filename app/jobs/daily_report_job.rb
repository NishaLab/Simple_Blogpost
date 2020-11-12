class DailyReportJob < ApplicationJob
  queue_as :default

  def perform
    SessionsController.new.create_report
  end
end
