require 'csv'

Course.delete_all
course_psv = CSV.read("#{Rails.root}/lib/data/coursesscrape.csv", col_sep: '|') 
course_psv.shift

course_psv.each do |row|
	course_code = row[0]
	course_name = row[2]
	course_description = row[3]

	Course.create! ({code: course_code,
										name: course_name,
										description: course_description
		})

end