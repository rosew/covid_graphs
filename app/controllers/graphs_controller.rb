require 'json'
require 'ostruct'

class GraphsController < ApplicationController
  DAYS_RANGE = 7
  
  def show
    @location = params[:id]&.upcase || "US"
    
    if @location == "US"
      @response = RestClient.get 'https://covidtracking.com/api/us/daily', {accept: :json}
    else
      @response = RestClient.get "https://covidtracking.com/api/states/daily.json?state=#{@location}", {accept: :json}
    end

    @rows = JSON.parse(@response.body, object_class: OpenStruct)
    @rows.each_with_index do |row, index|
      row.positives_this_week = @rows[index..DAYS_RANGE+index-1].inject(0){ |sum, item| sum + (item.positiveIncrease || 0) }
    end

    rate_overall = @rows.select{ |row| row.totalTestResults && row.positive }.
                 map{ |row| { Date.parse(row.date.to_s) => (100.0 * row.positive / row.totalTestResults) } }.
                 reduce({}, :merge)
    rate_daily = @rows.select{ |row| row.totalTestResultsIncrease && row.positiveIncrease }.
                       map{ |row, index|
                         { Date.parse(row.date.to_s) => (100.0 * row.positiveIncrease / row.totalTestResultsIncrease) } 
                       }.
                       reduce({}, :merge)

    rate_weekly = @rows.enum_for(:each_with_index).map{ |row, index|
                         positive = @rows[index..DAYS_RANGE+index-1].inject(0){ |sum, item| sum + (item.positiveIncrease || 0) }
                         total = @rows[index..DAYS_RANGE+index-1].inject(0){ |sum, item| sum + (item.totalTestResultsIncrease || 0) }
                         { Date.parse(row.date.to_s) => total == 0 ? 0 : (100.0 * positive / total) } 
                       }.
                       reduce({}, :merge)

    @rates = [
      { name: "Rate Overall", data: rate_overall },
      { name: "Rate Last #{DAYS_RANGE} Days", data: rate_weekly }
    ]
                  
  end
  
  private
  
end
