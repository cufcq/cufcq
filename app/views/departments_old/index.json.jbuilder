json.array!(@departments) do |department|
  json.extract! department, :id, :name, :college, :campus
  json.url department_url(department, format: :json)
end
