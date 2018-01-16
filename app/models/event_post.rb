class EventPost < Post

	def publication_year_month
		publication_date.strftime('%B %Y')
	end
end
