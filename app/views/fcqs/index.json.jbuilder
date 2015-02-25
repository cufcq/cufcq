json.array!(@fcqs) do |fcq|
  json.extract! fcq, :id, :yearterm, :subject, :crse, :sec, :instructor_last, :instructor_first, :formsrequested, :formsreturned, :percentage_passed, :courseoverall, :courseoverall_SD, :instructoroverall, :instructoroverall_SD, :hoursperwkinclclass, :priorinterest, :instreffective, :availability, :challenge, :howmuchlearned, :instrrespect, :course_title, :campus, :college, :instr_group
  json.url fcq_url(fcq, format: :json)
end
