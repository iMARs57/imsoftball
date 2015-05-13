json.array!(@namecards) do |namecard|
  json.extract! namecard, :id, :name, :tel, :address, :company
  json.url namecard_url(namecard, format: :json)
end
