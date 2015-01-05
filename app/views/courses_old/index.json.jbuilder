json.array!(@courses) do |course|
  json.extract! course, :id, :course_title, :crse, :subject
  json.url course_url(course, format: :json)
end
