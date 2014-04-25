json.array!(@fcqs) do |fcq|
  json.extract! fcq, :id, :yearterm, :subject, :crse, :sec, :instructor_last, :instructor_first, :forms_requested, :forms_returned, :percentage_passed, :course_overall, :course_overall_SD, :instructor_overall, :instructor_overall_SD, :total_hours, :prior_interest, :effectiveness, :availability, :challenge, :amount_learned, :respect, :course_title, :campus, :college, :instructor_group
  json.url fcq_url(fcq, format: :json)
end
