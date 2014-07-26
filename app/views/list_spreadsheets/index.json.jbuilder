json.array!(@list_spreadsheets) do |list_spreadsheet|
  json.extract! list_spreadsheet, :id
  json.url list_spreadsheet_url(list_spreadsheet, format: :json)
end
