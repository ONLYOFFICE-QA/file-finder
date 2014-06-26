class ListDocument
  include Mongoid::Document
  attr_accessor :path
  belongs_to :document

  validates :path, format: {
      with: %r{\.(docx)\Z}i,
      message: 'Must be path to .docx file.'
  }
  attr_reader :attributes
end
