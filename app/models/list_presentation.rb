class ListPresentation
  include Mongoid::Document
  attr_accessor :path
  belongs_to :presentation

  validates :path, format: {
      with: %r{\.(pptx)\Z}i,
      message: 'Must be path to .pptx file.'
  }
  attr_reader :attributes
end
