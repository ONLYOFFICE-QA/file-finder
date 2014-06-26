json.array!(@list_documents) do |list_document|
  json.extract! list_document, :id
  json.url list_document_url(list_document, format: :json)
end
