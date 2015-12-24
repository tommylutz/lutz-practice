

def find_flasher_string_in_file(fn):
	print "Opening file...\n"
	f = open(fn,"rb");

	ingood = 0
	str = ""
	lastchar = '';

	try:
		byte = ord(f.read(1))
		print "Got byte: %2x\n"%(byte)
		ingood = 0
		while byte != "":
			byte = f.read(1)
			if((byte == "3" or byte == "0" or byte == "6") and (lastchar != byte)):
				ingood += 1
				lastchar = byte
				str += byte
			else:
				if ingood > 90:
					print "Found it! "+str
					return str
				lastchar = ''
				ingood=0
				str = ''
	finally:
		f.close()
	return ''


	
	
raw_input("Press enter to exit")
