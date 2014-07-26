class ListSpreadsheet
  include Mongoid::Document
  attr_accessor :path
  belongs_to :spreadsheet

  validates :path, format: {
      with: %r{\.(xlsx)\Z}i,
      message: 'Must be path to .xlsx file.'
  }
  attr_reader :attributes
end
