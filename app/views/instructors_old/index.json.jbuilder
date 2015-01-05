json.array!(@instructors) do |instructor|
  json.extract! instructor, :id, :instructor_first, :instructor_last
  json.url instructor_url(instructor, format: :json)
end
