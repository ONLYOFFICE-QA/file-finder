require_relative '../../../SharedFunctional/TestrailAPI/API2.0/Testrail'
require 'teamlab'

module ListPresentationsHelper
  TAGS = %w(slide image shape group_shape chart table transition animation hyperlink media formula)
  TEAMLAB = {server: 'https://testinfo.teamlab.info', username: 'alexeysemin88@gmail.com', password: '123456'}

  def filter_presentations(params)
    @list_presentations = ListPresentation.all.to_a
    parse_parameters(params)
    return @list_presentations if @parsed_params.empty?
    @list_presentations.select! { |list_spreadsheet| compare_spreadsheet(list_spreadsheet) }
  end

  private

  def parse_parameters(params)
    @parsed_params = {}
    TAGS.each do |element|
      if params["#{element}_checkbox".to_sym].to_i == 1
        @parsed_params["#{element}s".to_sym] = {from: params["#{element}s_from"].to_i}
        @parsed_params["#{element}s".to_sym][:to] = params["#{element}s_to"].to_i if correct_value?(params["#{element}s_to"])
      end
    end
  end

  def compare_spreadsheet(list_spreadsheet)
    result = true
    @parsed_params.each do |key, value|
      list_presentation_value = list_spreadsheet.attributes['tags'][key]
      result &&= list_presentation_value >= value[:from] && (value.has_key?(:to) ? (list_presentation_value <= value[:to]) : true)
    end
    puts result
    result
  end

  def correct_value?(param)
    param != '' && param
  end
end
