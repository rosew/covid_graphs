require 'json'
require 'ostruct'

class GraphsController < ApplicationController
  def show
    @location = params[:id]&.upcase || "US"
    
    if @location == "us"
      @response = RestClient.get 'https://covidtracking.com/api/us/daily', {accept: :json}
    else
      @response = RestClient.get "https://covidtracking.com/api/states/daily.json?state=#{@location}", {accept: :json}
    end

    @rows = JSON.parse(@response.body, object_class: OpenStruct)
    # Dups? hospitalizedCumulative
  end
end
