json.array!(@list_presentations) do |list_presentation|
  json.extract! list_presentation, :id
  json.url list_presentation_url(list_presentation, format: :json)
end
