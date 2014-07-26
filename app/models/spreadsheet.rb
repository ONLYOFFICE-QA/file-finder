class Spreadsheet
  include Mongoid::Document

  belongs_to :list_spreadsheet
end
