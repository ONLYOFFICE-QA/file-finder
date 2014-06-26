class Document
  include Mongoid::Document

  belongs_to :list_document
end
