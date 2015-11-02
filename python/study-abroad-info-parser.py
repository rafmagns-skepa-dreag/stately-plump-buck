from sys import argv

scriptname, infilename = argv
infile = open(infilename, 'r')

places = []

def parseEntry(entry):
	print("beginning parse\n")
	string = entry
	t = ""
	desc = ""
	temp = ""
	temp_data = ""
	i = 0
	MAX_LENGTH = len(entry)

	while string[i] != '<':
		t += string[i]
		i += 1

	placeEntry = SAEntry(t.strip())
	print("creted entry for {title}\n".format(title = t))
	desc = ""
	while i < MAX_LENGTH and string[i] != '|':
		desc += string[i]
		i += 1

	placeEntry.description = desc.strip()
	
	while i < MAX_LENGTH:
		temp = ""
		temp_data = ""

		while i < MAX_LENGTH and string[i] == '|':
			i += 1

		#find key
		while i < MAX_LENGTH and string[i] != '|':
			temp += string[i]
			i += 1
		# temp = temp.strip(' |')
		# print(temp)
		
		while i < MAX_LENGTH and string[i] == '|':
			i += 1

		#find data
		while i < MAX_LENGTH and string[i] != '|':
			temp_data += string[i]
			i += 1

		placeEntry.values[temp.strip(' |')] = temp_data.strip(' |')
			
	# print(placeEntry.values.items())
	return placeEntry

def printEntry(e, outfile, line):
	del e.values["Further Information"]
	for k in sorted(e.values.keys()):
		if e.values[k] != "":
			outfile.write("\"{d}\", \"{a}\", \"{b}\", \"{c}\"".format(d = str(line), a = e.title, b = k, c = e.values[k]))
			outfile.write("\n")
			line += 1
	return line



class SAEntry(object):
	fields = ["Housing", "Credits and Registration", "Finances", "Eligibility and Application", "Further Information",
			"Deadlines", "Center in Hong Kong", "Center in Beijing", "Center in Paris", "Application", "Eligibility",
			"Prospective Applicants", "Optional Chinese Language Pre-Session", "Optional French Language Pre-Session",
			"Optional German Language Pre-Session", "Returning Student Requirements"]

	def __init__(self, tle):
		self.title				= tle
		self.description		= ""
		self.values = {k:"" for k in SAEntry.fields}
		self.keys = sorted(self.values.keys())


f = open('new_output.csv', 'w')

first = True
lineno = 0

for l in infile:
	lineno = printEntry(parseEntry(l), f, lineno)

	
